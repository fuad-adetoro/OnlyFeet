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
}
