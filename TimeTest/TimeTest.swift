//
//  TimeTest.swift
//  TimeTest
//
//  Created by Anton Osten on 23/5/15.
//  Copyright (c) 2015 Anton Osten. All rights reserved.
//

import Foundation

let NOMINATIVE = "nominative"
let GENITIVE_FEM = "genitive_fem"


public class TimeInstance
{
    public var hours: Int
    public var minutes: Int
    
    public init(hours: Int, minutes: Int)
    {
        self.hours = hours
        self.minutes = minutes
    }
    
    convenience public init(components: NSDateComponents)
    {
        self.init(hours: components.hour, minutes: components.minute)
    }
    
    convenience public init(timeString: String)
    {
        // turn the string into a date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let date = dateFormatter.dateFromString(timeString)!
        
        // turn the date into date components
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components = calendar.components((NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute),
                                    fromDate: date)
        
        // get the hours and the minutes and initialise self
        let hours = components.hour
        let minutes = components.minute
        self.init(hours: hours, minutes: minutes)        
    }
    
    public var nextHour: Int
        {
            if self.hours == 12
            {
                return 1
            }
            else
            {
                return self.hours + 1
            }
    }
    
    public var toDateComponents: NSDateComponents
        {
            var components = NSDateComponents()
            components.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            components.hour = self.hours
            components.minute = self.minutes
            return components
    }
}

public let verbalMinutes = [1: "одна",
    2: "две",
    3: "три",
    4: "четыре",
    5: "пять",
    6: "шесть",
    7: "семь",
    8: "восемь",
    9: "девять",
    10: "десять",
    11: "одиннадцать",
    12: "двенадцать",
    13: "тринадцать",
    14: "четырнадцать",
    15: "пятнадцать",
    16: "шестнадцать",
    17: "семнадцать",
    18: "восемнадцать",
    19: "девятнадцать",
    20: "двадцать",
    30: "тридцать",
    40: "сорок",
    50: "пятьдесят"]
var reverseVerbalTimes = [String: Int]()

let genitiveExceptions = ["одна": "одной",
    "две": "двух",
    "три": "трёх",
    "четыре": "четырёх",
    "восемь": "восьми",
    "сорок": "сорока",
    "пятьдесят": "пятидесяти"]
var reverseGenitiveExceptions = [String: String]()

let possessiveNumsExceptions = [1: "первого",
    2: "второго",
    3: "третьего",
    4: "четвертого",
    7: "седьмого",
    8: "восьмого"]

func getTime() -> TimeInstance
{
    let hours = arc4random_uniform(11) + 1
    var minutes: Int!
    let partOfTheClock = arc4random_uniform(2)
    
    switch partOfTheClock
    {
    case 0:
        minutes = Int(arc4random_uniform(29)) + 1
    case 1:
        minutes = 30
    case 2:
        minutes =  60 - (Int(arc4random_uniform(29)) + 1)
    default: ()
    }
    
    let time = TimeInstance(hours: Int(hours), minutes: minutes)
    return time
}


func casifyMinute(num: Int, nounCase: String) -> String?
{
    let numArray = Array(String(num))
    let lastNum = String(numArray.last!).toInt()
    
    switch nounCase
    {
    case NOMINATIVE:
        
        // numbers that end in 1 act like 1 (apart from 11)
        if lastNum == 1 && num != 11
        {
            return "минута"
        }
        else if (lastNum > 1 && lastNum < 5) && !(num > 10 && num < 20)
        {
            return "минуты"
        }
        else
        {
            return "минут"
        }
    case GENITIVE_FEM:
        if lastNum == 1 && num != 11
        {
            return "минуты"
        }
        else
        {
            return "минут"
        }
    default:
        return nil
    }
    
}

public func changeNumCase(numString: String, caseTo: String) -> String?
{
    let numString = deyottaize(numString)
    switch caseTo
    {
    case NOMINATIVE:
        if count(reverseGenitiveExceptions.keys) == 0
        {
            for (key, value) in genitiveExceptions
            {
                reverseGenitiveExceptions[value] = key
            }
        }
        
        if let result = reverseGenitiveExceptions[numString]
        {
            return result
        }
        else
        {
            return changeEnding(numString, "ь")
        }
        
    case GENITIVE_FEM:
        if let result = genitiveExceptions[numString]
        {
            return result
        }
        else
        {
            return changeEnding(numString, "и")
        }
    default:
        return nil
    }
}

func minutesToText(minutes: Int) -> String!
{
    if minutes <= 19
    {
        return verbalMinutes[minutes]
    }
    else
    {
        let stringMinutes = minutes.description
        let minutesArray = Array(stringMinutes)
        let ten = (String(minutesArray.first!) + "0").toInt()!
        let one = String(minutesArray.last!).toInt()!
        let tenText = verbalMinutes[ten]!
        
        // for numbers that are x1
        if let oneText = verbalMinutes[one]
        {
            return "\(tenText) \(oneText)"
        }
        // for numbers that are x0
        else
        {
            return "\(tenText)"
        }
        
    }
}

func deyottaize(text: String) -> String
{
    let noyo = text.stringByReplacingOccurrencesOfString("ё", withString: "е")
    return noyo
}

public func changeEnding(text: String, ending: String) -> String
{
    let stem = text.substringToIndex(text.endIndex.predecessor())
    let newString = stem + ending
    return newString
}


public func verbaliseTime(time: TimeInstance, short: Bool = false) -> String
{
    var result: String
    var textHour: String?
    var textMinutes: String
    
    if time.minutes <= 30
    {
        textHour = possessiveNumsExceptions[time.nextHour]
        if textHour == nil
        {
            textHour = changeEnding(verbalMinutes[time.nextHour]!, "ого")
        }
    }
    else
    {
        if time.nextHour == 1
        {
            textHour = "час"
        }
        else if time.nextHour == 2
        {
            textHour = "два"
        }
        else
        {
            textHour = verbalMinutes[time.nextHour]!
        }
    }
    
    // it's less than half past
    if time.minutes < 30
    {
        if time.minutes == 15 && short
        {
            textMinutes = "четверть"
            result = "\(textMinutes) \(textHour!)"
        }
        else
        {
            // change the case
            textMinutes = minutesToText(time.minutes)
            let minutesNoun = casifyMinute(time.minutes, NOMINATIVE)
            result = "\(textMinutes) \(minutesNoun!) \(textHour!)"
        }
    }
        
    // it's half past
    else if time.minutes == 30
    {
        var textHour = possessiveNumsExceptions[time.nextHour]
        
        if textHour == nil
        {
            textHour = changeEnding(verbalMinutes[time.nextHour]!, "ого")
        }
        
        if short
        {
            result = "пол\(textHour!)"
        }
        else
        {
            result = "половина \(textHour!)"
        }
    }
        
    // it's over half past
    else
    {
        var casedTextMinutes: String
        let minutesLeft = 60 - time.minutes
        
        // special case for a quarter and short form
        if minutesLeft == 15 && short
        {
            casedTextMinutes = "четверти"
        }
        else
        {
            casedTextMinutes = ""
            textMinutes = minutesToText(minutesLeft)
            let splitstring = split(textMinutes, allowEmptySlices: false, isSeparator: {$0 == " "})
            
            // put the numeral of minutes in the correct (genitive) case
            for (n, word) in enumerate(splitstring)
            {
                var casedNum: String
                
                if let exception = genitiveExceptions[word]
                {
                    casedNum = exception
                }
                else
                {
                    casedNum = changeEnding(word, "и")
                }
                
                casedTextMinutes += casedNum
                if n + 1 < count(splitstring)
                {
                    casedTextMinutes += " "
                }
            }
        }
        
        // short form
        if short
        {
            result = "без \(casedTextMinutes) \(textHour)"
        }
        else
        {
            let minutesNoun = casifyMinute(minutesLeft, GENITIVE_FEM)!
            result = "без \(casedTextMinutes) \(minutesNoun) \(textHour)"
        }
    }
    
    return result
}
