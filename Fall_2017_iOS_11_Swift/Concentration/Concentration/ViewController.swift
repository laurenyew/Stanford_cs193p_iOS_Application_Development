//
//  ViewController.swift
//  Concentration
//
//  Created by laurenyew on 7/22/18.
//  Copyright © 2018 Stanford. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    
    private var emojis = ["😍","🤨","🤨","😍"]
    private var flipCount = 0 {
        didSet{
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardIndex = cardButtons.index(of: sender){
            flipCard(withEmoj: emojis[cardIndex], on: sender)
        }else{
            print("Chosen card was not in cardButtons")
        }
        
    }
    
    func flipCard(withEmoj emoji:String, on button:UIButton) {
        if(button.currentTitle == emoji){
            button.setTitle("", for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        }else{
            button.setTitle(emoji, for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        flipCount += 1
    }
}

