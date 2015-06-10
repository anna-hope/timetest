//
//  TimeTest.swift
//  TimeTest
//
//  Created by Anton Osten on 23/5/15.
//  Copyright (c) 2015 Anton Osten. All rights reserved.
//

import Foundation

let NOMINATIVE_FEM = "NOMINATIVE_FEM_fem"
let NOMINATIVE_MASC = "NOMINATIVE_masc"
let GENITIVE_FEM = "genitive_fem"

let minuteWord = "минута"
let hourWord = "час"


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
    
    convenience public init(fromDate date: NSDate)
    {
        // turn the date into date components
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components = calendar.components(([NSCalendarUnit.Hour, NSCalendarUnit.Minute]),
            fromDate: date)
        
        // get the hours and the minutes and initialise self
        let hours = components.hour
        let minutes = components.minute
        self.init(hours: hours, minutes: minutes)
    }
    
    convenience public init(timeString: String)
    {
        // turn the string into a date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let date = dateFormatter.dateFromString(timeString)!
        self.init(fromDate: date)
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
        let components = NSDateComponents()
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

let verbalHourExceptions = [1: "час",
                            2: "два"]

let genitiveFemExceptions = ["одна": "одной",
    "две": "двух",
    "три": "трёх",
    "четыре": "четырёх",
    "восемь": "восьми",
    "сорок": "сорока",
    "пятьдесят": "пятидесяти"]
var reverseGenitiveFemExceptions = [String: String]()

let possessiveNumsExceptions = [1: "первого",
    2: "второго",
    3: "третьего",
    4: "четвертого",
    7: "седьмого",
    8: "восьмого"]

func getTime() -> TimeInstance
{
    let hours = arc4random_uniform(12) + 1
    let minutes: Int
    let partOfTheClock = arc4random_uniform(5)
    
    switch partOfTheClock
    {
    case 0:
        minutes = Int(arc4random_uniform(30)) + 1
    case 1:
        minutes = 30
    case 2:
        minutes =  60 - Int(arc4random_uniform(30))
    case 3:
        // on the hour
        minutes = 0
    default:
        // current time
        let timeNow = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        dateFormatter.dateFormat = "hh:mm"
        // force 12 hour time
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let timeString = dateFormatter.stringFromDate(timeNow)
        return TimeInstance(timeString: timeString)
    }
    
    let time = TimeInstance(hours: Int(hours), minutes: minutes)
    return time
}


func casify(noun: String, num: Int, nounCase: String) -> String?
{
    let numArray = Array(String(num).characters)
    let lastNum = Int(String(numArray.last!))

    
    switch nounCase
    {
    case NOMINATIVE_MASC, NOMINATIVE_FEM:
        
        // numbers that end in 1 act like 1 (apart from 11)
        if lastNum == 1 && num != 11
        {
            return noun
        }
        else if (lastNum > 1 && lastNum < 5) && !(num > 10 && num < 20)
        {
            if nounCase == NOMINATIVE_FEM
            {
                return changeEnding(noun, ending: "ы")
            }
            else
            {
                // yep
                return noun + "а"
            }
        }
        else
        {
            if nounCase == NOMINATIVE_FEM
            {
                // chop off the ending
                return noun.substringToIndex(noun.endIndex.predecessor())
            }
            else
            {
                // masculine
                return noun + "ов"
            }
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
    switch caseTo
    {
    case NOMINATIVE_FEM:
        if reverseGenitiveFemExceptions.keys.count == 0
        {
            for (key, value) in genitiveFemExceptions
            {
                reverseGenitiveFemExceptions[value] = key
            }
        }
        
        if let result = reverseGenitiveFemExceptions[numString]
        {
            return result
        }
        else
        {
            return changeEnding(numString, ending: "ь")
        }
        
    case GENITIVE_FEM:
        if let result = genitiveFemExceptions[numString]
        {
            return result
        }
        else
        {
            return changeEnding(numString, ending: "и")
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
        let minutesArray = Array(stringMinutes.characters)
        let ten = Int((String(minutesArray.first!) + "0"))!
        let one = Int(String(minutesArray.last!))!
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


public func verbaliseTime(time: TimeInstance) -> [String]
{
    var results = [String]()
    var textHour: String
    var textMinutes: String
    
    
    if time.minutes == 0
    {
        // improve later?
        if let hourString = verbalHourExceptions[time.hours]
        {
            textHour = hourString
        }
        else
        {
            textHour = verbalMinutes[time.hours]!
        }
    }
    else if time.minutes <= 30
    {
        if let hourString = possessiveNumsExceptions[time.nextHour]
        {
            textHour = hourString
        }
        else
        {
            textHour = changeEnding(verbalMinutes[time.nextHour]!, ending: "ого")
        }
    }
    else
    {
        if let hourString = verbalHourExceptions[time.nextHour]
        {
            textHour = hourString
        }
        else
        {
            textHour = verbalMinutes[time.nextHour]!
        }
    }
    
    // it's less than half past (but not the hour)
    if time.minutes < 30 && time.minutes != 0
    {
        if time.minutes == 15
        {
            results.append("четверть \(textHour)")
        }
        // change the case
        textMinutes = minutesToText(time.minutes)
        let minutesNoun = casify(minuteWord, num: time.minutes, nounCase: NOMINATIVE_FEM)
        results.append("\(textMinutes) \(minutesNoun!) \(textHour)")
    }
        
    // it's half past
    else if time.minutes == 30
    {
        results.append("пол\(textHour)")
        results.append("половина \(textHour)")
    }
        
    // it's over half past
    else if time.minutes > 30
    {
        let minutesLeft = 60 - time.minutes
        var casedTextMinutes = ""
        
        // special case for a quarter and short form
        if minutesLeft == 15
        {
            results.append("без четверти \(textHour)")
        }
        
        textMinutes = minutesToText(minutesLeft)
        let splitstring = split(textMinutes.characters, allowEmptySlices: false, isSeparator: {$0 == " "}).map { String($0) }
        
        // put the numeral of minutes in the correct (genitive) case
        for (n, word) in splitstring.enumerate()
        {
            var casedNum: String
            
            if let exception = genitiveFemExceptions[word]
            {
                casedNum = exception
            }
            else
            {
                casedNum = changeEnding(word, ending: "и")
            }
            
            casedTextMinutes += casedNum
            if n + 1 < splitstring.count
            {
                casedTextMinutes += " "
            }
        }
        
        // short form
        results.append("без \(casedTextMinutes) \(textHour)")
        
        // longer form
        let minutesNoun = casify(minuteWord, num: minutesLeft, nounCase: GENITIVE_FEM)!
        results.append("без \(casedTextMinutes) \(minutesNoun) \(textHour)")
    }
        
    // it's on the hour
    else
    {
        if time.hours == 1
        {
            results.append(textHour)
        }
        else
        {
            // short form
            results.append("\(textHour)")
            // longer form
            let hoursNoun = casify(hourWord, num: time.hours, nounCase: NOMINATIVE_MASC)!
            results.append("\(textHour) \(hoursNoun)")
        }
    }
    
    return results
}
