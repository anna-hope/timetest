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
        timeField.stringValue = timeFormatter.stringForObjectValue(time.toDateComponents)!
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
        let answer = answerField.stringValue
        
        let time = TimeInstance(timeString: timeField.stringValue)
        let correctVerbalTime = verbaliseTime(time)
        
        if answer == correctVerbalTime
        {
           moveOn()
        }
        else if answer == verbaliseTime(time, short: true)
        {
            moveOn()
        }
        else
        {
            answerField.backgroundColor = NSColor.redColor()
        }
        
    }
    
    @IBAction func seeTime(sender: AnyObject)
    {
        let time = TimeInstance(timeString: timeField.stringValue)
        let correctVerbalTime = verbaliseTime(time)
        let correctShortTime = verbaliseTime(time, short: true)
        
        var message = correctVerbalTime
        if correctVerbalTime != correctShortTime
        {
            message += " или \(correctShortTime)"
        }
        
        let tipAlert = NSAlert()
        tipAlert.alertStyle = NSAlertStyle.InformationalAlertStyle
        tipAlert.messageText = message
        tipAlert.beginSheetModalForWindow(window, completionHandler: nil)
    }
    
    

}

