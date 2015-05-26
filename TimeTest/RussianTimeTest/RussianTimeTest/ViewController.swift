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
        timeLabel.text = timeFormatter.stringForObjectValue(time.toDateComponents)!
    }
    
    func checkTime(answer: String)
    {
        let time = TimeInstance(timeString: timeLabel.text!)
        let correctTime = verbaliseTime(time)
        
        if answer == correctTime
        {
            moveOn()
        }
        else if answer == verbaliseTime(time, short: true)
        {
            moveOn()
        }
        else
        {
            answerField.backgroundColor = UIColor.redColor()
        }
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
        let correctShortTime = verbaliseTime(time, short: true)
        
        var message = correctVerbalTime
        if correctVerbalTime != correctShortTime
        {
            message += " или \(correctShortTime)"
        }
        
        let tipAlert = UIAlertController(title: "подсказка", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "ок", style: UIAlertActionStyle.Default, handler: nil)
        tipAlert.addAction(defaultAction)
        self.presentViewController(tipAlert, animated: true, completion: nil)
    }

}

