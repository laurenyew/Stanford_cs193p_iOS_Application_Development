//
//  ViewController.swift
//  Calculator
//
//  Created by laurenyew on 7/23/16.
//  Copyright © 2016 CS193p. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet fileprivate weak var display: UILabel!
    @IBOutlet fileprivate weak var history: UILabel!
    
    fileprivate var userIsInTheMiddleOfTyping: Bool = false
    
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
    
    //UI Label display value
    fileprivate var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set {
            display.text = String(format:"%g", newValue)
            if !brain.description.isEmpty{
                history.text = brain.description + (brain.isPartialResult ? " ... " : " = ")
            }else{
                history.text = " "
            }
        }
    }
    
    fileprivate func performBackSpace(){
        if displayValue != 0.0{
            var displayText = display.text!
            if displayText.characters.count != 1{
                let endIndex = displayText.index(displayText.endIndex, offsetBy: -1)
                displayText = displayText.substring(to: endIndex)
            }else{
                displayText = "0.0"
            }
        }
    }
    
    //CalculatorBrain
    fileprivate var brain = CalculatorBrain()

    @IBAction fileprivate func performOperation(_ sender: UIButton) {
        //Have typed numbers -- put in operand
        if(userIsInTheMiddleOfTyping) {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        //Perform operation on symbol
        if let mathematicalSymbol = sender.currentTitle {
            
            if mathematicalSymbol == "⬅︎"{
                performBackSpace()
            }else{
                brain.performOperation(mathematicalSymbol)
            }
        }
        
        //Return result from brain model
        displayValue = brain.result
    }

}

