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
    
    private var skullRadius: CGFloat{
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private var skullCenter: CGPoint {
       return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private func pathForSkull() -> UIBezierPath{
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: false)
        path.lineWidth = 5.0
        return path
    }
    override func draw(_ rect: CGRect) {
    
        UIColor.blue.setStroke()
        pathForSkull().stroke()
    }
}
