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
        let authenticationJourneyPosition = AuthenticationJourneyPosition.init()!
        
        XCTAssertEqual(authenticationJourneyPosition.rawValue, 1)
        
        let namePosition = authenticationJourneyPosition.nextPosition()
        
        XCTAssertEqual(namePosition, AuthenticationJourneyPosition.name)
        XCTAssertEqual(namePosition.rawValue, 2)
        
        let birthdayPosition = namePosition.nextPosition()
        
        XCTAssertEqual(birthdayPosition, AuthenticationJourneyPosition.birthday)
        XCTAssertEqual(birthdayPosition.rawValue, 3)
        
        let genderPosition = birthdayPosition.nextPosition()
        
        XCTAssertEqual(genderPosition, AuthenticationJourneyPosition.gender)
        XCTAssertEqual(genderPosition.rawValue, 4)
        
        let profilePhotoPosition = genderPosition.nextPosition()
        
        XCTAssertEqual(profilePhotoPosition, AuthenticationJourneyPosition.profilePhoto)
        XCTAssertEqual(profilePhotoPosition.rawValue, 5)
        
        let accountCreationPosition = profilePhotoPosition.nextPosition()
        
        XCTAssertEqual(accountCreationPosition, AuthenticationJourneyPosition.accountCreation)
        XCTAssertEqual(accountCreationPosition.rawValue, 6)
        
        let notificationPosition = accountCreationPosition.nextPosition()
        
        XCTAssertEqual(notificationPosition, AuthenticationJourneyPosition.notification)
        XCTAssertEqual(notificationPosition.rawValue, 7)
    }
    
    func testPreviousPosition() {
        let authenticationJourneyPosition = AuthenticationJourneyPosition.init()!
        
        XCTAssertEqual(authenticationJourneyPosition.rawValue, 1)
        
        let _ /*rulePosition*/ = authenticationJourneyPosition
        let namePosition = authenticationJourneyPosition.nextPosition()
        let birthdayPosition = namePosition.nextPosition()
        let genderPosition = birthdayPosition.nextPosition()
        let profilePhotoPosition = genderPosition.nextPosition()
        let accountCreationPosition = profilePhotoPosition.nextPosition()
        let notificationPosition = accountCreationPosition.nextPosition()
        let getStartedPosition = notificationPosition.nextPosition()
        let completePosition = getStartedPosition.nextPosition()
        
        let rulesPositionPrevious = namePosition.previousPosition()
        let namePositionPrevious = birthdayPosition.previousPosition()
        let birthdayPositionPrevious = genderPosition.previousPosition()
        let genderPositionPrevious = profilePhotoPosition.previousPosition()
        let profilePhotoPreviousPrevious = accountCreationPosition.previousPosition()
        let accountCreationPreviousPosition = notificationPosition.previousPosition()
        let notificationPositionPrevious = getStartedPosition.previousPosition()
        let getStartedPositionPrevious = completePosition.previousPosition()
        let completePositionPrevious = completePosition.previousPosition()
        let nilPosition = authenticationJourneyPosition.previousPosition()
        
        XCTAssertEqual(namePosition, AuthenticationJourneyPosition.name)
        XCTAssertEqual(namePosition.rawValue, 2)

        XCTAssertEqual(rulesPositionPrevious, AuthenticationJourneyPosition.rules)
        XCTAssertEqual(rulesPositionPrevious?.rawValue, 1)
        
        XCTAssertEqual(namePositionPrevious, AuthenticationJourneyPosition.name)
        
        XCTAssertEqual(birthdayPositionPrevious, AuthenticationJourneyPosition.birthday)
        
        XCTAssertEqual(genderPositionPrevious, AuthenticationJourneyPosition.gender)
        
        XCTAssertEqual(profilePhotoPreviousPrevious, AuthenticationJourneyPosition.profilePhoto)
        
        XCTAssertEqual(accountCreationPreviousPosition, AuthenticationJourneyPosition.accountCreation)
        
        XCTAssertEqual(notificationPositionPrevious, AuthenticationJourneyPosition.notification)
        
        XCTAssertEqual(getStartedPositionPrevious, AuthenticationJourneyPosition.getStarted)
        
        XCTAssertNotEqual(completePositionPrevious, AuthenticationJourneyPosition.complete)
        
        XCTAssertNil(nilPosition)
    }

}

