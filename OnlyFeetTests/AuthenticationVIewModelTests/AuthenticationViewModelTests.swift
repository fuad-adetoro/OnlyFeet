//
//  AuthenticationViewModelTests.swift
//  OnlyFeetTests
//
//  Created by Fuad on 23/06/2022.
//

import XCTest
@testable import OnlyFeet

class AuthenticationViewModelTests: XCTestCase {
    private var viewModel: AuthenticationViewModel!
    
    override func setUp() {
        self.viewModel = AuthenticationViewModel.shared
    }
    
    override func tearDown() {
        self.viewModel = nil
    }
    
    func testViewModelInit() {
        XCTAssertNil(viewModel.feetishAccount)
        XCTAssertNil(viewModel.feetishAuthError)
        
        XCTAssertEqual(viewModel.didErrorOccur, false)
    }

}
