//
//  ProfileViewModel.swift
//  OnlyFeet
//
//  Created by Fuad on 10/07/2022.
//

import Foundation
import Combine
import UIKit

protocol ProfileVMBased {
    func signOut()
}

class ProfileViewModel: ObservableObject {
    let profileService = ProfileService.shared
    
    var subscriptions = Set<AnyCancellable>()
    
    @Published var didSignOut = false
    @Published var isSigningOut = false
    
    @Published var profileError: ProfileServiceError? = nil
    
    @Published var isChanging = false
}

extension ProfileViewModel: ProfileVMBased {
    func signOut() {
        if self.isSigningOut { return }
        if self.isChanging { return }
        
        self.isSigningOut = true; self.didSignOut = false; self.isChanging = true
        
        profileService.signOut()
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .timeout(.seconds(maxWaitTimeForRequest), scheduler: DispatchQueue.main, options: nil, customError: {
                ProfileServiceError.maxWaitTimeReachedError
            })
            .sink { [weak self] completion in
                self?.isSigningOut = false
                self?.isChanging = false 
                
                switch completion {
                case .failure(let error):
                    self?.profileError = error
                case .finished:
                    self?.didSignOut = true
                }
            } receiveValue: { _ in
                // do nothing
            }
            .store(in: &subscriptions)

    }
}
