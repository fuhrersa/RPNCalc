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
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: Properties

    @IBOutlet weak var secondButton: UIButton!

    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: Actions
    
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
}

