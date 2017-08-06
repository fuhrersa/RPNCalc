//
//  ViewController.swift
//  RPNCalc
//
//  Created by Samuel Fuhrer on 7/27/17.
//  Copyright © 2017 Samuel Fuhrer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var showLeft: Bool = true
    var numberFormatter: NumberFormatter = NumberFormatter()
    var decimalSeparator: Character = "."
    var thousandSepartor: Character = ","
    var calc: Calculator = Calculator(name: "calc")
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        calc.numberFormatter = numberFormatter
        numberFormatter.minimumFractionDigits = 6
        updateLocale()
        updateStackDisplay()
    }
    
    
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(calc.stack.depth, forKey: "depth")
        
        for i in 0...calc.stack.depth-1 {
            coder.encode(calc.stack.get(i), forKey: "stack\(i)")
        }
        
        print("saved state")
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        
        let depth = coder.decodeInteger(forKey: "depth")
        
        for i in 0...depth-1 {
            let value = coder.decodeDouble(forKey: "stack\(depth-1-i)")
            try? calc.stack.push(value)
        }
        print("restored state")
        updateStackDisplay()
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        return
    }
    
    func updateLocale() {
        let str = numberFormatter.decimalSeparator
        if (str != nil) {
            let index = str!.index(str!.startIndex, offsetBy: 0)
            decimalSeparator = str![index]
            
        }
        else {
           decimalSeparator = "."
        }
        
        calc.decimalSeparator = decimalSeparator
    }
    
    open override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    
        
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            return .portrait
        }
    }
    
  
    //MARK: Properties
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var stack0Label: UILabel!
    @IBOutlet weak var stack1Label: UILabel!
    @IBOutlet weak var stack2Label: UILabel!
    @IBOutlet weak var stack3Label: UILabel!
   
    
    //MARK: Actions
    
    @IBAction func pushButton(_ sender: CalcButton) {
        if (sender.tag >= 100 && sender.tag <= 109) {
            calc.inputDigit(digit: sender.tag-100)
        }
        else {
            switch(sender.tag) {
            case(200) : calc.add()
            case(201) : calc.subtract()
            case(202) : calc.multiply()
            case(203) : calc.divide()
            case(300) : calc.delete()
            case(110) : calc.changeSign()
            case(500) : calc.enter()
            case(112) : calc.inputDecimalPoint()
            case(111) : calc.inputExponent()
            case(205) : calc.sin()
            case(206) : calc.cos()
            case(207) : calc.tan()
            case(208) : calc.inv()
            case(209) : calc.asin()
            case(210) : calc.acos()
            case(211) : calc.atan()
            case(212) : calc.pi()
            case(213) : calc.sqrt()
            case(214) : calc.sq()
            case(215) : calc.rt()
            case(216) : calc.pow()
            case(217) : calc.log()
            case(218) : calc.exp10()
            case(219) : calc.ln()
            case(220) : calc.exp()
            default : break;
            
            }
        }
        if (sender.tag >= 205 && sender.tag <= 220) {
         //   scroll(sender)
        }
        updateStackDisplay()
    }
    
   
    
    //MARK: functions
    
    func getStackString(index: Int) -> String? {
        if (calc.stack.depth <= index) {
            return ""
        }
        else {
            let num: NSNumber = NSNumber(value: calc.stack.get(index))
            
            if ((abs(calc.stack.get(index)) >= 1e9 || abs(calc.stack.get(index)) < 1e-6) && calc.stack.get(index) != 0) {
                numberFormatter.numberStyle = .scientific
            }
            else {
                numberFormatter.numberStyle = .decimal
            }
            return numberFormatter.string(from: num)

        }
    }
    
    func updateStackDisplay() {
        print(calc.state)
        var stackLabels: [UILabel] = [stack0Label, stack1Label, stack2Label, stack3Label]
        
        if (calc.state == State.idle) {
            for i in 0...3 {
                stackLabels[i].text = getStackString(index: i)
                stackLabels[i].textAlignment = NSTextAlignment.right
            }
        }
        else {
            for i in 1...3 {
                stackLabels[i].text = getStackString(index: i-1)
                stackLabels[i].textAlignment = NSTextAlignment.right
            }
            
            let str = String(calc.mantissa)
            
            if (calc.state == State.error) {
                stackLabels[0].text = "Error"
                stack0Label.textAlignment = NSTextAlignment.right
            }
            else {
                stackLabels[0].text = str + "_"
                stack0Label.textAlignment = NSTextAlignment.left
            }
            
            
        }
        
    }

}

