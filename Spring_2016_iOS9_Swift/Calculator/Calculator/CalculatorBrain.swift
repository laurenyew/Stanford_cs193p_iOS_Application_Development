//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by laurenyew on 7/28/16.
//  Copyright © 2016 CS193p. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    //accumulate result of calculator
    private var accumulator = 0.0
    
    //reset accumulator to be operand
    func setOperand(operand: Double){
        accumulator = operand
    }
    
    var operations: Dictionary<String,Double> = [
        "π" : M_PI,
        "e" : M_E
    ]
    
    func performOperation(symbol: String){
        if let constant = operations[symbol] {
            accumulator = constant
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    
    
}