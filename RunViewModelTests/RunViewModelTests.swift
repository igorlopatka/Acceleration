//
//  RunViewModelTests.swift
//  RunViewModelTests
//
//  Created by Igor Łopatka on 20/02/2023.
//

import XCTest
@testable import Acceleration

final class RunViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitialization() {
        
        // Initialize Run View Model
        let runViewModel = RunViewModel()

        XCTAssertNotNil(runViewModel, "The profile view model should not be nil.")
    }
    
    
    
}
