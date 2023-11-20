//
//  DrawView.swift
//  TouchTracker
//
//  Created by Gonzalo Benítez Bueno on 13/11/23.
//

import UIKit

class DrawView: UIView{
    
//    MARK: Vbles
    
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    var selectedeLineIndex: Int?
   
    
//    MARK: Functions
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.doubleTap(_:)) )
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        
    }
    
    func indexOfLine(at point: CGPoint) -> Int?{
        for (index, line) in finishedLines.enumerated(){
            let begin = line.begin
            let end = line.end
        
            for t in stride(from: CGFloat(0), to:1.0, by: 0.05){
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                if hypot(x - point.x, y - point.y)<20.0 {
                    return index
                }
            }
        }
        
        return nil
        
    }

    
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
        
            
        UIColor.red.setStroke()
        for (_, line) in currentLines{
            stroke(line)
        }
        
        if let index = selectedeLineIndex{
            UIColor.green.setStroke()
            let selectedLine = finishedLines[index]
            stroke(selectedLine)
        }
        
    }
    
//     MARK: Touches
    
    @objc func doubleTap(_ gestureRecognizer: UIGestureRecognizer){
        
        currentLines.removeAll()
        finishedLines.removeAll()
        selectedeLineIndex = nil
        setNeedsDisplay()
    }
    
    @objc func tap(_ gestureRecognizer: UIGestureRecognizer){
        
        let point = gestureRecognizer.location(in: self)
        selectedeLineIndex = indexOfLine(at: point)
        
        setNeedsDisplay()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print(#function)
        
        for touch in touches{
            let location = touch.location(in: self)
            
            let newLine = Line(begin: location, end: location)
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine

        }
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        for touch in touches{
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
                      
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            
            if var line = currentLines[key]{
                line.end = touch.location(in: self)
                
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        currentLines.removeAll()
        
        setNeedsDisplay()
    }
        
    
}
