//
//  ViewController.swift
//  Calculator
//
//  Created by laurenyew on 7/23/16.
//  Copyright © 2016 CS193p. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate struct Constants{
        static let NumDecimalDigits = 6
    }

    @IBOutlet fileprivate weak var display: UILabel!
    @IBOutlet fileprivate weak var history: UILabel!
    
    fileprivate var userIsInTheMiddleOfTyping: Bool = false
    
    //CalculatorBrain
    fileprivate var brain = CalculatorBrain()
    
    //Dictionary to store variables
    fileprivate var variableDict = [String:Double]()
    
    //UI Label display value
    fileprivate var displayValue: Double? {
        get{
            if let text = display.text, let value = Double(text){
                return value
            }else{
                return nil
            }
        }
        set {
            if let doubleValue = newValue {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = Constants.NumDecimalDigits
                display.text = formatter.string(from: NSNumber(value: doubleValue))
            }else{
                display.text = "0"
                history.text = " "
            }
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
    }
    
    //(M) Add the variable to the set of brain operations
    @IBAction func useVariableInOperations(_ sender: UIButton) {
        let brainResult = brain.evaluate(using: variableDict)
        displayValue = brainResult.result
        history.text = brainResult.description +
            (brainResult.isPending ? " ... " : " = ")
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
               //TODO displayValue = brain.evaluate()
            }
        }else{
            //Return result from brain model
            //TODO displayValue = brain.result
        }
        
        
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

