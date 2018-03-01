//
//  CalculatorGraphViewController.swift
//  Calculator
//
//  Created by laurenyew on 12/5/17.
//  Copyright © 2017 CS193p. All rights reserved.
//
import UIKit

/**
 * View Controller to show a graph for a given set of coordinates
 */
class CalculatorGraphViewController: UIViewController{
    
    @IBOutlet weak var graphView: CalculatorGraphView!{
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet weak var graphLabel: UILabel!
    //TODO: setup graph on load
    //TODO: setup storyboard to show graph on load
    private func updateUI(){
        
    }
    
    
    
}
