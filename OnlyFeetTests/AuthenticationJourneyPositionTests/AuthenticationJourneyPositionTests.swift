//
//  AuthenticationJourneyPositionTests.swift
//  OnlyFeetTests
//
//  Created by Fuad on 24/06/2022.
//

import XCTest
@testable import OnlyFeet

class AuthenticationJourneyPositionTestCase: XCTestCase {

    func testBeginJourney() {
        let authenticationJourneyPosition = AuthenticationJourneyPosition.init()
        
        XCTAssertEqual(authenticationJourneyPosition, AuthenticationJourneyPosition.rules)
    }
    
    func testPositionChanges() {
        let authenticationJourneyPosition = AuthenticationJourneyPosition.init()
        
        XCTAssertEqual(authenticationJourneyPosition.rawValue, 1)
        
        let namePosition = authenticationJourneyPosition.nextPosition()
        
        XCTAssertEqual(namePosition, AuthenticationJourneyPosition.name)
        XCTAssertEqual(namePosition.rawValue, 2)
    }
    
    func testPreviousPosition() {
        let authenticationJourneyPosition = AuthenticationJourneyPosition.init()
        
        XCTAssertEqual(authenticationJourneyPosition.rawValue, 1)
        
        let _ /*rulePosition*/ = authenticationJourneyPosition
        let namePosition = authenticationJourneyPosition.nextPosition()
        let usernamePosition = namePosition.nextPosition()
        let birthdayPosition = usernamePosition.nextPosition()
        let genderPosition = birthdayPosition.nextPosition()
        let profilePhotoPosition = genderPosition.nextPosition()
        let accountCreationPosition = profilePhotoPosition.nextPosition()
        
        let rulesPositionPrevious = namePosition.previousPosition()
        let namePositionPrevious = usernamePosition.previousPosition()
        let usernamePreviousPosition = birthdayPosition.previousPosition()
        let birthdayPositionPrevious = genderPosition.previousPosition()
        let genderPositionPrevious = profilePhotoPosition.previousPosition() 
        
        XCTAssertEqual(namePosition, AuthenticationJourneyPosition.name)
        XCTAssertEqual(namePosition.rawValue, 2)

        XCTAssertEqual(rulesPositionPrevious, AuthenticationJourneyPosition.rules)
        XCTAssertEqual(rulesPositionPrevious?.rawValue, 1)
        
        XCTAssertEqual(namePositionPrevious, AuthenticationJourneyPosition.name)
        
        XCTAssertEqual(usernamePreviousPosition, AuthenticationJourneyPosition.birthday)
        
        XCTAssertEqual(birthdayPositionPrevious, AuthenticationJourneyPosition.gender)
        
        XCTAssertEqual(genderPositionPrevious, AuthenticationJourneyPosition.profilePhoto)
    }

}

