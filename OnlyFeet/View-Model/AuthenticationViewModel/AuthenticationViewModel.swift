//
//  AuthenticationViewModel.swift
//  OnlyFeet
//
//  Created by Fuad on 21/06/2022.
//

import Foundation
import Combine
import UIKit

let maxWaitTimeForRequest = 12.5

public protocol AuthenticationBased {
    func signUserIn(email: String, password: String)
    func createAccount(email: String, password: String, confirmedPassword: String)
    func sendPasswordRecovery(email: String)
    func uploadAuthData(_ dataDict: [String: Any])
    func uploadProfilePhoto(_ profileImage: UIImage)
}

public class AuthenticationViewModel<FA>: ObservableObject, AuthenticationBased {
    //static let shared = AuthenticationViewModel.init()
    var feetishAuthentication: FA// = FeetishAuthentication.shared
    
    @Published var isChanging = false
    
    @Published var feetishAccount: FeetishAccount? = nil
    
    @Published var feetishAuthError: FeetishAuthError? = nil
    @Published var feetishPhotoUploadError: FeetishAuthError? = nil
    
    @Published var didErrorOccur = false
    @Published var didPhotoUploadErrorOccur = false
    @Published var didFetchAccount = false
    @Published var didResetPassword = false
    @Published var isUploadingAuthData = false
    @Published var didCompleteUploadingAuthData = false
    @Published var isUploadingProfilePhoto = false
    @Published var didUploadProfilePhoto = false
    
    @Published var isAuthDataUploadComplete = false
    
    var subscriptions = Set<AnyCancellable>()
    
    init(feetishAuthentication: FA) {
        self.feetishAuthentication = feetishAuthentication
    }
    
    public func signUserIn(email: String, password: String) {
        // do nothing
    }
    
    public func createAccount(email: String, password: String, confirmedPassword: String) {
        // do nothing
    }
    
    public func sendPasswordRecovery(email: String) {
        // do nothing
    }
    
    public func uploadAuthData(_ dataDict: [String: Any]) {
        // do nothing
    }
    
    public func uploadProfilePhoto(_ profileImage: UIImage) {
        // do nothing
    }
} 

extension AuthenticationViewModel where FA: FeetishAuthentication {
    public func signUserIn(email: String, password: String) {
        if isChanging { return }
        
        let doesThrowError = self.throwErrorIfValueInvalid(password: password, email: email)
        
        if doesThrowError {
            return
        }
        
        isChanging = true; self.feetishAuthError = nil; self.feetishAccount = nil; self.didErrorOccur = false; self.didFetchAccount = false;
        
        feetishAuthentication.signUserIn(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .map { FeetishAccount(dataDict: $0) }
            .sink { [weak self] completion in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.isChanging = false
                
                switch completion {
                case .failure(let error):
                    strongSelf.feetishAuthError = error
                    strongSelf.didErrorOccur = true
                    strongSelf.didFetchAccount = false
                default:
                    break
                }
            } receiveValue: { [weak self] feetishAccount in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.feetishAccount = feetishAccount
                strongSelf.didFetchAccount = true
                strongSelf.didErrorOccur = false
            }
            .store(in: &subscriptions)
    }
    
    public func createAccount(email: String, password: String, confirmedPassword: String) {
        if self.isChanging { return }
        
        let doesThrowError = self.throwErrorIfValueInvalid(password: password, confirmPassword: confirmedPassword, email: email)
        
        if doesThrowError {
            return
        }
        
        isChanging = true; self.feetishAuthError = nil; self.feetishAccount = nil; self.didErrorOccur = false; self.didFetchAccount = false;
        
        feetishAuthentication.createNewAccount(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .map { FeetishAccount(dataDict: $0) }
            .sink { [weak self] completion in
                self?.isChanging = false
                
                switch completion {
                case .failure(let error):
                    self?.feetishAuthError = error
                    self?.didErrorOccur = true
                    self?.didFetchAccount = false
                default:
                    break
                }
            } receiveValue: { [weak self] feetishAccount in
                self?.feetishAccount = feetishAccount
                self?.didFetchAccount = true
                self?.didErrorOccur = false
            }
            .store(in: &subscriptions)
            
    }
    
    public func sendPasswordRecovery(email: String) {
        if self.isChanging { return }
        
        let doesThrowError = self.throwErrorIfValueInvalid(email: email)
        
        if doesThrowError {
            return
        }
        
        isChanging = true; self.feetishAuthError = nil; self.feetishAccount = nil; self.didErrorOccur = false; self.didFetchAccount = false;
        
        feetishAuthentication.resetUserPassword(email: email)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isChanging = false
                
                switch completion {
                case .failure(let error):
                    self?.feetishAuthError = error
                    self?.didErrorOccur = true
                    self?.didResetPassword = false
                default:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.didResetPassword = true
            }
            .store(in: &subscriptions)


    }
    
    public func uploadAuthData(_ dataDict: [String: Any]) {
        if !self.checkIfConnectedToNetwork() {
            self.feetishAuthError = .networkError
            self.didErrorOccur = true
            
            return
        }
        
        if self.isChanging { return }
        
        isChanging = true; self.feetishAuthError = nil; self.didErrorOccur = false; self.didCompleteUploadingAuthData = false; self.isUploadingAuthData = true; self.isAuthDataUploadComplete = false
        
        feetishAuthentication.uploadAuthData(data: dataDict)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                
                print("COMPLETION!!")
                self?.isChanging = false
                self?.isUploadingAuthData = false
                
                if let strongSelf = self, !strongSelf.isUploadingProfilePhoto {
                    print("IS ACCOUNT JOURNEY COMPLETE?")
                    
                    strongSelf.isAuthDataUploadComplete = true
                    
                    FeetishUserJourney.shared.accountJourneyComplete()
                }
                
                switch completion {
                case .failure(let error):
                    self?.feetishAuthError = error
                    self?.didErrorOccur = true
                    self?.didCompleteUploadingAuthData = false
                default:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.didCompleteUploadingAuthData = true
            }
            .store(in: &subscriptions)
    }
    
    public func uploadProfilePhoto(_ profileImage: UIImage) {
        if !self.checkIfConnectedToNetwork() {
            self.feetishPhotoUploadError = .networkError
            self.didPhotoUploadErrorOccur = true
            
            return
        }
        
        if self.isUploadingProfilePhoto { return }
        
        isUploadingProfilePhoto = true; self.feetishPhotoUploadError = nil; self.didPhotoUploadErrorOccur = false; self.didUploadProfilePhoto = false; self.isAuthDataUploadComplete = false
        
        feetishAuthentication.uploadProfilePhoto(image: profileImage)
            .receive(on: DispatchQueue.main) 
            .sink { [weak self] completion in
                self?.isUploadingProfilePhoto = false
                
                if let strongSelf = self, !strongSelf.isChanging {
                    print("IS COMPLETE FULLY!")
                    strongSelf.isAuthDataUploadComplete = true
                    
                    FeetishUserJourney.shared.accountJourneyComplete()
                }
                
                switch completion {
                case .failure(let error):
                    self?.didPhotoUploadErrorOccur = true
                    self?.feetishPhotoUploadError = error
                default:
                    break;
                }
            } receiveValue: { [weak self] _ in
                self?.didUploadProfilePhoto = true
            }
            .store(in: &subscriptions)

    }
}

extension AuthenticationViewModel {
    private func throwError(error: FeetishAuthError) {
        self.feetishAccount = nil; self.feetishAuthError = error; self.didErrorOccur = true;
    }
    
    private func throwErrorIfValueInvalid(password: String? = nil, confirmPassword: String? = nil, email: String? = nil) -> Bool {
        if let confirmPassword = confirmPassword, let password = password {
            if password != confirmPassword {
                self.throwError(error: .passwordDoesNotMatchError); return true
            }
            
            if password.count < 6 {
                self.throwError(error: .passwordToShortError); return true
            }
        } else if let password = password {
            if password.count < 6 {
                self.throwError(error: .passwordToShortError); return true
            }
        }
        
        if let email = email {
            if !email.isValidEmail() {
                self.throwError(error: .emailInvalidError); return true
            }
        }
        
        if !self.checkIfConnectedToNetwork() {
            return false
        }
        
        return false
    }
    
    func checkIfConnectedToNetwork() -> Bool  {
        if !SystemReachability.isConnectedToNetwork() {
            self.throwError(error: .networkError);
            return false
        } else {
            return true
        }
    }
}
