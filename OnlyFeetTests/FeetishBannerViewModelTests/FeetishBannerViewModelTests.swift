//
//  FeetishBannerViewModelTests.swift
//  OnlyFeetTests
//
//  Created by Fuad on 22/06/2022.
//

import XCTest
@testable import OnlyFeet

class FeetishBannerViewModelTests: XCTestCase {
    private var viewModel: FeetishBannerViewModel!
    
    override func setUp() {
        self.viewModel = FeetishBannerViewModel()
    }
    
    override func tearDown() {
        self.viewModel.model = nil
        self.viewModel = nil
    }
    
    func testModelNil() {
        XCTAssertNil(viewModel.model)
    }
    
    func testModelInit() {
        viewModel.loadNewBanner(bannerData: .init(title: "Test Init", message: "Test Message", bannerError: FeetishAuthError.unknownError))
        
        XCTAssertNotNil(viewModel.model)
        XCTAssertEqual(viewModel.model?.title, "Test Init")
    }
    
    func testModelReplacement() {
        viewModel.loadNewBanner(bannerData: .init(title: "Test Init", message: "Test Message", bannerError: FeetishAuthError.unknownError))
        XCTAssertEqual(viewModel.model?.title, "Test Init")
        
        viewModel.loadNewBanner(bannerData: .init(title: "Test Replacement", message: "Test Message", bannerError: FeetishAuthError.unknownError))
        XCTAssertEqual(viewModel.model?.title, "Test Replacement")
    }
    
    func testModelRemoval() {
        viewModel.loadNewBanner(bannerData: .init(title: "Test Init", message: "Test Message", bannerError: FeetishAuthError.unknownError))
        XCTAssertEqual(viewModel.model?.title, "Test Init")
        
        viewModel.removeCurrentBanner()
        XCTAssertNil(viewModel.model)
    }
    
    func testModelTimerRemoval() {
        viewModel.loadNewBanner(bannerData: .init(title: "Test Init", message: "Test Message", bannerError: FeetishAuthError.unknownError))
        viewModel.resumeRemovalTimer()
        XCTAssertEqual(viewModel.model?.title, "Test Init")
        
        //sleep(5)
        
        let timerCompleteExpectation = XCTestExpectation(description: "testAlertShouldAppear")
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(5)) {
            timerCompleteExpectation.fulfill()
        }
        
        wait(for: [timerCompleteExpectation], timeout: 5.5)
        
        XCTAssertEqual(viewModel.currentBannerTime, 4)
        XCTAssertNil(viewModel.model)
    }
    
    func testModelTimerDragAndRemoval() {
        viewModel.loadNewBanner(bannerData: .init(title: "Test Init", message: "Test Message", bannerError: FeetishAuthError.unknownError))
        viewModel.resumeRemovalTimer()
        XCTAssertEqual(viewModel.model?.title, "Test Init")
        
        viewModel.isBeingDragged = true
        
        XCTAssertEqual(viewModel.isBeingDragged, true)
        
        //sleep(5)
        
        let timerCompleteExpectation = XCTestExpectation(description: "testAlertShouldAppear")
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(5)) {
            timerCompleteExpectation.fulfill()
        }
        
        wait(for: [timerCompleteExpectation], timeout: 5.5)
        
        XCTAssertNotEqual(viewModel.currentBannerTime, 4)
        XCTAssertNotNil(viewModel.model)
        
        
        /// 2nd expectation!
        ///
        
        viewModel.isBeingDragged = false
        
        let secondTimerCompleteExpectation = XCTestExpectation(description: "testAlertShouldAppear")
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(5)) {
            secondTimerCompleteExpectation.fulfill()
        }
        
        wait(for: [secondTimerCompleteExpectation], timeout: 5.5)
        
        XCTAssertEqual(viewModel.currentBannerTime, 4)
        XCTAssertNil(viewModel.model)
        
    }
}

