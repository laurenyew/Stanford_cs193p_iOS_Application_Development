//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by laurenyew on 7/28/16.
//  Copyright © 2016 CS193p. All rights reserved.
//

import Foundation

private func backspace(displayValue: Double) -> Double {
    //Implement backspace function
    return 0
}

private func clear(displayValue: Double) -> Double {
    //Implement clear function
    return 0
}
class CalculatorBrain {
    
    //accumulate result of calculator
    private var accumulator = 0.0
    
    //reset accumulator to be operand
    func setOperand(operand: Double){
        accumulator = operand
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({ -$0 }),
        "√" : Operation.UnaryOperation(sqrt),
        "sin" : Operation.UnaryOperation(sin),
        "cos" : Operation.UnaryOperation(cos),
        "tan" : Operation.UnaryOperation(tan),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "-" : Operation.BinaryOperation({ $0 - $1 }),
        "x" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "=" : Operation.Equals,
        "⬅︎" : Operation.UnaryOperation(backspace),
        "C" : Operation.UnaryOperation(clear)
    ]
    
    
    
    private enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private var pending: PendingBinaryOperation?
    
    private struct PendingBinaryOperation{
        var binaryFunction : (Double, Double) -> Double
        var firstOperand : Double
    }
    
    func performOperation(symbol: String){
        if let operation = operations[symbol] {
            switch operation {
                case .Constant(let value):
                    accumulator = value
                case .UnaryOperation(let function):
                    accumulator = function(accumulator)
                case .BinaryOperation(let function):
                    executePendingBinaryOperation()
                    pending = PendingBinaryOperation(binaryFunction: function, firstOperand: accumulator)
                case .Equals:
                    executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if(pending != nil){
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
}