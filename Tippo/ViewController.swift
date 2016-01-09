//
//  ViewController.swift
//  Tippo
//
//  Created by William Johnson on 12/27/15.
//  Copyright (c) 2015 William Johnson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tippoQuote: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipSegment: UISegmentedControl!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func updateSegments() {
        let defaultSegment = getDefaultSegment()
        tipSegment.selectedSegmentIndex = defaultSegment
        let values = getSegmentValues()
        for i in 0...2 {
            setSegmentValue(values[i], index: i)
        }
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        
        let tipPercentages = getSegmentValues()
        let tipPercentage = Double(tipPercentages[tipSegment.selectedSegmentIndex])/100
        let amount = NSString(string: billField.text!).doubleValue
        let tip = amount * tipPercentage
        let total = amount + tip
        print(amount)
        // update this to only do this on the first try and to revert when empty
        tippoQuote.text = "Oooo!"
        
        tipLabel.text = String(format:"$%.2f", tip)
        totalLabel.text = String(format:"$%.2f", total)
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func getDefaultSegment() -> Int {
      let index = defaults.integerForKey("defaultSegment")
        return index
    }
    
    func getSegmentValues() -> [Int] {
        let values = defaults.objectForKey("tipValues") as! [Int]
        return values
    }
    
    func setSegmentValue(value: Int, index: Int) {
        tipSegment.setTitle("\(value)%", forSegmentAtIndex: index)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateSegments()
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

}

