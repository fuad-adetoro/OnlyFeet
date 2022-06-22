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
}

public final class AuthenticationViewModel: ObservableObject, AuthenticationBased {
    static let shared = AuthenticationViewModel.init()
    
    private let maxWaitTimeForRequest = 12.5
    
    @Published var isChanging = false
    
    @Published var feetishAccount: FeetishAccount? = nil
    
    @Published var feetishAuthError: FeetishAuthError? = nil
    
    @Published var didErrorOccur = false
    @Published var didFetchAccount = false
    
    var subscriptions = Set<AnyCancellable>()

    public func signUserIn(email: String, password: String) {
        if isChanging { return }
        
        if !email.isValidEmail() {
            self.throwError(error: .emailInvalidError); return
        }
        
        if password.count < 6 {
            self.throwError(error: .passwordToShortError); return
        }
        
        if SystemReachability.isConnectedToNetwork() {
            self.throwError(error: .networkError); return
        }
        
        isChanging = true; self.feetishAuthError = nil; self.feetishAccount = nil; self.didErrorOccur = false; self.didFetchAccount = false;
        
        FeetishAuthentication.shared.signUserIn(email: email, password: password)
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
        
        if !email.isValidEmail() {
            self.throwError(error: .emailInvalidError); return
        }
        
        if password != confirmedPassword {
            self.throwError(error: .passwordDoesNotMatchError); return
        }
        
        if password.count < 6 {
            self.throwError(error: .passwordToShortError); return
        }
        
        if SystemReachability.isConnectedToNetwork() {
            self.throwError(error: .networkError); return
        }
        
        isChanging = true; self.feetishAuthError = nil; self.feetishAccount = nil; self.didErrorOccur = false; self.didFetchAccount = false;
        
        FeetishAuthentication.shared.createNewAccount(email: email, password: password)
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
    
    private func throwError(error: FeetishAuthError) {
        self.feetishAccount = nil; self.feetishAuthError = error; self.didErrorOccur = true;
    }
}
