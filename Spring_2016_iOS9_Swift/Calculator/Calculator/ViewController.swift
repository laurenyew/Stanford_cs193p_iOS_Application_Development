//
//  ViewController.swift
//  Calculator
//
//  Created by laurenyew on 7/23/16.
//  Copyright © 2016 CS193p. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping: Bool = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        let textCurrentlyInDisplay = display.text!
        
        if userIsInTheMiddleOfTyping {
            if(digit != "." || textCurrentlyInDisplay.rangeOfString(digit) == nil){
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
        }
        
        userIsInTheMiddleOfTyping = true
    }
    
    //UI Label display value
    private var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    //CalculatorBrain
    private var brain = CalculatorBrain()

    @IBAction private func performOperation(sender: UIButton) {
        //Have typed numbers -- put in operand
        if(userIsInTheMiddleOfTyping) {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        //Perform operation on symbol
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        //Return result from brain model
        displayValue = brain.result
    }

}

