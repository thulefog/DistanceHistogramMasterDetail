//
//  HealthKitDataProvider
//  HybridHealthStore
//
//  Created by John Matthew Weston in January 2015, updated to Swift 2.x in December 2015 and added types and queries
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

import HealthKit
import UIKit


class HealthKitDataProvider {
    
    class var sharedInstance: HealthKitDataProvider {
        struct Singleton {
            static let instance = HealthKitDataProvider()
        }
        
        return Singleton.instance
    }
    
    let healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        } else {
            return nil
        }
    }()

    func requestHealthKitAuthorization() {
        
        let writeDataTypes: Set<HKSampleType> = self.dataTypesToWrite()
        let readDataTypes: Set<HKObjectType> = self.dataTypesToRead()

        let completion: ((Bool, NSError?) -> Void)! = {
            (success, error) -> Void in
            
            if !success {
                print("You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: \(error). If you're using a simulator, try it on a device.")
                
                return
            }
            
        }
        
        self.healthStore?.requestAuthorizationToShareTypes(writeDataTypes,
            readTypes: readDataTypes,  completion: { (success, error) -> Void in
                if success {
                    print("Type share authorization: success")
                } else {
                    print(error!.description)
                }
        })
    }
    
    func dispatchQueries( retrospectiveTimeIntervalInMonthsFromNow: Int,
        externalHandler: (String, Double) -> String )
    {
        
        dispatch_async(dispatch_get_main_queue(), {
            () -> Void in
                        
            let endDate = NSDate()
            let startDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Month,
                value: (-1 * retrospectiveTimeIntervalInMonthsFromNow), toDate: endDate, options: [])
            
            //NB: other fetch methods are HKSampleQuery and not HKStatisticsCollectionQuery
            //removed; the distance measurements provide a more direct metric
            //--> self.fetchStepCountsIntoWeekdayHistogram( endDate, startDate: startDate! )
            self.fetchWalkRunDistanceIntoWeekdayHistogram( endDate, startDate: startDate!, externalHandler: externalHandler )
            
        })
    }

    private func dataTypesToWrite() -> Set<HKSampleType>
    {
        let dietaryCalorieEnergyType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed)!
        let activeEnergyBurnType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!
        let heightType:  HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!
        let weightType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!
        
        let writeDataTypes: Set<HKSampleType> = [dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType]
        
        return writeDataTypes
    }
    
    private func dataTypesToRead() -> Set<HKObjectType>
    {
        let birthdayType: HKCharacteristicType = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!
        let biologicalSexType: HKCharacteristicType = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!
        let heightType:  HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!
        let weightType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!

        let dietaryCalorieEnergyType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed)!
        let activeEnergyBurnType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!
        let distanceWalkRun: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!
        let stepCount: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!
        let heartRate: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
        
        let readDataTypes: Set<HKObjectType> = [ birthdayType, biologicalSexType, heightType, weightType, dietaryCalorieEnergyType, activeEnergyBurnType, distanceWalkRun, stepCount, heartRate ]
        
        return readDataTypes
    }
    
    func fetchHeartRates(endTime: NSDate, startDate: NSDate){
        let sampleType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endTime, options: HKQueryOptions.None)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType!, predicate: predicate, limit: 100, sortDescriptors: [sortDescriptor])
            { (query, results, error) in
                if error != nil {
                    print("An error has occured with the following description: \(error!.localizedDescription)")
                } else {
                    for r in results!{
                        let result = r as! HKQuantitySample
                        let quantity = result.quantity
                        let count = quantity.doubleValueForUnit(HKUnit(fromString: "count/min"))
                        print("sample: \(count) : HR: \(result)")
                    }
                }
        }
        self.healthStore?.executeQuery(query)
    }
    
    func fetchStepCounts( endTime: NSDate, startDate: NSDate )
    {
        let endDate = NSDate()
        let startDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Month, value: -6, toDate: endDate, options: [])

        let stepSampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .None)
        
        let query = HKSampleQuery(sampleType: stepSampleType!, predicate: predicate, limit: 0, sortDescriptors: nil, resultsHandler: {
            (query, results, error) in
            if results == nil {
                print("There was an error running the query: \(error)")
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                for r in results!{
                    let result = r as! HKQuantitySample
                    let quantity = result.quantity
                    let count = quantity.doubleValueForUnit(HKUnit.countUnit())
                    print("sample: \(count) : step \(result)")
                }
            }
        })
        
        self.healthStore?.executeQuery(query)
    }
  
    func fetchStepCountsIntoWeekdayHistogram( endDate: NSDate, startDate: NSDate )
    {
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)

        let interval = NSDateComponents()
        interval.day = 1
        
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: NSDate(), options: .StrictStartDate)
        let query = HKStatisticsCollectionQuery(quantityType: type!, quantitySamplePredicate: predicate, options: [.CumulativeSum], anchorDate: NSDate().beginningOfDay(), intervalComponents:interval)
        
        var weekDayStepCountHistogram = [String: Double]()
        
        query.initialResultsHandler = { query, results, error in

            if let myResults = results{
                myResults.enumerateStatisticsFromDate(startDate, toDate: endDate) {
                    statistics, stop in
                    
                    if let quantity = statistics.sumQuantity() {
                        
                        let date = statistics.startDate
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "EEEE"
                        let dayOfWeekFormatted = dateFormatter.stringFromDate(date)
                        let steps = quantity.doubleValueForUnit(HKUnit.countUnit())
                        
                        if( !weekDayStepCountHistogram.isEmpty && weekDayStepCountHistogram[dayOfWeekFormatted] != nil )
                        {
                            let currentValue = weekDayStepCountHistogram[dayOfWeekFormatted]
                            let newValue = currentValue! + steps
                            weekDayStepCountHistogram.updateValue( newValue, forKey: dayOfWeekFormatted)
                        }
                        else
                        {
                            weekDayStepCountHistogram[dayOfWeekFormatted] = steps
                        }
                        //print("\(date) |\(dayOfWeekFormatted)| steps |\(steps)|")
                    }
                }
                
                //
                for (weekday, histogramValue) in weekDayStepCountHistogram {
                    print("WEEKDAY |\(weekday)| STEP HISTOGRAM |\(histogramValue)|")
                }
            }
        }
        
        self.healthStore?.executeQuery(query)
    }
    
    
    func fetchWalkRunDistanceIntoWeekdayHistogram( endDate: NSDate, startDate: NSDate,
        externalHandler: (String, Double) -> String )
    {
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
        
        let interval = NSDateComponents()
        interval.day = 1
        
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: NSDate(), options: .StrictStartDate)
        let query = HKStatisticsCollectionQuery(quantityType: type!, quantitySamplePredicate: predicate, options: [.CumulativeSum], anchorDate: NSDate().beginningOfDay(), intervalComponents:interval)
        
        var weekDayDistanceHistogram = [String: Double]()
        
        query.initialResultsHandler = { query, results, error in
            if let myResults = results{
                myResults.enumerateStatisticsFromDate(startDate, toDate: endDate) {
                    statistics, stop in
                    
                    if let quantity = statistics.sumQuantity() {
                        
                        let date = statistics.startDate
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "EEEE"
                        let dayOfWeekFormatted = dateFormatter.stringFromDate(date)
                        let distance = quantity.doubleValueForUnit(HKUnit.mileUnit())
                        
                        if( !weekDayDistanceHistogram.isEmpty && weekDayDistanceHistogram[dayOfWeekFormatted] != nil )
                        {
                            let currentValue = weekDayDistanceHistogram[dayOfWeekFormatted]
                            let newValue = currentValue! + distance
                            weekDayDistanceHistogram.updateValue( newValue, forKey: dayOfWeekFormatted)
                        }
                        else
                        {
                            weekDayDistanceHistogram[dayOfWeekFormatted] = distance
                        }
                        //print("\(date) |\(dayOfWeekFormatted)| distance |\(distance)|")
                        
                        //
                    }
                }
                //
                for (weekday, histogramValue) in weekDayDistanceHistogram {
                    print("WEEKDAY |\(weekday)| DISTANCE HISTOGRAM |\(histogramValue)|")
                    var callback = externalHandler( weekday, histogramValue )
                    print("handler: \(callback)")
                }
            }
        }
        
        self.healthStore?.executeQuery(query)
    }
    
    func fetchWeightSamples() {
        let endDate = NSDate()
        let startDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Month,
            value: -2, toDate: endDate, options: [])
        
        let weightSampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate,
            endDate: endDate, options: .None)
        
        let query = HKSampleQuery(sampleType: weightSampleType!, predicate: predicate,
            limit: 0, sortDescriptors: nil, resultsHandler: {
                (query, results, error) in
                if results == nil {
                    print("There was an error running the query: \(error)")
                }
                dispatch_async(dispatch_get_main_queue()) {
                    
                    for r in results!{
                        let result = r as! HKQuantitySample
                        let quantity = result.quantity
                        print("sample: \(quantity) : weight \(result)")
                    }

                }
        })
        self.healthStore?.executeQuery(query)
    }
}


