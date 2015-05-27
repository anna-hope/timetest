//
//  ViewController.swift
//  RussianTimeTest
//
//  Created by Anton Osten on 25/5/15.
//  Copyright (c) 2015 Anton Osten. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var peekButton: UIButton!
    @IBOutlet weak var answerField: UITextField!
    var timeFormatter: NSDateComponentsFormatter!
    
    @IBOutlet weak var countLabel: UILabel!
    var answerCount = 0

    override func viewDidLoad()
    {
        super.viewDidLoad()
        answerField.delegate = self
        
        countLabel.text = ""
        timeFormatter = NSDateComponentsFormatter()
        populateTimeField()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateTimeField()
    {
        let time = getTime()
        
        let timeString = timeFormatter.stringForObjectValue(time.toDateComponents)!
        if let currentValue = timeLabel.text
        {
            // make sure it's not the same as the old value
            while timeString == currentValue
            {
                return populateTimeField()
            }
        }
        timeLabel.text = timeString
    }
    
    func checkTime(answer: String)
    {
        let answer = deyottaize(answerField.text)
        let time = TimeInstance(timeString: timeLabel.text!)
        let correctTimes = verbaliseTime(time)
        
        for verbalTime in correctTimes
        {
            if answer == deyottaize(verbalTime)
            {
                return moveOn()
            }
        }
        
        answerField.backgroundColor = UIColor.redColor()
    }
    
    func moveOn()
    {
        answerField.backgroundColor = UIColor.whiteColor()
        answerField.text = ""
        populateTimeField()
        
        answerCount += 1
        countLabel.text = String(answerCount)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        let answer = textField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        checkTime(answer)
        return true
    }

    @IBAction func seeTime(sender: AnyObject)
    {
        let time = TimeInstance(timeString: timeLabel.text!)
        let correctVerbalTime = verbaliseTime(time)
        let correctTimes = verbaliseTime(time)
        
        var message = ""
        for (n, verbalTime) in enumerate(correctTimes)
        {
            if n == 0
            {
                message = verbalTime
            }
            else
            {
                message += "\n\(verbalTime)"
            }
        }

        
        let tipAlert = UIAlertController(title: "подсказка", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "ок", style: UIAlertActionStyle.Default, handler: nil)
        tipAlert.addAction(defaultAction)
        self.presentViewController(tipAlert, animated: true, completion: nil)
    }

}

