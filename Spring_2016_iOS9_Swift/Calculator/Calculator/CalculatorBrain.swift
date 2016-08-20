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
    private var accumulator : Double
    private var currentOperand : Double
    
    //Description of sequence of operands/operations that lead to the result
    private var description : String
    
    //returns whether or not there is a binary operation pending
    private var isPartialResult : Bool
    
    init() {
        accumulator = 0.0
        currentOperand = 0.0
        description = ""
        isPartialResult = false
    }
    
    //reset accumulator to be operand
    func setOperand(operand: Double){
        currentOperand = operand
        description += "\(operand)"
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
        "⬅︎" : Operation.Backspace,
        "C" : Operation.Clear
    ]
    
    
    
    private enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Clear
        case Backspace
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
                    description = symbol
                    isPartialResult = false
                    accumulator = value
                case .UnaryOperation(let function):
                    if symbol == "C" {
                        description = ""
                    }
                    else if symbol != "⬅︎" {
                        description = "\(symbol)(\(description))"
                    }
                    isPartialResult = false
                    accumulator = function(accumulator)
                case .BinaryOperation(let function):
                    description += " \(symbol) "
                    isPartialResult = true
                    executePendingBinaryOperation()
                    pending = PendingBinaryOperation(binaryFunction: function, firstOperand: accumulator)
                case .Equals:
                    isPartialResult = false
                    executePendingBinaryOperation()
                case .Backspace:
                    print("Backspace")
                case .Clear:
                    accumulator = 0.0
                    currentOperand = 0.0
                    description = ""
                    isPartialResult = false
            }
        }
        print("Description: \(description) isPartialResult: \(isPartialResult)")
    }
    
    private func executePendingBinaryOperation(){
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