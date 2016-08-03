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
    
    func performOperation(symbol: String){
        switch symbol {
        case "π": accumulator = M_PI
        case "√": accumulator = sqrt(accumulator)
        default: break
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    
    
}