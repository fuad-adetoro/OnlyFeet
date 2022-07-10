//
//  ProfileService.swift
//  OnlyFeet
//
//  Created by Fuad on 10/07/2022.
//
import Firebase
import Combine

protocol ProfileServiceBased {
    func signOut() -> AnyPublisher<Bool, ProfileServiceError>
    func createUsername(_ username: String) -> AnyPublisher<Bool, ProfileServiceError>
}

public final class ProfileService {
    let databaseRef = Firestore.firestore()
    
    static let shared = ProfileService()
}

extension ProfileService: ProfileServiceBased {
    func signOut() -> AnyPublisher<Bool, ProfileServiceError> {
        let feetishSubject = FeetishSubject<Bool, ProfileServiceError>()
        let publisher = feetishSubject.publisher
        
        do {
            try Auth.auth().signOut()
            
            FeetishUserJourney.shared.signOutOccured()
            
            publisher.send(true)
            publisher.send(completion: .finished)
        } catch {
            publisher.send(completion: .failure(.errorSigningOut))
        }
        
        return feetishSubject.eraseToAnyPublisher()
    }
    
    func createUsername(_ username: String) -> AnyPublisher<Bool, ProfileServiceError> {
        let feetishSubject = FeetishSubject<Bool, ProfileServiceError>()
        let publisher = feetishSubject.publisher
        
        if !username.isValidUsername() {
            publisher.send(completion: .failure(.invalidUsername))
            
            return feetishSubject.eraseToAnyPublisher()
        }
        
        let dataDict = ["username": username]
        
        guard let uid = Auth.auth().currentUser?.uid else {
            publisher.send(completion: .failure(.notSignedIn))
            
            return feetishSubject.eraseToAnyPublisher()
        }
        
        let userRef = databaseRef.collection("users")
        let profileRef = userRef.document(uid)
        
        userRef.whereField("username", isEqualTo: username).getDocuments { querySnapshot, error in
            guard let snapshot = querySnapshot, error == nil else {
                publisher.send(completion: .failure(.unknownError))
                return
            }
            
            if snapshot.isEmpty {
                // username doesn't exist
                
                profileRef.updateData(dataDict) { error in
                    guard error == nil else {
                        publisher.send(completion: .failure(.couldNotUpdate))
                        
                        return
                    }
                    
                    FeetishUserJourney.shared.accountUsernameCreated()
                    
                    publisher.send(true)
                    publisher.send(completion: .finished)
                }
            } else {
                publisher.send(completion: .failure(.usernameExists))
            }
        }
        
        
        return feetishSubject.eraseToAnyPublisher()
    }
}
