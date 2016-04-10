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
    
}

