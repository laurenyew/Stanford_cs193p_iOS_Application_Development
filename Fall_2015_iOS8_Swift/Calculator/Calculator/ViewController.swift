//
//  ViewController.swift
//  Calculator
//
//  Created by laurenyew on 4/9/16.
//  Copyright © 2016 CS193p. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!

    var userIsInTheMiddleOfTypingANumber: Bool = false
    
    //Can also be:
    //var operandStack2 : [Double] = []
    var operandStack = Array<Double>()
    
    var displayValue: Double
    {
        //When get out, take display value out of label
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        //When set value as a double, want label to update
        set{
           display.text = "\(newValue)"
        }
    }
    
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        print("digit = \(digit)")
        if(userIsInTheMiddleOfTypingANumber)
        {
            display.text = display.text! + digit
        }
        else{
            display.text = digit;
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    
    @IBAction func touchEnter() {
        print("Selected Enter Button")
        operandStack.append(displayValue)
        userIsInTheMiddleOfTypingANumber = false
        
        print("Operand Stack: \(operandStack)")
    }
    
    
    @IBAction func touchOperand(sender: UIButton) {
        let operand = sender.currentTitle!
        print("Selected Operand: \(operand)")
    
        switch(operand)
        {
            case "÷": break
            case "×": break
            case "-": break
            case "+": break
            default: break
        }
        
    }
    
    
    
}

