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
    private var feetishAuthentication: FeetishAuthentication!
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        self.feetishAuthentication = FeetishAuthentication.shared
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
            } receiveValue: { account in
                feetishAccount = account
                
                XCTAssertEqual(feetishAccount?.email, email)
            }
            .store(in: &cancellables)
    }

}
