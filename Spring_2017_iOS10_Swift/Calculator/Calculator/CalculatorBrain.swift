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
    //max number of decimal digits that can be shown
    fileprivate var decimalDigits: Int
    //Description of history
    fileprivate var descriptionAccumulator = ""
    //internal program of property list items (Double if operand, String if operation)
    fileprivate var internalProgram = [AnyObject]()
    //Keep values associated to given variables
    fileprivate var variableValues : Dictionary<String,Double> = [:]
    //Current pending binary operation
    fileprivate var pending: PendingBinaryOperation?
    
    //Operation enum (helps simplify code around Operation functions)
    fileprivate enum Operation{
        case constant(Double)
        case emptyOperation(() -> Double, String)
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
        "C" : Operation.clear,
        "rand" : Operation.emptyOperation({ drand48() }, "rand()")
    ]
    
    //Enum for Pending Binary Operation
    fileprivate struct PendingBinaryOperation{
        var binaryFunction : (Double, Double) -> Double
        var firstOperand : Double
        var binaryFunctionDescription: (String,String) -> String
        var firstOperandDescription: String
    }
    
    init(decimalDigits: Int) {
        self.decimalDigits = decimalDigits
    }
    
    //Get/Set Internal Program for the calculator to use
    typealias PropertyList = AnyObject
    var program: PropertyList{
        get{
            return internalProgram as PropertyList
        }set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject]{
                for op in arrayOfOps{
                    if let operand = op as? Double{
                        setOperand(operand)
                    }else if let operation = op as? String{
                        //Operation can either be a variable name or an operation
                        if (operations[operation] != nil) {
                            performOperation(operation)
                        }else{
                            setOperand(operation)
                        }
                    }
                }
            }
        }
    }
    
    //Clear out the calculator
    fileprivate func clear(){
        accumulator = 0.0
        pending = nil
        descriptionAccumulator = ""
        internalProgram.removeAll()
    }
    
    //Result to display
    var result: Double {
        get {
            return accumulator
        }
    }
    
    // MARK: Description
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
    
    // MARK: Operations
    //Update the variableValues dictionary. The variableName is mapped to the current accumulator value.
    func setOperand(_ variableName: String){
        internalProgram.append(variableName as AnyObject)
        variableValues[variableName] = accumulator
    }
    
    //Used by View Controller to reset accumulator to be operand
    func setOperand(_ operand: Double){
        internalProgram.append(operand as AnyObject)
        accumulator = operand
        
        //Format description
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimalDigits
        descriptionAccumulator = formatter.string(from: NSNumber(value: operand))!
    }
    
   //Used by View Controller to perform a given operation
   func performOperation(_ symbol: String){
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
                case .constant(let value):
                    accumulator = value
                    descriptionAccumulator = symbol
                case .emptyOperation(let function, let description):
                    accumulator = function()
                    descriptionAccumulator = description
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
                    clear()
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
