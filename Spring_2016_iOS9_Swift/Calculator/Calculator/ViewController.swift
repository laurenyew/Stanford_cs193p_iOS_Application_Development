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
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        
        userIsInTheMiddleOfTyping = true
    }

    @IBAction private func performOperation(sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        if let mathmaticalOperation = sender.currentTitle {
            if mathmaticalOperation == "π" {
                display.text = String(M_PI)
            }
        }
    }

}

