//
//  SettingsViewController.swift
//  Tippo
//
//  Created by William Johnson on 12/27/15.
//  Copyright (c) 2015 William Johnson. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var lowEndSlider: UISlider!
    @IBOutlet weak var midRangeSlider: UISlider!
    @IBOutlet weak var highEndSlider: UISlider!
    @IBOutlet weak var lowEndLabel: UILabel!
    @IBOutlet weak var midRangeLabel: UILabel!
    @IBOutlet weak var highEndLabel: UILabel!
    @IBOutlet weak var lowEndButton: UIButton!
    @IBOutlet weak var midRangeButton: UIButton!
    @IBOutlet weak var highEndButton: UIButton!
    
    let defaults = NSUserDefaults.standardUserDefaults()

    @IBAction func onButtonClick(sender: AnyObject) {
        let priorIndex = getDefaultSegment()
        let newIndex = sender.tag
        
        setDefaultSegment(newIndex)
        updateUnderline(priorIndex)
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        let lowEnd = Int(lowEndSlider.value * 100)
        let midRange = Int(midRangeSlider.value * 100)
        let highEnd = Int(highEndSlider.value * 100)
        let values: [Int] = [lowEnd, midRange, highEnd]
        
        // Set Label Values
        lowEndLabel.text = "\(lowEnd)%"
        midRangeLabel.text = "\(midRange)%"
        highEndLabel.text = "\(highEnd)%"
        
        defaults.setObject(values, forKey: "tipValues")
        defaults.synchronize()
    }
    
    func setDefaultSegment(index: Int){
        defaults.setInteger(index, forKey: "defaultSegment")
    }
    
    func getDefaultSegment() -> Int {
        let segment = defaults.integerForKey("defaultSegment")
        return segment
    }
    
    func updateUnderline(priorIndex:Int?=nil) {
        let buttons = [lowEndButton,midRangeButton,highEndButton]
        
        if let priorIndex = priorIndex {
            let oldButtonText = NSMutableAttributedString(string: (buttons[priorIndex].titleLabel?.text)!)
            oldButtonText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleNone.rawValue, range: NSMakeRange(0, buttons[priorIndex].titleLabel!.text!.utf16.count))
            buttons[priorIndex].setAttributedTitle(oldButtonText, forState: .Normal)
        }
        
        let index = getDefaultSegment()
        let buttonText = NSMutableAttributedString(string: (buttons[index].titleLabel?.text)!)
        buttonText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleDouble.rawValue, range: NSMakeRange(0, buttons[index].titleLabel!.text!.utf16.count))
        buttons[index].setAttributedTitle(buttonText, forState: .Normal)
        

        
    }

    func updateSegments() {
        let values = getSegmentValues()
        for i in 0...2 {
            setSegmentValue(values[i], index: i)
        }
    }
    
    func getSegmentValues() -> [Int] {
        let values = defaults.objectForKey("tipValues") as! [Int]
        return values
    }
    
    func setSegmentValue(value: Int, index: Int) {
        let sliders = [lowEndSlider, midRangeSlider, highEndSlider]
        var labels = [lowEndLabel, midRangeLabel, highEndLabel]
        labels[index].text = "\(value)%"
        //Type coercion for slider value
        var sliderValue = Float(value)
        sliderValue = sliderValue / 100
        sliders[index].value = sliderValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        updateSegments()
        updateUnderline()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissSettingsView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
