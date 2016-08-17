//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by laurenyew on 7/28/16.
//  Copyright © 2016 CS193p. All rights reserved.
//

import Foundation

func add(op1: Double, op2: Double) -> Double {
    return op1 + op2
}
func subtract(op1: Double, op2: Double) -> Double {
    return op1 - op2
}
func multiply(op1: Double, op2: Double) -> Double {
    return op1 * op2
}
func divide(op1: Double, op2: Double) -> Double {
    return op1 / op2
}

class CalculatorBrain {
    
    //accumulate result of calculator
    private var accumulator = 0.0
    
    //reset accumulator to be operand
    func setOperand(operand: Double){
        accumulator = operand
    }
    
    var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "+" : Operation.BinaryOperation(add),
        "-" : Operation.BinaryOperation(subtract),
        "x" : Operation.BinaryOperation(multiply),
        "÷" : Operation.BinaryOperation(divide),
        "=" : Operation.Equals
    ]
    
    enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private var pending: PendingBinaryOperation?
    
    struct PendingBinaryOperation{
        var binaryFunction : (Double, Double) -> Double
        var firstOperand : Double
    }
    
    func performOperation(symbol: String){
        if let operation = operations[symbol] {
            switch operation {
                case .Constant(let value): accumulator = value
                case .UnaryOperation(let function): accumulator = function(accumulator)
                case .BinaryOperation(let function): pending = PendingBinaryOperation(binaryFunction: function,         firstOperand: accumulator)
                case .Equals:
                    if(pending != nil){
                        accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
                        pending = nil
                }
            }
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
}