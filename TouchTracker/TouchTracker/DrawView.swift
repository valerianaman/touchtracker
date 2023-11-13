//
//  DrawView.swift
//  TouchTracker
//
//  Created by Gonzalo Benítez Bueno on 13/11/23.
//

import UIKit

class DrawView: UIView{
    
//    MARK: Vbles
    
    var currentLine: Line?
    var finishedLines = [Line]()
    
//    MARK: Drawing
    
    func stroke(_ line: Line){
        let path = UIBezierPath()
        path.lineWidth = 10
        path.lineCapStyle = .round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect){
        UIColor.black.setStroke()
        for line in finishedLines{
            stroke(line)
        }
        
        if let line = currentLine{
            UIColor.red.setStroke()
            stroke(line)
        }
    }
    
//     MARK: Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        let location = touch?.location(in: self)
        
        currentLine = Line(begin: location!, end: location!)
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        
        currentLine?.end = location!
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if var line = currentLine{
            let touch = touches.first!
            let location = touch.location(in: self)
            line.end = location
            
            finishedLines.append(line)
            
        }
        currentLine = nil
        setNeedsDisplay()
    }
    
    
        
    
}
