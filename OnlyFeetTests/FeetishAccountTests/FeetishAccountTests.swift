//
//  FeetishAccountTests.swift
//  OnlyFeetTests
//
//  Created by Fuad on 22/06/2022.
//

import XCTest
@testable import OnlyFeet

class FeetishAccountTests: XCTestCase {
    struct _FeetishAccount {
        var userID: String?
        var email: String?
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialization() {
        let userID = "customFeetishTestID"
        let email = "fuad@feetish.com"
        
        let dataDict = ["userID": userID, "email": email]
        
        let originalFeetishAccount = FeetishAccount(dataDict: dataDict)
        
        let secondaryFeetishAccount = _FeetishAccount(userID: userID, email: email)
        
        XCTAssertNil(originalFeetishAccount.username)
        
        XCTAssertEqual(originalFeetishAccount.email, secondaryFeetishAccount.email)
        
        XCTAssertEqual(originalFeetishAccount.userID, secondaryFeetishAccount.userID)
    }

}
