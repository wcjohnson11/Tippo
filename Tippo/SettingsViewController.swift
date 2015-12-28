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
    
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        
        let lowEnd = Int(lowEndSlider.value * 100)
        let midRange = Int(midRangeSlider.value * 100)
        let highEnd = Int(highEndSlider.value * 100)
        let values = [lowEnd, midRange, highEnd]
        
        lowEndLabel.text = "\(lowEnd)%"
        midRangeLabel.text = "\(midRange)%"
        highEndLabel.text = "\(highEnd)%"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(values, forKey: "tipValues")
        defaults.synchronize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
