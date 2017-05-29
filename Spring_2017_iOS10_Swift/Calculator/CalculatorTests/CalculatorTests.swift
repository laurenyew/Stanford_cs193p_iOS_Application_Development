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
    let brain = CalculatorBrain(decimalDigits: 1)
    
    //Tests for Assignment 1
    func testCalculatorBrainBasicOperands(){
        brain.performOperation("C")
        // 7 + --> 7, true, "7 + "
        brain.setOperand(7)
        brain.performOperation("+")
        XCTAssertEqual(brain.result, 7.0)
        XCTAssertTrue(brain.isPartialResult)
        XCTAssertEqual(brain.description, "7 + ")
        
        // 7 + 9 --> 9, true, "7 + "
        brain.performOperation("C")
        brain.setOperand(7)
        brain.performOperation("+")
        //brain.setOperand(9) //9 hasn't been entered yet
        XCTAssertEqual(brain.result, 7.0) //9 hasn't been entered yet
        XCTAssertTrue(brain.isPartialResult)
        XCTAssertEqual(brain.description, "7 + ")
        
        // 7 + 9 = --> 16, false, "7 + 9 "
        brain.performOperation("C")
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("=")
        XCTAssertEqual(brain.result, 16.0)
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.description, "7 + 9")
        
        // 7 + 9 = √ --> 4, false, "√(7 + 9) "
        brain.performOperation("C")
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("=")
        brain.performOperation("√")
        XCTAssertEqual(brain.result, 4.0)
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.description, "√(7 + 9)")
        
        // 7 + 9 √ --> 3, true, "7 + √(9) "
        brain.performOperation("C")
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("√")
        XCTAssertEqual(brain.result, 3.0)
        XCTAssertTrue(brain.isPartialResult)
        XCTAssertEqual(brain.description, "7 + √(9)")
        
        // 7 + 9 √ = --> 10, false, "7 + √(9) "
        brain.performOperation("C")
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("√")
        brain.performOperation("=")
        XCTAssertEqual(brain.result, 10.0)
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.description, "7 + √(9)")
        
        // 7 + 9 = + 6 + 3 = --> 25, false, "7 + 9 + 6 + 3 "
        brain.performOperation("C")
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("=")
        brain.performOperation("+")
        brain.setOperand(6)
        brain.performOperation("+")
        brain.setOperand(3)
        brain.performOperation("=")
        XCTAssertEqual(brain.result, 25.0)
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.description, "7 + 9 + 6 + 3")
        
        // 7 + 9 = √ 6 + 3 = --> 9, false, "6 + 3 "
        brain.performOperation("C")
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("=")
        brain.performOperation("√")
        brain.setOperand(6)
        brain.performOperation("+")
        brain.setOperand(3)
        brain.performOperation("=")
        XCTAssertEqual(brain.result, 9.0)
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.description, "6 + 3")
        
        // 5 + 6 = 7 3 --> 73, false, "5 + 6 "
        brain.performOperation("C")
        brain.setOperand(5)
        brain.performOperation("+")
        brain.setOperand(6)
        brain.performOperation("=")
        //brain.setOperand(73) //Entered but not sent to brain
        XCTAssertEqual(brain.result, 11.0) //73 has not yet been entered
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.description, "5 + 6")
        //If 73 was entered
        brain.setOperand(73) //Entered but not sent to brain
        XCTAssertEqual(brain.result, 73.0) //73 has not yet been entered
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.description, "73")
        
        // 7 + = --> 14, false, "7 + 7 "
        brain.performOperation("C")
        brain.setOperand(7)
        brain.performOperation("+")
        brain.performOperation("=")
        XCTAssertEqual(brain.result, 14.0)
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.description, "7 + 7")
        
        // 4 x π = --> 12.5663706143592, false, "4 + π "
        brain.performOperation("C")
        brain.setOperand(4)
        brain.performOperation("x")
        brain.performOperation("π")
        brain.performOperation("=")
        XCTAssertEqual(brain.result, (4 * M_PI))
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.description, "4 x π")
        
        // 4 + 5 x 3 = --> 27, false, "4 + 5 x 3 "
        brain.performOperation("C")
        brain.setOperand(4)
        brain.performOperation("+")
        brain.setOperand(5)
        brain.performOperation("x")
        brain.setOperand(3)
        brain.performOperation("=")
        XCTAssertEqual(brain.result, 27.0)
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.description, "4 + 5 x 3")
    }
    
    //Assignment 2 Tests: Check display values, value of M, and description
    func testCalculatorBrainVariableSaveRestore(){
        brain.performOperation("C")
        
        // 9 + M = √ --> display = 3, M = 0, desc = √(9+M)
        brain.setOperand(9)
        brain.performOperation("+")
        brain.setOperand("M")
        brain.performOperation("=")
        brain.performOperation("√")
        XCTAssertEqual(brain.result, 3.0)
        //TODO: Check value of M
        XCTAssertEqual(brain.description, "√(9+M)")

        //7 →M --> display = 4, M = 7, desc = √(9+M)
        // sets the value of 7 into M
        brain.setOperand(7)
        brain.performOperation("→M")
        XCTAssertEqual(brain.result, 4.0)
        //TODO: Check value of M
        XCTAssertEqual(brain.description, "√(9+M)")
        
        // + 14 = --> display = 18, M = 7, desc ="√(9+M) + 14"
        brain.performOperation("+")
        brain.setOperand(14)
        brain.performOperation("=")
        XCTAssertEqual(brain.result, 18.0)
        //TODO: Check value of M
        XCTAssertEqual(brain.description, "√(9+M) + 14")
    }
    
}
