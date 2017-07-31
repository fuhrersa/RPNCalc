//
//  CalcButton.swift
//  RPNCalc
//
//  Created by Samuel Fuhrer on 7/28/17.
//  Copyright © 2017 Samuel Fuhrer. All rights reserved.
//

import UIKit

extension UIColor {
    func intensity (_ percentage: CGFloat) -> UIColor? {
        var r: CGFloat=0, g: CGFloat=0, b: CGFloat=0, a: CGFloat=0
        if (self.getRed(&r, green: &g, blue: &b, alpha: &a)) {
            return UIColor(red: r*percentage, green: g*percentage, blue: b*percentage, alpha: a)
        }
        else {
            print("error")
            return nil
        }
    }
}
class CalcButton : UIButton, UIInputViewAudioFeedback
{
    
    var colorPressed: UIColor?
    var colorReleased: UIColor?
    
  
   var enableInputClicksWhenVisible: Bool {
     
            return true
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
            }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        initColors()
    }
    
    func initColors() {
        setTitleColor(.white, for: UIControlState.normal)

        if (tag >= 200 && tag <= 203) {
            titleLabel!.font = UIFont.systemFont(ofSize: 35.0)

        }
        else {
            titleLabel!.font = UIFont.systemFont(ofSize: 25.0)

        }

        
        if (tag < 200) { // gray
            colorReleased = UIColor.lightGray.intensity(1.4)
            setTitleColor(.black, for: UIControlState.normal)

        }
        else if (tag < 300) { // blue
            colorReleased = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        }
        else if (tag < 400) { // orange
            colorReleased = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
            
        }
        else if (tag < 500){// red
            colorReleased = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
        }
        else { // green
            colorReleased = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        }
        
        colorPressed = colorReleased!.intensity(0.8)
        
        // fix labels
        let myFont = UIFont(name: titleLabel!.font!.fontName, size: titleLabel!.font.pointSize)
        let superscriptAttributes: [String : Any] = [ NSBaselineOffsetAttributeName: 10, NSFontAttributeName:  myFont! ]
       
        switch (tag) {
        case(214):
            let str = NSMutableAttributedString(string: "x2")
            str.addAttributes(superscriptAttributes, range: NSRange(location: 1, length: 1))
            setAttributedTitle(str, for: UIControlState.normal)
        case(215):
            let str = NSMutableAttributedString(string: " x√y")
            str.addAttributes(superscriptAttributes, range: NSRange(location: 1, length: 1))
            setAttributedTitle(str, for: UIControlState.normal)
        case(216):
            let str = NSMutableAttributedString(string: "yx")
            str.addAttributes(superscriptAttributes, range: NSRange(location: 1, length: 1))
            setAttributedTitle(str, for: UIControlState.normal)
        case(218):
            let str = NSMutableAttributedString(string: "10x")
            str.addAttributes(superscriptAttributes, range: NSRange(location: 2, length: 1))
            setAttributedTitle(str, for: UIControlState.normal)
        case(220):
            let str = NSMutableAttributedString(string: "ex")
            str.addAttributes(superscriptAttributes, range: NSRange(location: 1, length: 1))
            setAttributedTitle(str, for: UIControlState.normal)

        default: break
        }
     backgroundColor = colorReleased
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIDevice.current.playInputClick()

        UIView.animate(withDuration: 0.05, delay: 0, options: [UIViewAnimationOptions.allowUserInteraction], animations: { () ->
        
            Void in
            self.backgroundColor = self.colorPressed })
  
        
        super.touchesBegan(touches, with: event)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [UIViewAnimationOptions.allowUserInteraction], animations: { () -> Void in
            self.backgroundColor = self.colorReleased })

        
        super.touchesEnded(touches, with: event)
    }
 
    
}
