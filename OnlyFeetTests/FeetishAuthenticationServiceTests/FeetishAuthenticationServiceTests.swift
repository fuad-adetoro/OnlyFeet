//
//  FeetishAuthenticationServiceTests.swift
//  OnlyFeetTests
//
//  Created by Fuad on 22/06/2022.
//

import XCTest
@testable import OnlyFeet
import Combine

class FeetishAuthenticationServiceTests: XCTestCase {
    private var feetishAuthentication: MockAuthentication!
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        self.feetishAuthentication = MockAuthentication.shared
        cancellables = []
    }
    
    override func tearDown() {
        self.feetishAuthentication = nil
    }
    
    func testSignInAndMapping() throws {
        let email: String? = "fuad@feetish.com"
        let password: String? = "123456"
        
        var error: FeetishAuthError?
        var feetishAccount: FeetishAccount?
        
        self.feetishAuthentication.signUserIn(email: email!, password: password!)
            .map { FeetishAccount(dataDict: $0) }
            .sink { completion in
                switch completion {
                case .finished:
                    break;
                case .failure(let failureError):
                    error = failureError
                    
                    XCTAssertNotNil(error)
                }
                
                XCTAssertNil(error)
            } receiveValue: { account in
                feetishAccount = account
                
                XCTAssertEqual(feetishAccount?.email, email)
            }
            .store(in: &cancellables)
    }
    
    func testResetPassword() throws {
        let email: String? = "newaccount1@gmail.com"
        
        var error: FeetishAuthError?
        
        self.feetishAuthentication.resetUserPassword(email: email!)
            .sink { completion in
                switch completion {
                case .finished:
                    break;
                case .failure(let failureError):
                    error = failureError
                    
                    XCTAssertNotNil(error)
                }
                
                XCTAssertNil(error)
            } receiveValue: { didReset in
                XCTAssertEqual(didReset, true)
            }
            .store(in: &cancellables)
    }
    
    func testUserSignUpAndMap() throws {
        let random = "".randomString(length: 12)
        let email: String? = "\(random)@feetish.com"
        let password = "123456"
        
        var error: FeetishAuthError?
        var feetishAccount: FeetishAccount?
        
        self.feetishAuthentication.createNewAccount(email: email!, password: password)
            .map { FeetishAccount(dataDict: $0) }
            .sink { completion in
                switch completion {
                case .finished:
                    break;
                case .failure(let failureError):
                    error = failureError
                    
                    XCTAssertNotNil(error)
                }
                
                XCTAssertNil(error)
            } receiveValue: { user in
                feetishAccount = user
                
                XCTAssertEqual(feetishAccount?.email, email)
            }
            .store(in: &cancellables)
    }

}
