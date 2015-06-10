//
//  AppDelegate.swift
//  TimeTest
//
//  Created by Anton Osten on 23/5/15.
//  Copyright (c) 2015 Anton Osten. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var timeField: NSTextField!
    @IBOutlet weak var answerField: NSTextField!
    var timeFormatter: NSDateComponentsFormatter!
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var answerCountField: NSTextField!
    var answerCount = 0


    func applicationDidFinishLaunching(aNotification: NSNotification)
    {
        timeFormatter = NSDateComponentsFormatter()
        populateTimeField()
        answerCountField.stringValue = ""
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func populateTimeField()
    {
        let time = getTime()
        
        let timeString = timeFormatter.stringForObjectValue(time.toDateComponents)!
        // make sure it's not the same as the old value
        while timeString == timeField.stringValue
        {
            return populateTimeField()
        }
        timeField.stringValue = timeString
    }
    
    func moveOn()
    {
        populateTimeField()
        answerField.backgroundColor = NSColor.greenColor()
        answerField.stringValue = ""
        answerField.display()
        
        answerCount += 1
        answerCountField.integerValue = answerCount
    }

    
    @IBAction func checkTime(sender: AnyObject)
    {
        // remove possible ё's from the answer
        let answer = deyottaize(answerField.stringValue)
        let time = TimeInstance(timeString: timeField.stringValue)
        let correctTimes = verbaliseTime(time)
        
        for verbalTime in correctTimes
        {
            if answer == deyottaize(verbalTime)
            {
                return moveOn()
            }
        }
        
        answerField.backgroundColor = NSColor.redColor()
        
    }
    
    @IBAction func seeTime(sender: AnyObject)
    {
        let time = TimeInstance(timeString: timeField.stringValue)
        let correctTimes = verbaliseTime(time)
        
        var message = ""
        for (n, verbalTime) in correctTimes.enumerate()
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
        
        let tipAlert = NSAlert()
        tipAlert.alertStyle = NSAlertStyle.InformationalAlertStyle
        tipAlert.messageText = message
        tipAlert.beginSheetModalForWindow(window, completionHandler: nil)
    }
    
    

}

