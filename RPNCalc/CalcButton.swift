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
class CalcButton : UIButton {
    
    var colorPressed: UIColor?
    var colorReleased: UIColor?
    
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        initColors()
        backgroundColor = colorReleased
    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        initColors()
        backgroundColor = colorReleased
    }
    
    func initColors() {
        setTitleColor(.white, for: UIControlState.normal)

        
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
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1, delay: 0, animations: { () -> Void in
            self.backgroundColor = self.colorPressed })
  
        
        super.touchesBegan(touches, with: event)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2, delay: 0, animations: { () -> Void in
            self.backgroundColor = self.colorReleased })

        
        super.touchesEnded(touches, with: event)
    }
 
    
}
