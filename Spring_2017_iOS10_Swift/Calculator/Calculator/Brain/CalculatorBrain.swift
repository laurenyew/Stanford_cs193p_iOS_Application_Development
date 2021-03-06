//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by laurenyew on 7/28/16.
//  Copyright © 2016 CS193p. All rights reserved.
//

import Foundation

//Model class (Business Logic for Calculator)
struct CalculatorBrain {
    
    //------------------------------------------------------------------
    // MARK: State
    
    //Operation enum (helps simplify code around Operation functions)
    private enum Operation{
        case constant(Double)
        case emptyOperation(() -> Double, String)
        case unaryOperation((Double) -> Double, (String) -> String,
            ((Double) -> String?)?)
        case binaryOperation((Double, Double) -> Double, (String, String) -> String, ((Double, Double) -> String?)?)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "±" : Operation.unaryOperation({ -$0 }, {"-(" + $0 + ")"}, nil),
        "√" : Operation.unaryOperation(sqrt, {"√(" + $0 + ")"}, nil),
        "sin" : Operation.unaryOperation(sin, {"sin(" + $0 + ")"}, nil),
        "cos" : Operation.unaryOperation(cos, {"cos(" + $0 + ")"}, nil),
        "tan" : Operation.unaryOperation(tan, {"tan(" + $0 + ")"}, nil),
        "+" : Operation.binaryOperation(+, { $0 + " + " + $1 }, nil),
        "-" : Operation.binaryOperation(-, { $0 + " - " + $1 }, nil),
        "x" : Operation.binaryOperation(*, { $0 + " x " + $1 }, nil),
        "÷" : Operation.binaryOperation(/, { $0 + " ÷ " + $1 }, { $1 == 0 ? "Error: Divide by Zero" : nil }),
        "=" : Operation.equals,
        "rand" : Operation.emptyOperation({ drand48() }, "rand()")
    ]
    
    //Enum for Pending Binary Operation
    private struct PendingBinaryOperation{
        var binaryFunction : (Double, Double) -> Double
        var firstOperand : Double
        var binaryFunctionDescription: (String,String) -> String
        var firstOperandDescription: String
        //Helps validate errors
        var operationValidator : ((Double, Double) -> String?)?
    }
    
    //Operation Type (Save into Internal Program)
    private enum OpType{
        case operand(Double) //value (ex: "2")
        case operation(String) //method (ex: "cos()")
        case variable(String) //variable (ex: "x")
    }
    
    //internal program of property list items (Double if operand, String if operation)
    private var internalProgram = [OpType]()
    
    //------------------------------------------------------------------
    // MARK: Create / Update Internal Program
    // Goal: Use these methods to save information from the view controller
    // into the internal program. Use evaluate to then run that internal program
    
    //Add the variable operand to the internal program
    mutating func setOperand(variable named: String){
        internalProgram.append(OpType.variable(named))
    }
    
    //Add the number operand to the internal program
    mutating func setOperand(_ operand: Double){
        internalProgram.append(OpType.operand(operand))
    }
    
    //Add the operation function to the internal program
    mutating func performOperation(_ symbol: String){
        internalProgram.append(OpType.operation(symbol))
    }
    
    mutating func undo(){
        internalProgram.removeLast()
    }
    
    //Clear out the internal program
    mutating func clear(){
        internalProgram.removeAll()
    }
    
    //------------------------------------------------------------------
    // MARK: Evaluate a given Internal Program
    
    //Evaluate takes in variables which can default to nil
    func evaluate(using variables: Dictionary<String, Double>? = nil) -> (result: Double?, isPending: Bool, description: String, error: String?){
        
        //Initialize variables to be used inside this function
        var accumulator: Double?
        var descriptionAccumulator: String?
        var pending: PendingBinaryOperation?
        var error: String?
        
        //Return the result of the internal program
        var result: Double? {
            get {
                return accumulator
            }
        }
        
        //Description of sequence of operands/operations that lead to the result
        var description : String? {
            get{
                //If we have a pending binary operation, show it
                //with the current description accumulator
                if let pendingDesc = pending {
                    return pendingDesc.binaryFunctionDescription(
                        pendingDesc.firstOperandDescription,
                        descriptionAccumulator ?? "")
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
        
        //Get the value of variable 'named' in the variables dictionary
        //Default value is 0
        func setOperand(variable named: String){
            accumulator = variables?[named] ?? 0
            descriptionAccumulator = named
        }
        
        //Used by View Controller to reset accumulator to be operand
        func setOperand(_ operand: Double){
            accumulator = operand
            
            //Format description
            if let value = accumulator {
                descriptionAccumulator =
                    formatter.string(from: NSNumber(value: value)) ?? ""
            }
        }
        
        //Perform the symbol operation from the internal program
        func performOperation(_ symbol: String){
            
            if let operation = operations[symbol] {
                switch operation {
                case .constant(let value):
                    accumulator = value
                    descriptionAccumulator = symbol
                case .emptyOperation(let function, let description):
                    accumulator = function()
                    descriptionAccumulator = description
                case .unaryOperation(let function, let descriptionFunction, let operationValidator):
                    //Run the function on the accumulated values and update result
                    if accumulator != nil {
                        accumulator = function(accumulator!)
                    }
                    //Update the description
                    if descriptionAccumulator != nil{
                        descriptionAccumulator = descriptionFunction(descriptionAccumulator!)
                    }
                    //Update functionValidator (error message)
                    if operationValidator != nil{
                        error = operationValidator!(accumulator!)
                    }else{
                        error = nil
                    }
                    
                case .binaryOperation(let function, let descriptionFunction, let operationValidator):
                    executePendingBinaryOperation()
                    
                    if accumulator != nil && descriptionAccumulator != nil{
                        pending =
                            PendingBinaryOperation(
                                binaryFunction: function,
                                firstOperand: accumulator!,
                                binaryFunctionDescription: descriptionFunction,
                                firstOperandDescription:descriptionAccumulator!,
                                operationValidator: operationValidator)
                        accumulator = nil
                        descriptionAccumulator = nil
                    }

                case .equals:
                    executePendingBinaryOperation()
                }
            }
        }
        
        //Helper method: if there is a pending binary operation, run it
        func executePendingBinaryOperation(){
            if pending != nil && accumulator != nil{
                //Check for errors first
                if let validator =  pending!.operationValidator {
                    error = validator(pending!.firstOperand, accumulator!)
                }else{
                    error = nil
                }
                //Then run the operation and get the description
                accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator!)
                descriptionAccumulator = pending!.binaryFunctionDescription(pending!.firstOperandDescription, descriptionAccumulator!)
                
                pending = nil
            }
        }
        
        //MARK: Evaluate business logic
        //Check first if the internal program has anything in it
        guard !(internalProgram.isEmpty) else { return (nil, false, "", nil) }
        //Setup the values
        pending = nil
        descriptionAccumulator = ""
        accumulator = 0.0
        
        //Run the internal program
        for op in internalProgram {
            switch op{
            case .variable(let v):
                setOperand(variable: v)
            case .operand(let operand):
                setOperand(operand)
            case .operation(let operation):
                performOperation(operation)
            }
        }
        
        return (result, isPartialResult, description ?? "", error)
        
    }
    
    //Make a helper formatter variable that can be used in
    //the description to format numbers
    let formatter:NumberFormatter = {
        let tempFormatter = NumberFormatter()
        tempFormatter.numberStyle = .decimal
        tempFormatter.maximumFractionDigits = 4
        return tempFormatter
    }()
    
    //MARK: Deprecated values
    @available(iOS, deprecated, message: "Deprecated in Assignment 2: Calculator Brain. Use evaluate() instead.")
    var description: String {
        get {
            return evaluate().description
        }
    }
    @available(iOS, deprecated, message: "Deprecated in Assignment 2: Calculator Brain. Use evaluate() instead.")
    var result: Double? {
        get {
            return evaluate().result
        }
    }
    
    @available(iOS, deprecated, message: "Deprecated in Assignment 2: Calculator Brain. Use evaluate() instead.")
    var resultIsPending: Bool {
        get {
            return evaluate().isPending
        }
    }
    
}
