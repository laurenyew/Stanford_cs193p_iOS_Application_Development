//
//  CalculatorUITests.swift
//  CalculatorUITests
//
//  Created by laurenyew on 6/26/17.
//  Copyright © 2017 CS193p. All rights reserved.
//

import XCTest

class CalculatorUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCalculatorBrainWithInternalProgramAndVariableDictionaryHappyPath() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let buttons = app.buttons
        
        //Exercise 9 + M = √ --> display = 3, M = 0, desc = √(9+M)
        buttons["9"].tap()
        buttons["+"].tap()
        buttons["M"].tap()
        buttons["="].tap()
        buttons["√"].tap()
        
        //Verify Results
        XCTAssert(app.staticTexts["3"].exists)
        XCTAssert(app.staticTexts["M = "].exists)
        XCTAssert(app.staticTexts["√(9 + M) = "].exists)
        
        //Exercise 7 →M --> display = 4, M = 7, desc = √(9+M)
        // sets the value of 7 into M
        buttons["7"].tap()
        buttons["→M"].tap()
        
        //Verify Results
        XCTAssert(app.staticTexts["4"].exists)
        XCTAssert(app.staticTexts["M = 7"].exists)
        XCTAssert(app.staticTexts["√(9 + M) = "].exists)
        
        
        //Exercise + 14 = --> display = 18, M = 7, desc ="√(9+M) + 14"
        buttons["+"].tap()
        buttons["1"].tap()
        buttons["4"].tap()
        buttons["="].tap()
        
        //Verify Results
        XCTAssert(app.staticTexts["18"].exists)
        XCTAssert(app.staticTexts["M = 7"].exists)
        XCTAssert(app.staticTexts["√(9 + M) + 14 = "].exists)
    }
    
}
