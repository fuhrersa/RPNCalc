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
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStackDisplay()
        // Do any additional setup after loading the view, typically from a nib.
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
    
    let calc: Calculator = Calculator(name: "calc")

    @IBOutlet weak var secondButton: UIButton!

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var stack0Label: UILabel!
    @IBOutlet weak var stack1Label: UILabel!
    @IBOutlet weak var stack2Label: UILabel!
    @IBOutlet weak var stack3Label: UILabel!
    
    @IBOutlet weak var stack0TitleLabel: UILabel!
    @IBOutlet weak var stack1TitleLabel: UILabel!
    @IBOutlet weak var stack2TitleLabel: UILabel!
    @IBOutlet weak var stack3TitleLabel: UILabel!
    
    
  
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
            scroll(sender)
        }
        updateStackDisplay()
    }
    
    
    @IBAction func scroll(_ sender: UIButton) {
        showLeft = !showLeft
        
        if (showLeft) {
            let offset = CGPoint(x:0, y:0)
            scrollView.setContentOffset(offset, animated: true)
        }
        else {
            let offset = CGPoint(x: scrollView.contentSize.width/2, y:0)
            scrollView.setContentOffset(offset, animated: true)

        }
    }
    
    //MARK: functions
    
    func getStackString(index: Int) -> String {
        if (calc.stack.depth <= index) {
            return ""
        }
        else {
            if ((abs(calc.stack.get(index)) >= 1e9 || abs(calc.stack.get(index)) < 1e-6) && calc.stack.get(index) != 0) {
                var str = String(format: "%.6E", calc.stack.get(index))
                if (str.contains("+")) {
                    str.remove(at: str.range(of: "+")!.lowerBound)
                }
                return str
            }
            else {
                return String(format: "%.6f", calc.stack.get(index))
            }
        }
    }
    
    func updateStackDisplay() {
        print(calc.state)
        var stackLabels: [UILabel] = [stack0Label, stack1Label, stack2Label, stack3Label]
        var stackTitleLabels: [UILabel] = [stack0TitleLabel, stack1TitleLabel, stack2TitleLabel, stack3TitleLabel]
        
        if (calc.state == State.idle) {
            for i in 0...3 {
                stackLabels[i].text = getStackString(index: i)
                stackLabels[i].textAlignment = NSTextAlignment.right
                stackTitleLabels[i].text = ""//String(i) + ":"
            }
        }
        else {
            for i in 1...3 {
                stackLabels[i].text = getStackString(index: i-1)
                stackLabels[i].textAlignment = NSTextAlignment.right
                stackTitleLabels[i].text = ""//String(i-1) + ":"
            }
            
            let str = String(calc.mantissa)
            
            stackLabels[0].text = str + "_"
            stack0Label.textAlignment = NSTextAlignment.left
            stack0TitleLabel.text = ""
            
        }
        
    }

}

