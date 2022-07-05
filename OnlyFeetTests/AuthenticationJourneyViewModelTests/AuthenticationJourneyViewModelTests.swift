//
//  AuthenticationJourneyViewModelTests.swift
//  OnlyFeetTests
//
//  Created by Fuad on 27/06/2022.
//

import XCTest
@testable import OnlyFeet
import SwiftUI

class AuthenticationJourneyViewModelTests: XCTestCase {
    private var viewModel: AuthenticationJourneyViewModel!
    
    override func setUp() {
        self.viewModel = AuthenticationJourneyViewModel()
    }
    
    override func tearDown() {
        self.viewModel = nil
    }
    
    func testTransitionChange() {
        viewModel.nextJourney()
        
        let edge = viewModel.determinePresentStyle()
        
        XCTAssertEqual(edge, Edge.trailing)
        
        viewModel.previousJourney()
        
        let previousEdge = viewModel.determinePresentStyle()
        
        XCTAssertEqual(previousEdge, Edge.leading)
    }
    
    func testNextJourney() {
        viewModel.authenticationJourney = .name
        
        viewModel.nextJourney()
        
        XCTAssertEqual(viewModel.authenticationJourney, AuthenticationJourneyPosition.birthday)
        XCTAssertEqual(viewModel.previousAuthenticationJourney, AuthenticationJourneyPosition.name)
    }
    
    func testPreviousJourney() {
        viewModel.authenticationJourney = .profilePhoto
        
        viewModel.previousJourney()
        
        XCTAssertEqual(viewModel.authenticationJourney, AuthenticationJourneyPosition.gender)
        XCTAssertEqual(viewModel.previousAuthenticationJourney, AuthenticationJourneyPosition.profilePhoto)
    }

}
