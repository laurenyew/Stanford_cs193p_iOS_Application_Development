//
//  CalculatorGraphView.swift
//  Calculator
//
//  Created by laurenyew on 12/13/17.
//  Copyright © 2017 CS193p. All rights reserved.
//

import UIKit

@IBDesignable
class CalculatorGraphView: UIView
{
    @IBInspectable
    var scale: CGFloat = 0.9

    @IBInspectable
    var color: UIColor = UIColor.blue
    
    private var axesDrawer = AxesDrawer()
   
    override func draw(_ rect: CGRect) {
        color.setStroke()
        axesDrawer.color = color
        axesDrawer.drawAxes(in: rect, origin: CGPoint(x: 0,y: 0), pointsPerUnit: scale)
    }
}
