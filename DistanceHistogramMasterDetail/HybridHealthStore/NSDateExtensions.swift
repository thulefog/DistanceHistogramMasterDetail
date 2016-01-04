//
//  NSDateExtensions.swift
//  HybridHealthStore
//
//  Created by John Matthew Weston in December 2015 for use around HK query date handling
//
//  Copyright © 2015 + 2016 John Matthew Weston. All rights reserved.
//
//  This code is licensed under the MIT License:
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

import Foundation


public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }

extension NSDate
{
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    
    func isLessThanDate(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending
        {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func addDays(daysToAdd : Int) -> NSDate
    {
        var secondsInDays : NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        var dateWithDaysAdded : NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    
    func addHours(hoursToAdd : Int) -> NSDate
    {
        var secondsInHours : NSTimeInterval = Double(hoursToAdd) * 60 * 60
        var dateWithHoursAdded : NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    
    func beginningOfDay() -> NSDate {
        let beginningOfDay = NSCalendar.currentCalendar().startOfDayForDate(self)
        return beginningOfDay
    }
    
    func endOfDay() -> NSDate {
        let components = NSDateComponents()
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endOfDay = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self, options: NSCalendarOptions(rawValue: 0))
        return endOfDay!
    }
    
    func oneWeekAgo() -> NSDate {
        let oneWeekAgo = NSDate(timeIntervalSinceNow: -7*24*60*60)
        return oneWeekAgo
    }
   
   /*
    func checkIfOnSameDate( referenceDate: NSDate, offsetDate: NSDate ) -> Bool
    {
    let todaysDate = NSDate()
    let calendar = NSCalendar.currentCalendar()
    var onSameDate = calendar.isDate(referenceDate, inSameDayAsDate: offsetDate)
    let formatter = NSDateComponentsFormatter()
    formatter.allowedUnits = [NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second]
    formatter.calendar = NSCalendar.currentCalendar()
    
    let interval = formatter.stringFromDate(referenceDate, toDate: offsetDate)
    print( "checkIfOnSameDate \(interval) / onSameDate \(onSameDate)" )
    
    return onSameDate
    }
    */
}
