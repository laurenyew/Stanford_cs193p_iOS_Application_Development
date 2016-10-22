//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by laurenyew on 7/28/16.
//  Copyright © 2016 CS193p. All rights reserved.
//

import Foundation

//Model class (Business Logic for Calculator)
public class CalculatorBrain {
    
    //accumulate result of calculator
    fileprivate var accumulator = 0.0
    fileprivate var decimalDigits: Int
    
    init(decimalDigits: Int) {
        self.decimalDigits = decimalDigits
    }
    
    //Result to display
    var result: Double {
        get {
            return accumulator
        }
    }
    
    //Description of history
    fileprivate var descriptionAccumulator = ""
    
    //Description of sequence of operands/operations that lead to the result
    var description : String {
        get{
            if let pendingDesc = pending {
                return pendingDesc.binaryFunctionDescription(
                                        pendingDesc.firstOperandDescription,
                                        pendingDesc.firstOperandDescription != descriptionAccumulator ?
                                            descriptionAccumulator : "")
            }else{
                return descriptionAccumulator
            }
        }
    }
    
    //returns whether or not there is a binary operation pending
    var isPartialResult : Bool {
        get{
            return pending != nil
        }
    }
    
    //Operation enum (helps simplify code around Operation functions)
    fileprivate enum Operation{
        case constant(Double)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double, Double) -> Double, (String, String) -> String)
        case equals
        case clear
    }
    
    fileprivate var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(M_PI),
        "e" : Operation.constant(M_E),
        "±" : Operation.unaryOperation({ -$0 }, {"-(" + $0 + ")"}),
        "√" : Operation.unaryOperation(sqrt, {"√(" + $0 + ")"}),
        "sin" : Operation.unaryOperation(sin, {"sin(" + $0 + ")"}),
        "cos" : Operation.unaryOperation(cos, {"cos(" + $0 + ")"}),
        "tan" : Operation.unaryOperation(tan, {"tan(" + $0 + ")"}),
        "+" : Operation.binaryOperation(+, { $0 + " + " + $1 }),
        "-" : Operation.binaryOperation(-, { $0 + " - " + $1 }),
        "x" : Operation.binaryOperation(*, { $0 + " x " + $1 }),
        "÷" : Operation.binaryOperation(/, { $0 + " ÷ " + $1 }),
        "=" : Operation.equals,
        "C" : Operation.clear
    ]
    
    //Enum for Pending Binary Operation
    fileprivate struct PendingBinaryOperation{
        var binaryFunction : (Double, Double) -> Double
        var firstOperand : Double
        var binaryFunctionDescription: (String,String) -> String
        var firstOperandDescription: String
    }
    
    //Current pending binary operation
    fileprivate var pending: PendingBinaryOperation?
    
    //Used by View Controller to reset accumulator to be operand
    func setOperand(_ operand: Double){
        accumulator = operand
        
        //Format description
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimalDigits
        descriptionAccumulator = formatter.string(from: NSNumber(value: operand))!
    }
    
   //Used by View Controller to perform a given operation
   func performOperation(_ symbol: String){
        if let operation = operations[symbol] {
            switch operation {
                case .constant(let value):
                    accumulator = value
                    descriptionAccumulator = symbol
                case .unaryOperation(let function, let descriptionFunction):
                    accumulator = function(accumulator)
                    descriptionAccumulator = descriptionFunction(descriptionAccumulator)
                case .binaryOperation(let function, let functionDescription):
                    executePendingBinaryOperation()
                    pending = PendingBinaryOperation(binaryFunction: function,
                                                     firstOperand: accumulator,
                                                     binaryFunctionDescription: functionDescription,
                                                     firstOperandDescription:descriptionAccumulator)
                case .equals:
                    executePendingBinaryOperation()
                case .clear:
                    accumulator = 0.0
                    pending = nil
                    descriptionAccumulator = ""
            }
        }
    }
    
    //Helper method: if there is a pending binary operation, run it
    fileprivate func executePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            descriptionAccumulator = pending!.binaryFunctionDescription(pending!.firstOperandDescription, descriptionAccumulator)
            pending = nil
        }
    }
}
