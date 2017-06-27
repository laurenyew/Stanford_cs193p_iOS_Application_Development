//
//  ViewController.swift
//  Calculator
//
//  Created by laurenyew on 7/23/16.
//  Copyright © 2016 CS193p. All rights reserved.
//TODO: 
//-Fix description / history
//-Add unit tests
//-Add ui tests
//
import UIKit

class ViewController: UIViewController {
    
    fileprivate struct Constants{
        static let NumDecimalDigits = 6
    }
    
    @IBOutlet fileprivate weak var display: UILabel!
    @IBOutlet fileprivate weak var history: UILabel!
    @IBOutlet fileprivate weak var displayM: UILabel!
    
    fileprivate var userIsInTheMiddleOfTyping: Bool = false
    
    //CalculatorBrain
    fileprivate var brain = CalculatorBrain()
    
    //Dictionary to store variables
    fileprivate var variableDict = [String:Double]()
    
    fileprivate var displayValue: Double? {
        get{
            if let text = display.text, let value = Double(text){
                return value
            }else{
                return nil
            }
        }
        set {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = Constants.NumDecimalDigits
            
            if let doubleValue = newValue {
                display.text = formatter.string(from: NSNumber(value: doubleValue))
            }else{
                display.text = "0"
                history.text = " "
            }
            
            if let mValue = variableDict["M"]{
                displayM.text = "M = " + formatter.string(from: NSNumber(value:mValue))!
            }else{
                displayM.text = "M = "
            }
        }
    }
    
    //DisplayResult (handles updating the UI labels
    fileprivate var displayResult: (result: Double?, isPending: Bool, description: String) = (nil, false, "") {
        
        //After displayResult is set, update the UI labels
        didSet {
            switch(displayResult){
                case (nil, _, nil): displayValue = 0
                case (let result, _, _ ): displayValue = result
            }
            history.text = displayResult.description != " " ? displayResult.description + (displayResult.isPending ? "..." : " = ") : " "
        }
    }
    
    
    
    
    
    //User has touched a digit button
    @IBAction fileprivate func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        let textCurrentlyInDisplay = display.text!
        
        if userIsInTheMiddleOfTyping {
            if(digit != "." || textCurrentlyInDisplay.range(of: digit) == nil){
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
        }
        
        userIsInTheMiddleOfTyping = true
    }
    
    //(-> M) Set the variable in the dict with display value, and
    //evaluate current set of operations with M with it.
    @IBAction func setVariableInDictionary(_ sender: UIButton) {
        variableDict.updateValue(displayValue!, forKey: "M")
        displayResult = brain.evaluate(using: variableDict)
    }
    
    //(M) Add the variable to the set of brain operations
    @IBAction func useVariableInOperations(_ sender: UIButton) {
        brain.setOperand(variable: "M")
        displayResult = brain.evaluate(using: variableDict)
    }
    
    //User has touched an operation button
    @IBAction fileprivate func performOperation(_ sender: UIButton) {
        //Have typed numbers -- put in operand
        if(userIsInTheMiddleOfTyping) {
            brain.setOperand(displayValue!)
            userIsInTheMiddleOfTyping = false
        }
        
        //Perform operation on symbol
        if let mathematicalSymbol = sender.currentTitle {
            if mathematicalSymbol == "⬅︎"{
                performBackSpace()
            }else{
                brain.performOperation(mathematicalSymbol)
                //Return result from brain model
                displayResult = brain.evaluate(using: variableDict)
            }
        }
    }
    
    //Clear the calculator brain
    @IBAction func clear(_ sender: UIButton) {
        brain.clear()
        variableDict = [:]
        displayResult = brain.evaluate(using: variableDict)
    }
    
    //Helper method to perform backspace
    fileprivate func performBackSpace(){
        if displayValue != 0.0{
            var displayText = display.text!
            if displayText.characters.count != 1{
                let endIndex = displayText.index(displayText.endIndex, offsetBy: -1)
                displayText = displayText.substring(to: endIndex)
            }else{
                displayText = "0"
            }
            display.text = displayText
            brain.setOperand(displayValue!)
        }
    }
    
    
}

