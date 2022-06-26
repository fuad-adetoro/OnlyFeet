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
    private var feetishAuthentication: MockAuthenticationService!
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        self.feetishAuthentication = MockAuthenticationService.shared
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

extension FeetishAuthenticationServiceTests {
    final private class MockAuthenticationService: FeetishAuthProvider {
        static let shared = MockAuthenticationService.init()
        
        func signUserIn(email: String, password: String) -> AnyPublisher<FeetishAuthDataDict, FeetishAuthError> {
            let authSubject = FeetishAuthSubject<FeetishAuthDataDict>()
            let publisher = authSubject.publisher
            
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(2)) {
                publisher.send(["email": email])
                publisher.send(completion: .finished)
            }
            
            return publisher.eraseToAnyPublisher()
        }
        
        func signUserOut() -> AnyPublisher<Bool, FeetishAuthError> {
            let authSubject = FeetishAuthSubject<Bool>()
            let publisher = authSubject.publisher
            
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(2)) {
                publisher.send(true)
                publisher.send(completion: .finished)
            }
            
            return authSubject.eraseToAnyPublisher()
        }
        
        func resetUserPassword(email: String) -> AnyPublisher<Bool, FeetishAuthError> {
            let authSubject = FeetishAuthSubject<Bool>()
            let publisher = authSubject.publisher
            
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(2)) {
                publisher.send(true)
                publisher.send(completion: .finished)
            }
            
            return authSubject.eraseToAnyPublisher()
        }
        
        func checkIfFeetishAuthValueExists(value: String, fieldName: String) -> AnyPublisher<Bool, FeetishAuthError> {
            let authSubject = FeetishAuthSubject<Bool>()
            let publisher = authSubject.publisher
            
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(2)) {
                publisher.send(true)
                publisher.send(completion: .finished)
            }
            
            return authSubject.eraseToAnyPublisher()
        }
        
        func createNewAccount(email: String, password: String) -> AnyPublisher<FeetishAuthDataDict, FeetishAuthError> {
            let authSubject = FeetishAuthSubject<FeetishAuthDataDict>()
            let publisher = authSubject.publisher
            
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(2)) {
                publisher.send(["email": email])
                publisher.send(completion: .finished)
            }
            
            return publisher.eraseToAnyPublisher()
        }
    }
}
