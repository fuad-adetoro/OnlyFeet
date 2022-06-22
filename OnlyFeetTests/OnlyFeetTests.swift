//
//  OnlyFeetTests.swift
//  OnlyFeetTests
//
//  Created by Fuad on 20/06/2022.
//

import XCTest
@testable import OnlyFeet

class OnlyFeetTests: XCTestCase {
    
    func testValidEmail() {
        let validEmail = "fuad@feetish.com"
        let invalidEmail = "fuadfeetish.com"
        
        XCTAssertEqual(validEmail.isValidEmail(), true)
        XCTAssertEqual(invalidEmail.isValidEmail(), false)
    } 
    
    

}
