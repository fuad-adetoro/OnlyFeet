//
//  MockAuthentication.swift
//  OnlyFeet
//
//  Created by Fuad on 26/06/2022.
//

import Foundation
import Combine
import UIKit.UIImage

final class MockAuthentication: FeetishAuthProvider {
    static let shared = MockAuthentication.init()
    
    func signUserIn(email: String, password: String) -> AnyPublisher<FeetishAuthDataDict, FeetishAuthError> {
        let authSubject = FeetishAuthSubject<FeetishAuthDataDict>()
        let publisher = authSubject.publisher
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(2)) {
            publisher.send(["email": email])
            publisher.send(completion: .finished)
        }
        
        return publisher.eraseToAnyPublisher()
    }
    
    func signUserOut() -> AnyPublisher<Bool, FeetishAuthError> {
        let authSubject = FeetishAuthSubject<Bool>()
        let publisher = authSubject.publisher
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(2)) {
            publisher.send(true)
            publisher.send(completion: .finished)
        }
        
        return authSubject.eraseToAnyPublisher()
    }
    
    func resetUserPassword(email: String) -> AnyPublisher<Bool, FeetishAuthError> {
        let authSubject = FeetishAuthSubject<Bool>()
        let publisher = authSubject.publisher
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(2)) {
            publisher.send(true)
            publisher.send(completion: .finished)
        }
        
        return authSubject.eraseToAnyPublisher()
    }
    
    func checkIfFeetishAuthValueExists(value: String, fieldName: String) -> AnyPublisher<Bool, FeetishAuthError> {
        let authSubject = FeetishAuthSubject<Bool>()
        let publisher = authSubject.publisher
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(2)) {
            publisher.send(true)
            publisher.send(completion: .finished)
        }
        
        return authSubject.eraseToAnyPublisher()
    }
    
    func createNewAccount(email: String, password: String) -> AnyPublisher<FeetishAuthDataDict, FeetishAuthError> {
        let authSubject = FeetishAuthSubject<FeetishAuthDataDict>()
        let publisher = authSubject.publisher
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(2)) {
            publisher.send(["email": email])
            publisher.send(completion: .finished)
        }
        
        return publisher.eraseToAnyPublisher()
    }
    
    func uploadAuthData(data: [String : Any]) -> AnyPublisher<Bool, FeetishAuthError> {
        let authSubject = FeetishAuthSubject<Bool>()
        let publisher = authSubject.publisher
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(2)) {
            publisher.send(true)
            publisher.send(completion: .finished)
        }
        
        return publisher.eraseToAnyPublisher()
    }
    
    func uploadProfilePhoto(image: UIImage) -> AnyPublisher<Bool, FeetishAuthError> {
        let authSubject = FeetishAuthSubject<Bool>()
        let publisher = authSubject.publisher
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(2)) {
            publisher.send(true)
            publisher.send(completion: .finished)
        }
        
        return publisher.eraseToAnyPublisher()
    }
}
