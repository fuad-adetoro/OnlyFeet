//
//  FeetishAuthentication.swift
//  OnlyFeet
//
//  Created by Fuad on 22/06/2022.
//

import Foundation
import Firebase
import Combine
  
protocol FeetishAuthProvider {
    typealias FeetishAuthDataDict = [String: Any]
    
    func signUserOut() -> AnyPublisher<Bool, FeetishAuthError>
    func resetUserPassword(email: String) -> AnyPublisher<Bool, FeetishAuthError>
    func checkIfFeetishAuthValueExists(value: String, fieldName: String) -> AnyPublisher<Bool, FeetishAuthError>
    func signUserIn(email: String, password: String) -> AnyPublisher<FeetishAuthDataDict, FeetishAuthError>
    func createNewAccount(email: String, password: String) -> AnyPublisher<FeetishAuthDataDict, FeetishAuthError>
}

public final class FeetishAuthentication { 
    let databaseRef = Firestore.firestore()
    
    static let shared = FeetishAuthentication.init()
}

extension FeetishAuthentication: FeetishAuthProvider {
    func signUserOut() -> AnyPublisher<Bool, FeetishAuthError> {
        let firebaseAuth = Auth.auth()
        let feetishAuthSubject = FeetishAuthSubject<Bool>()
        let publisher = feetishAuthSubject.publisher
         
        do {
            try firebaseAuth.signOut()
            
            publisher.send(true)
            publisher.send(completion: .finished)
        } catch let error { 
            publisher.send(completion: .failure(FeetishAuthError.signOutError(errorMessage: error.localizedDescription)))
        }
        
        return feetishAuthSubject.eraseToAnyPublisher()
    }
    
    func resetUserPassword(email: String) -> AnyPublisher<Bool, FeetishAuthError> {
        let feetishAuthSubject = FeetishAuthSubject<Bool>()
        let publisher = feetishAuthSubject.publisher
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                publisher.send(completion: .failure(.resetPasswordError(errorMessage: error!.localizedDescription)))
                return
            }
            
            publisher.send(true)
            publisher.send(completion: .finished)
        }
        
        return feetishAuthSubject.eraseToAnyPublisher()
    }
    
    // Can check for username or email, etc.
    func checkIfFeetishAuthValueExists(value: String, fieldName: String) -> AnyPublisher<Bool, FeetishAuthError> {
        let collection = self.databaseRef.collection("users").whereField(fieldName, isEqualTo: value)
        
        let feetishAuthSubject = FeetishAuthSubject<Bool>()
        let publisher = feetishAuthSubject.publisher
        
        collection.getDocuments { snapshot, error in
            guard error == nil else {
                publisher.send(completion: .failure(.resetPasswordError(errorMessage: error!.localizedDescription)))
                return
            }
            
            guard let snapshot = snapshot else {
                publisher.send(completion: .failure(.accountDoesNotExistError))
                
                return
            }
            
            if snapshot.isEmpty {
                publisher.send(true)
            } else {
                publisher.send(false)
            }
            
            publisher.send(completion: .finished)
        }
        
        return feetishAuthSubject.eraseToAnyPublisher()
    }
    
    func signUserIn(email: String, password: String) -> AnyPublisher<FeetishAuthDataDict, FeetishAuthError> {
        let feetishAuthSubject = FeetishAuthSubject<FeetishAuthDataDict>()
        let publisher = feetishAuthSubject.publisher
        
        Auth.auth().signIn(withEmail: email, password: password) { dataResult, error in
            guard error == nil else { 
                publisher.send(completion: .failure(.signInError(errorMessage: error!.localizedDescription)))
                return
            }
            
            guard let uid = dataResult?.user.uid else {
                publisher.send(completion: .failure(.accountDoesNotExistError))
                return
            }
            
            self.databaseRef.collection("users").document(uid).getDocument { docSnapshot, docError in
                guard docError == nil else {
                    publisher.send(completion: .failure(.signInError(errorMessage: docError!.localizedDescription)))
                    let _ = self.signUserOut()
                    
                    return
                }
                
                guard let data = docSnapshot?.data() else {
                    publisher.send(completion: .failure(.accountDataDoesNotExistError))
                    return
                }
                
                publisher.send(data)
                publisher.send(completion: .finished)
            }
        }
        
        return feetishAuthSubject.eraseToAnyPublisher()
    }
    
    func createNewAccount(email: String, password: String) -> AnyPublisher<FeetishAuthDataDict, FeetishAuthError> {
        let feetishAuthSubject = FeetishAuthSubject<FeetishAuthDataDict>()
        let publisher = feetishAuthSubject.publisher
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                publisher.send(completion: .failure(.accountCreationFailureError(errorMessage: error!.localizedDescription)))
                return
            }
            
            guard let result = result else {
                publisher.send(completion: .failure(.unknownError))
                return
            }
            
            let user = result.user
            
            let timeCreated = getCurrentTimeInterval()
            
            let dataDict: [String: Any] = ["userID": user.uid, "email": email, "dateCreated": timeCreated]
            
            self.databaseRef.collection("users").document(user.uid).setData(dataDict) { dataError in
                guard dataError == nil else {
                    publisher.send(completion: .failure(.accountCreationInitialDataUploadError(errorMessage: dataError!.localizedDescription)))
                    return
                }
                
                publisher.send(dataDict)
                publisher.send(completion: .finished)
            }
        }
        
        return feetishAuthSubject.eraseToAnyPublisher()
    }
}
