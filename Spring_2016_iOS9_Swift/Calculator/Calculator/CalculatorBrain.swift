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
    fileprivate var accumulator = 0.0
    
    //Description of sequence of operands/operations that lead to the result
    fileprivate var description = ""
    
    //returns whether or not there is a binary operation pending
    fileprivate var isPartialResult = false
    
    
    //reset accumulator to be operand
    func setOperand(_ operand: Double){
        accumulator = operand
    }
    
    fileprivate var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(M_PI),
        "e" : Operation.constant(M_E),
        "±" : Operation.unaryOperation({ -$0 }),
        "√" : Operation.unaryOperation(sqrt),
        "sin" : Operation.unaryOperation(sin),
        "cos" : Operation.unaryOperation(cos),
        "tan" : Operation.unaryOperation(tan),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "-" : Operation.binaryOperation({ $0 - $1 }),
        "x" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "=" : Operation.equals,
        "⬅︎" : Operation.backspace,
        "C" : Operation.clear
    ]
    
    
    
    fileprivate enum Operation{
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
        case backspace
    }
    
    fileprivate var pending: PendingBinaryOperation?
    
    fileprivate struct PendingBinaryOperation{
        var binaryFunction : (Double, Double) -> Double
        var firstOperand : Double
    }
    
    func performOperation(_ symbol: String){
        if let operation = operations[symbol] {
            switch operation {
                case .constant(let value):
                    description = symbol
                    isPartialResult = false
                    accumulator = value
                case .unaryOperation(let function):
                    description += "\(symbol)(\(description))"
                    isPartialResult = true
                    accumulator = function(accumulator)
                case .binaryOperation(let function):
                    description += "\(accumulator) \(symbol) "
                    isPartialResult = true
                    executePendingBinaryOperation()
                    pending = PendingBinaryOperation(binaryFunction: function, firstOperand: accumulator)
                case .equals:
                    isPartialResult = false
                    description += "\(accumulator)"
                    executePendingBinaryOperation()
                case .backspace:
                    print("Backspace")
                case .clear:
                    accumulator = 0.0
                    description = ""
                    isPartialResult = false
            }
        }
        print("Description: \(description) isPartialResult: \(isPartialResult)")
    }
    
    fileprivate func executePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    var history: String {
        get {
            if description.isEmpty{
                return " "
            }else{
                let historyEnd = isPartialResult ? "..." : "="
                return "\(description) \(historyEnd)"
            }
        }
    }
    
}
