//
//  ViewController.swift
//  Tippo
//
//  Created by William Johnson on 12/27/15.
//  Copyright (c) 2015 William Johnson. All rights reserved.
//

import UIKit
import AnalyticsSwift

class ViewController: UIViewController {
    
    var analytics: Analytics!
    
    @IBOutlet weak var tippoQuote: UILabel!
    @IBOutlet weak var tippoMascot: UIImageView!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipSegment: UISegmentedControl!
    @IBOutlet weak var friendsView: UIView!
    @IBOutlet weak var twoFriendsLabel: UILabel!
    @IBOutlet weak var threeFriendsLabel: UILabel!
    @IBOutlet weak var fourFriendsLabel: UILabel!
    @IBOutlet weak var fiveFriendsLabel: UILabel!
    @IBOutlet weak var friendsContainer: UIView!
    
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
        // Logic to show more
        let amount = NSString(string: billField.text!).floatValue
        storeBillAmount(amount)
        print(amount)
        let message = TrackMessageBuilder(event: "Button A").userId("prateek")
        analytics.enqueue(message)
        analytics.flush()
        if (amount <= 0) {
            tippoQuote.text = "Don't be shy, I'm here to help!"
            animateFieldsOut()
        }
        if (amount != 0) {
            tippoQuote.text = "Oooo!"
            animateFieldsIn()
        }
        let tipPercentage = getTipPercentage()
        
        updateValues(amount,tipPercentage: tipPercentage)
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func formatText(value: Float) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale.currentLocale()
        return formatter.stringFromNumber(value)!
    }
    
    func updateValues(amount: Float, tipPercentage: Float) {
        let tip = amount * tipPercentage
        let total = amount + tip
        
        tipLabel.text = formatText(tip)
        totalLabel.text = formatText(total)
        twoFriendsLabel.text = formatText(total / 2)
        threeFriendsLabel.text = formatText(total / 3)
        fourFriendsLabel.text = formatText(total / 4)
        fiveFriendsLabel.text = formatText(total / 5)
    }
    
    func getTipPercentage() -> Float {
        let tipPercentages = getSegmentValues()
        let tipPercentage = Float(tipPercentages[tipSegment.selectedSegmentIndex])/100
        return tipPercentage
    }
    
    func storeBillAmount(amount: Float) {
        defaults.setFloat(amount, forKey: "billAmount")
    }
    
    func getBillAmount() -> Float {
        let amount = defaults.floatForKey("billAmount")
        return amount
    }
    
    func getDefaultSegment() -> Int {
      let index = defaults.integerForKey("defaultSegment")
        return index
    }
    
    func getSegmentValues() -> [Int] {
        let values = defaults.objectForKey("tipValues") as? [Int] ?? [10,15,20]
        return values
    }
    
    func setSegmentValue(value: Int, index: Int) {
        tipSegment.setTitle("\(value)%", forSegmentAtIndex: index)
    }
    
    // Calculate when it was last open and remove bill amount if it's been too long
    func appBecameActive() {
        let lastActive = defaults.doubleForKey("dateTerminated")
        let now = NSDate().timeIntervalSince1970
        let timeDelta = now - lastActive
        
        if (timeDelta > 600) {
            storeBillAmount(0)
        }
    }
    
    // Save the date the app was terminated
    func appWillTerminate() {
        let date = NSDate().timeIntervalSince1970
        defaults.setDouble(date, forKey: "dateTerminated")
        defaults.synchronize()
    }
    
    // Set the styles
    func setStyles() {
        let themeIndex = defaults.integerForKey("themeIndex")
        if (themeIndex == 1) {
            Style.themeDark()
        } else {
            Style.themeLight()
        }
        billField.backgroundColor = Style.billBackgroundColor
        billField.tintColor = Style.totalTextColor
        billField.textColor = Style.billTextColor
        tipLabel.textColor = Style.tipTextColor
        totalLabel.textColor = Style.totalTextColor
        tipSegment.tintColor = Style.totalTextColor
        friendsView.backgroundColor = Style.viewBackgroundColor
        friendsContainer.backgroundColor = Style.viewBackgroundColor
        self.view.backgroundColor = Style.viewBackgroundColor
    }
    
    // Handle updating the UI based on the bill Amount
    func handleDisplayLogic() {
        setStyles()
        let billAmount = getBillAmount()
        if (billAmount == 0) {
            animateFieldsOut()
            tippoQuote.text = "Don't be shy, I'm here to help! Click the box below"
        } else {
            print(billAmount)
            animateFieldsIn()
            tippoQuote.text = "Welcome Back! I saved this for you"
            billField.text = String(billAmount)
            let tipPercentage = getTipPercentage()
            updateValues(billAmount, tipPercentage: tipPercentage)
        }
    }
    
    func animateFieldsIn() {
        UIView.animateWithDuration(0.4, animations: {
            self.billField.frame = CGRectMake(24, 127, 327, 97)
            self.tippoQuote.frame = CGRectMake(95, 78, 260, 50)
            self.tippoMascot.frame = CGRectMake(40, 92, 38, 36)
            self.friendsView.hidden = false
            self.totalLabel.alpha = 1
            self.tipLabel.alpha = 1
            self.tipSegment.alpha = 1
        })
    }
    
    func animateFieldsOut() {
        UIView.animateWithDuration(0.4, animations: {
            self.billField.frame = CGRectMake(24, 190, 327, 150)
            self.tippoQuote.frame = CGRectMake(95, 78, 260, 150)
            self.tippoMascot.frame = CGRectMake(40, 92, 38, 136)
            self.totalLabel.alpha = 0
            self.tipLabel.alpha = 0
            self.friendsView.hidden = true
            self.tipSegment.alpha = 0
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateSegments()
        handleDisplayLogic()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSegments()
        handleDisplayLogic()
        let notificationCenter = NSNotificationCenter.defaultCenter()
        analytics = Analytics.create("3GN7Xqg1LLpwMdAPH5M2MsxbTHEo80Nc")
        
        notificationCenter.addObserver(self,
            selector: Selector("appBecameActive"),
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
        
        notificationCenter.addObserver(self,
            selector: Selector("appWillTerminate"),
            name: UIApplicationWillTerminateNotification,
            object: nil)
        
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        print("Bye!")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
