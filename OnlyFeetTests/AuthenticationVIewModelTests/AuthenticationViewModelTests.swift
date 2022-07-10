//
//  AuthenticationViewModelTests.swift
//  OnlyFeetTests
//
//  Created by Fuad on 23/06/2022.
//

import XCTest
@testable import OnlyFeet
import Combine

class AuthenticationViewModelTests: XCTestCase {
    private var viewModel: AuthenticationTestViewModel!
    var email: String?
    
    override func setUp() {
        self.viewModel = AuthenticationTestViewModel(feetishAuthentication: MockAuthentication())
        self.email = "fuad@feetish.com"
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.email = nil
    }
    
    func testViewModelInit() {
        XCTAssertNil(viewModel.feetishAccount)
        XCTAssertNil(viewModel.feetishAuthError)
        
        XCTAssertEqual(viewModel.didErrorOccur, false)
    }
    
    func testSignIn() {
        viewModel.signUserIn(email: email!, password: "123456") 
        
        XCTAssertNil(viewModel.feetishAuthError)
        XCTAssertEqual(viewModel.feetishAccount?.email, email)
        XCTAssertEqual(viewModel.didErrorOccur, false)
        XCTAssertEqual(viewModel.didFetchAccount, true)
    }
    
    func testCreateAccount() {
        viewModel.createAccount(email: email!, password: "123456", confirmedPassword: "123456")
        
        XCTAssertNil(viewModel.feetishAuthError)
        XCTAssertEqual(viewModel.feetishAccount?.email, email)
        XCTAssertEqual(viewModel.didErrorOccur, false)
        XCTAssertEqual(viewModel.didFetchAccount, true)
    }
    
    func testPasswordRecovery() {
        viewModel.sendPasswordRecovery(email: email!)
        
        XCTAssertNil(viewModel.feetishAuthError)
        XCTAssertEqual(viewModel.didErrorOccur, false)
        XCTAssertEqual(viewModel.didResetPassword, true)
    }

    func testAuthDataUpload() {
        viewModel.uploadAuthData(["displayName": "Fuad Adetoro"])
        
        XCTAssertTrue(viewModel.didCompleteUploadingAuthData)
    }
}

private final class AuthenticationTestViewModel: AuthenticationViewModel<MockAuthentication> {
    override func signUserIn(email: String, password: String) {
        if isChanging { return }
        
        isChanging = true; self.feetishAuthError = nil; self.feetishAccount = nil; self.didErrorOccur = false; self.didFetchAccount = false;
         
        Just(["email": email])
            .map { FeetishAccount(dataDict: $0) }
            .sink { _ in
                // do nothing
            } receiveValue: { feetishAccount in
                self.feetishAccount = feetishAccount
                self.didFetchAccount = true
                self.didErrorOccur = false
            }
            .store(in: &subscriptions)
    }
    
    override func createAccount(email: String, password: String, confirmedPassword: String) {
        if self.isChanging { return }
        
        isChanging = true; self.feetishAuthError = nil; self.feetishAccount = nil; self.didErrorOccur = false; self.didFetchAccount = false;
         
        Just(["email": email])
            .eraseToAnyPublisher()
            .map { FeetishAccount(dataDict: $0) }
            .sink { _ in
                // do nothing
            } receiveValue: { feetishAccount in
                self.feetishAccount = feetishAccount
                self.didFetchAccount = true
                self.didErrorOccur = false
            }
            .store(in: &subscriptions)
            
    }
    
    override func sendPasswordRecovery(email: String) {
        super.sendPasswordRecovery(email: email)
        
        if self.isChanging { return }
        
        isChanging = true; self.feetishAuthError = nil; self.feetishAccount = nil; self.didErrorOccur = false; self.didFetchAccount = false;
         
        Just(true)
            .eraseToAnyPublisher()
            .sink { _ in
                // do nothing
            } receiveValue: { _ in
                self.didResetPassword = true
            }
            .store(in: &subscriptions)


    }
    
    override func uploadAuthData(_ dataDict: [String : Any]) {
        super.uploadAuthData(dataDict)
        
        if self.isChanging { return }
        
        isChanging = true; self.feetishAuthError = nil; self.feetishAccount = nil; self.didErrorOccur = false; self.didFetchAccount = false;
         
        Just(true)
            .eraseToAnyPublisher()
            .sink { _ in
                // do nothing
            } receiveValue: { _ in
                self.didCompleteUploadingAuthData = true
            }
            .store(in: &subscriptions)
    }
}
