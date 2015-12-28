//
//  ViewController.swift
//  Tippo
//
//  Created by William Johnson on 12/27/15.
//  Copyright (c) 2015 William Johnson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipSegment: UISegmentedControl!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func updateSegments() {
        // TODO get the segments falling back to .18, .2, .22 if returns nil
        let values = defaults.objectForKey("tipValues") as! [Int]
        var idx = 0
        for (value) in values {
            tipSegment.setTitle("\(value)%", forSegmentAtIndex: idx)
            idx = ++idx
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateSegments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        
        let tipPercentages = [0.18, 0.2, 0.22]
        let tipPercentage = tipPercentages[tipSegment.selectedSegmentIndex]
        let amount = NSString(string: billField.text!).doubleValue
        let tip = amount * tipPercentage
        let total = amount + tip
        
        tipLabel.text = String(format:"$%.2f", tip)
        totalLabel.text = String(format:"$%.2f", total)
    }
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }

}

