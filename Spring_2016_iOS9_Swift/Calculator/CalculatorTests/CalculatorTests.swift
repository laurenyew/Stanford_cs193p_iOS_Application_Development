//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by laurenyew on 8/21/16.
//  Copyright © 2016 CS193p. All rights reserved.
//

import XCTest
@testable import Calculator

/**
 This set of tests tests the CalculatorBrain
 result, description, and isPartialResult should be passing
 */
class CalculatorTests: XCTestCase {
    
    func testResult(){
        // 7 + --> 7
        let brain = CalculatorBrain()
        brain.setOperand(7)
        brain.performOperation("+")
        XCTAssertEqual(brain.result, 7.0)
        // 7 + 9 --> 9
        // 7 + 9 = --> 16
        // 7 + 9 = √ --> 4
        // 7 + 9 √ --> 3
        // 7 + 9 √ = --> 10
        // 7 + 9 = + 6 + 3 = --> 25
        // 7 + 9 = √ 6 + 3 = --> 9
        // 5 + 6 = 7 3 --> 73
        // 7 + = --> 14
        // 4 x π = --> 12.5663706143592
        // 4 + 5 x 3 = --> 27
    }
    
    func testIsPartialResult() {
        // 7 + --> true
        let brain = CalculatorBrain()
        brain.setOperand(7)
        brain.performOperation("+")
        XCTAssertTrue(brain.isPartialResult)
        // 7 + 9 --> true
        // 7 + 9 = --> false
        // 7 + 9 = √ --> false
        // 7 + 9 √ --> true
        // 7 + 9 √ = --> false
        // 7 + 9 = + 6 + 3 = --> false
        // 7 + 9 = √ 6 + 3 = --> false
        // 5 + 6 = 7 3 --> false
        // 7 + = --> false
        // 4 x π = --> false
        // 4 + 5 x 3 = --> false
    }
    
    func testDescription(){
        // 7 + --> "7 + "
        let brain = CalculatorBrain()
        brain.setOperand(7)
        brain.performOperation("+")
        XCTAssertEqual(brain.description, "7 + ")
        // 7 + 9 --> "7 + "
        // 7 + 9 = --> "7 + 9 "
        // 7 + 9 = √ --> "√(7 + 9) "
        // 7 + 9 √ --> "7 + √(9) "
        // 7 + 9 √ = --> "7 + √(9) "
        // 7 + 9 = + 6 + 3 = --> "7 + 9 + 6 + 3 "
        // 7 + 9 = √ 6 + 3 = --> "6 + 3 "
        // 5 + 6 = 7 3 --> "5 + 6 "
        // 7 + = --> "7 + 7 "
        // 4 x π = --> "4 + π "
        // 4 + 5 x 3 = --> "4 + 5 x 3 "
    }
    
    
}
