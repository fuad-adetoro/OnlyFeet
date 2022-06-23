//
//  AuthenticationViewModel.swift
//  OnlyFeet
//
//  Created by Fuad on 21/06/2022.
//

import Foundation
import Combine

public protocol AuthenticationBased {
    func signUserIn(email: String, password: String)
    func createAccount(email: String, password: String, confirmedPassword: String)
    func sendPasswordRecovery(email: String)
}

public final class AuthenticationViewModel: ObservableObject, AuthenticationBased {
    static let shared = AuthenticationViewModel.init()
    
    private let maxWaitTimeForRequest = 12.5
    
    @Published var isChanging = false
    
    @Published var feetishAccount: FeetishAccount? = nil
    
    @Published var feetishAuthError: FeetishAuthError? = nil
    
    @Published var didErrorOccur = false
    @Published var didFetchAccount = false
    @Published var didResetPassword = false
    
    var subscriptions = Set<AnyCancellable>()

    public func signUserIn(email: String, password: String) {
        if isChanging { return }
        
        let doesThrowError = self.throwErrorIfValueInvalid(password: password, email: email)
        
        if doesThrowError {
            return
        }
        
        isChanging = true; self.feetishAuthError = nil; self.feetishAccount = nil; self.didErrorOccur = false; self.didFetchAccount = false;
        
        FeetishAuthentication().signUserIn(email: email, password: password)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .timeout(.seconds(maxWaitTimeForRequest), scheduler: DispatchQueue.main, options: nil, customError: {
                FeetishAuthError.maxWaitTimeReachedError
            })
            .map { FeetishAccount(dataDict: $0) }
            .sink { [unowned self] completion in
                isChanging = false 
                
                switch completion {
                case .failure(let error):
                    self.feetishAuthError = error
                    self.didErrorOccur = true
                    self.didFetchAccount = false
                default:
                    print("DO NOTHING")
                }
            } receiveValue: { [unowned self] feetishAccount in
                self.feetishAccount = feetishAccount
                self.didFetchAccount = true
                self.didErrorOccur = false
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
        
        FeetishAuthentication().createNewAccount(email: email, password: password)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .timeout(.seconds(maxWaitTimeForRequest + 2.5), scheduler: DispatchQueue.main, options: nil, customError: {
                FeetishAuthError.maxWaitTimeReachedError
            })
            .map { FeetishAccount(dataDict: $0) }
            .sink { [unowned self] completion in
                isChanging = false
                
                switch completion {
                case .failure(let error):
                    self.feetishAuthError = error
                    self.didErrorOccur = true
                    self.didFetchAccount = false 
                default:
                    print("DO NOTHING")
                }
            } receiveValue: { [unowned self] feetishAccount in 
                self.feetishAccount = feetishAccount
                self.didFetchAccount = true
                self.didErrorOccur = false
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
        
        FeetishAuthentication().resetUserPassword(email: email)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .timeout(.seconds(maxWaitTimeForRequest), scheduler: DispatchQueue.main, options: nil, customError: {
                FeetishAuthError.maxWaitTimeReachedError
            })
            .print("Specific to password recovery")
            .sink { [unowned self] completion in
                isChanging = false
                
                switch completion {
                case .failure(let error):
                    self.feetishAuthError = error
                    self.didErrorOccur = true
                    self.didResetPassword = false
                default:
                    print("DO NOTHING")
                }
            } receiveValue: { [unowned self] _ in
                self.didResetPassword = true
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
        
        if !SystemReachability.isConnectedToNetwork() {
            self.throwError(error: .networkError); return true
        }
        
        return false
    }
}
