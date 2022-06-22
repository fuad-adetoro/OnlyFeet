//
//  AuthenticationViewModel.swift
//  OnlyFeet
//
//  Created by Fuad on 21/06/2022.
//

import Foundation
import Combine

protocol AuthenticationBased {
    func signUserIn(email: String, password: String)
    func createAccount(email: String, password: String, confirmedPassword: String)
}

class AuthenticationViewModel: ObservableObject, AuthenticationBased {
    static let shared = AuthenticationViewModel.init()
    
    @Published var isChanging = false
    
    @Published var feetishAccount: FeetishAccount? = nil
    
    @Published var feetishAuthError: FeetishAuthError? = nil
    
    var subscriptions = Set<AnyCancellable>()

    func signUserIn(email: String, password: String) {
        if isChanging { return }
        
        isChanging = true
        
        FeetishAuthentication.shared.signUserIn(email: email, password: password)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .retry(1)
            .map { FeetishAccount(dataDict: $0) }
            .sink { [unowned self] completion in
                isChanging = false
                
                switch completion {
                case .failure(let error):
                    self.feetishAuthError = error
                default:
                    print("DO NOTHING")
                }
            } receiveValue: { [unowned self] feetishAccount in
                self.feetishAccount = feetishAccount
            }
            .store(in: &subscriptions)
    }
    
    func createAccount(email: String, password: String, confirmedPassword: String) {
        if self.isChanging { return }
        
        isChanging = true
        
        FeetishAuthentication.shared.createNewAccount(email: email, password: password)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .retry(2)
            .map { FeetishAccount(dataDict: $0) }
            .sink { [unowned self] completion in
                isChanging = false
                
                switch completion {
                case .failure(let error):
                    self.feetishAuthError = error
                default:
                    print("DO NOTHING")
                }
            } receiveValue: { [unowned self] feetishAccount in 
                self.feetishAccount = feetishAccount
            }
            .store(in: &subscriptions)
            
    }
}
