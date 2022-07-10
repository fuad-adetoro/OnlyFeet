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
    func createUsername(_ username: String)
}

class ProfileViewModel: ObservableObject {
    let profileService = ProfileService.shared
    
    var subscriptions = Set<AnyCancellable>()
    
    @Published var didSignOut = false
    @Published var isSigningOut = false
    
    @Published var isUsernameUpdateComplete = false
    @Published var isUsernameUpdating = false
    
    @Published var profileError: ProfileServiceError? = nil
    
    @Published var isChanging = false
}

extension ProfileViewModel: ProfileVMBased {
    func signOut() {
        if !checkIfConnectedToNetwork() {
            return
        }
        
        if self.isSigningOut { return }
        if self.isChanging { return }
        
        self.isSigningOut = true; self.didSignOut = false; self.isChanging = true; self.profileError = nil;
        
        profileService.signOut()
            .receive(on: DispatchQueue.main)
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
    
    func createUsername(_ username: String) {
        if !checkIfConnectedToNetwork() {
            return
        }
        
        if self.isChanging { return }
        
        self.isChanging = true; self.profileError = nil; self.isUsernameUpdateComplete = false; self.isUsernameUpdating = true
        
        ProfileService.shared.createUsername(username)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isUsernameUpdating = false
                self?.isChanging = false
                
                switch completion {
                case .failure(let error):
                    self?.profileError = error
                case .finished:
                    break;
                }
            } receiveValue: { [weak self] _ in
                self?.isUsernameUpdateComplete = true
            }
            .store(in: &subscriptions)


    }
}

extension ProfileViewModel {
    private func throwError(error: ProfileServiceError) {
        self.profileError = error
    }
    
    private func checkIfConnectedToNetwork() -> Bool  {
        if !SystemReachability.isConnectedToNetwork() {
            self.throwError(error: .networkError);
            return false
        } else {
            return true
        }
    }
}
