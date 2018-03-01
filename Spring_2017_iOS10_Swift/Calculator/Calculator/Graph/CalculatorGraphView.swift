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
    var scale: CGFloat = 40 {didSet {setNeedsDisplay()}}

    @IBInspectable
    var axesColor: UIColor = UIColor.blue {didSet {setNeedsDisplay()}}
    
    @IBInspectable
    var graphColor: UIColor = UIColor.red
    
    
    // Center of the graph being viewed on the screen
    // Used for calculating path via scale for each part of screen
    var graphViewCenter: CGPoint{
        return center
    }
    
    // Saved Origin of the function (changes propagate to the view here)
    var originRelativeToGraphViewCenter: CGPoint = CGPoint.zero {didSet{setNeedsDisplay()}}
    
    // Calculated origin of function
    // Used for main logic, can be set to update the view's origin
    var origin: CGPoint{
        get{
            var funcOrigin = originRelativeToGraphViewCenter
            funcOrigin.x += graphViewCenter.x
            funcOrigin.y += graphViewCenter.y
            return funcOrigin
        }
        set{
            var funcOrigin = newValue
            funcOrigin.x -= graphViewCenter.x
            funcOrigin.y -= graphViewCenter.y
            originRelativeToGraphViewCenter = funcOrigin
        }
    }
    
    //Graphing function: returns value Y for given value X for a given function
    //If this value is changed, redraw
    var graphFunctionY: ((Double) -> Double?)? {didSet {setNeedsDisplay()}}
    
    private var axesDrawer = AxesDrawer()
   
    override func draw(_ rect: CGRect) {
        axesColor.setStroke()
        axesDrawer.color = axesColor
        axesDrawer.drawAxes(in: bounds, origin: origin, pointsPerUnit: scale)
        //Draw the graph function in the view using the graphFunctionY
        drawGraphFunction(in: bounds, origin: origin, pointsPerUnit: scale)
    }
    
    //Handles UI of drawing new function
    private func drawGraphFunction(in rect: CGRect, origin: CGPoint, pointsPerUnit: CGFloat){
        var graphX, graphY:CGFloat
        var x,y: Double
        UIGraphicsGetCurrentContext()?.saveGState()
        graphColor.set()
        
        let path = UIBezierPath()
        path.lineWidth = 20.0
        
        //For the graph view's width, calculate the function and show
        for i in 0...Int(rect.size.width * scale) {
            graphX = CGFloat(i)
            x = Double((graphX - origin.x)/scale)
            y = graphFunctionY?(x) ?? 0
            graphY = (CGFloat(y) + origin.y) * scale
            path.addLine(to: CGPoint(x: graphX, y: graphY))
        }
        path.stroke()
        
        UIGraphicsGetCurrentContext()?.restoreGState()
    }
}
