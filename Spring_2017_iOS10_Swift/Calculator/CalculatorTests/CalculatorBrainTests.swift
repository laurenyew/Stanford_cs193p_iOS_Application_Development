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
    var brain = CalculatorBrain()
    var variableDict = [String:Double]()
    
    //Tests for Assignment 1
    func testCalculatorBrainBasicOperandsHappyPath(){
        brain.clear()
        // 7 + --> 7, true, "7 + "
        brain.setOperand(7)
        brain.performOperation("+")
        var brainResult = brain.evaluate()
        XCTAssertNil(brainResult.result)
        XCTAssertTrue(brainResult.isPending)
        XCTAssertEqual(brainResult.description,  "7 + ")
        
        // 7 + 9 = --> 16, false, "7 + 9 "
        brain.clear()
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("=")
        brainResult = brain.evaluate()
        XCTAssertEqual(brainResult.result, 16.0)
        XCTAssertFalse(brainResult.isPending)
        XCTAssertEqual(brainResult.description, "7 + 9")
        
        // 7 + 9 = √ --> 4, false, "√(7 + 9) "
        brain.clear()
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("=")
        brain.performOperation("√")
        brainResult = brain.evaluate()
        XCTAssertEqual(brainResult.result, 4.0)
        XCTAssertFalse(brainResult.isPending)
        XCTAssertEqual(brainResult.description, "√(7 + 9)")
        
        // 7 + 9 √ --> 3, true, "7 + √(9) "
        brain.clear()
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("√")
        brainResult = brain.evaluate()
        XCTAssertEqual(brainResult.result, 3.0)
        XCTAssertTrue(brainResult.isPending)
        XCTAssertEqual(brainResult.description, "7 + √(9)")
        
        // 7 + 9 √ = --> 10, false, "7 + √(9) "
        brain.clear()
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("√")
        brain.performOperation("=")
        brainResult = brain.evaluate()
        XCTAssertEqual(brainResult.result, 10.0)
        XCTAssertFalse(brainResult.isPending)
        XCTAssertEqual(brainResult.description, "7 + √(9)")
        
        // 7 + 9 = + 6 + 3 = --> 25, false, "7 + 9 + 6 + 3 "
        brain.clear()
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("=")
        brain.performOperation("+")
        brain.setOperand(6)
        brain.performOperation("+")
        brain.setOperand(3)
        brain.performOperation("=")
        brainResult = brain.evaluate()
        XCTAssertEqual(brainResult.result, 25.0)
        XCTAssertFalse(brainResult.isPending)
        XCTAssertEqual(brainResult.description, "7 + 9 + 6 + 3")
        
        // 7 + 9 = √ 6 + 3 = --> 9, false, "6 + 3 "
        brain.clear()
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("=")
        brain.performOperation("√")
        brain.setOperand(6)
        brain.performOperation("+")
        brain.setOperand(3)
        brain.performOperation("=")
        brainResult = brain.evaluate()
        XCTAssertEqual(brainResult.result, 9.0)
        XCTAssertFalse(brainResult.isPending)
        XCTAssertEqual(brainResult.description, "6 + 3")
        
        // 5 + 6 = 7 3 --> 73, false, "5 + 6 "
        brain.clear()
        brain.setOperand(5)
        brain.performOperation("+")
        brain.setOperand(6)
        brain.performOperation("=")
        brainResult = brain.evaluate()
        XCTAssertEqual(brainResult.result, 11.0) //73 has not yet been entered
        XCTAssertFalse(brainResult.isPending)
        XCTAssertEqual(brainResult.description, "5 + 6")
        //If 73 was entered
        brain.setOperand(73) //Entered but not sent to brain
        brainResult = brain.evaluate()
        XCTAssertEqual(brainResult.result, 73.0) //73 has not yet been entered
        XCTAssertFalse(brainResult.isPending)
        XCTAssertEqual(brainResult.description, "73")
        
        // 4 x π = --> 12.5663706143592, false, "4 + π "
        brain.clear()
        brain.setOperand(4)
        brain.performOperation("x")
        brain.performOperation("π")
        brain.performOperation("=")
        brainResult = brain.evaluate()
        XCTAssertEqual(brainResult.result, (4 * M_PI))
        XCTAssertFalse(brainResult.isPending)
        XCTAssertEqual(brainResult.description, "4 x π")
        
        // 4 + 5 x 3 = --> 27, false, "4 + 5 x 3 "
        brain.clear()
        brain.setOperand(4)
        brain.performOperation("+")
        brain.setOperand(5)
        brain.performOperation("x")
        brain.setOperand(3)
        brain.performOperation("=")
        brainResult = brain.evaluate()
        XCTAssertEqual(brainResult.result, 27.0)
        XCTAssertFalse(brainResult.isPending)
        XCTAssertEqual(brainResult.description, "4 + 5 x 3")
    }
    
    //Assignment 2 Tests: Check display values, value of M, and description
    func testCalculatorBrainVariableSaveRestore(){
        brain.clear()
        
        // 9 + M = √ --> display = 3, M = 0, desc = √(9+M)
        brain.setOperand(9)
        brain.performOperation("+")
        brain.setOperand(variable: "M")
        brain.performOperation("=")
        brain.performOperation("√")
        var brainResult = brain.evaluate(using: variableDict)
        XCTAssertEqual(brainResult.result, 3.0)
        XCTAssertNil(variableDict["M"])
        XCTAssertEqual(brainResult.description, "√(9 + M)")

        //7 →M --> display = 4, M = 7, desc = √(9+M)
        // sets the value of 7 into M
        variableDict.updateValue(7, forKey:"M")
        brainResult = brain.evaluate(using: variableDict)
        XCTAssertEqual(brainResult.result, 4.0)
        XCTAssertEqual(7, variableDict["M"])
        XCTAssertEqual(brainResult.description, "√(9 + M)")
        
        // + 14 = --> display = 18, M = 7, desc ="√(9+M) + 14"
        brain.performOperation("+")
        brain.setOperand(14)
        brain.performOperation("=")
        brainResult = brain.evaluate(using: variableDict)
        XCTAssertEqual(brainResult.result, 18.0)
        XCTAssertEqual(7, variableDict["M"])
        XCTAssertEqual(brainResult.description, "√(9 + M) + 14")
    }
    
}
