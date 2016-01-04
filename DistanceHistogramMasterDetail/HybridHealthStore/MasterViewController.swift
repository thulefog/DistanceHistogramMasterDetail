//
//  MasterViewController.swift
//  HybridHealthStore
//
//  Created by John Matthew Weston in January 2015, Swift updates in December 2015
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

import UIKit

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    
    var objects = [AnyObject]()

    var dataProvider: DataProvider<DistanceHistogram>!

    var sample: DistanceHistogram?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
        dataProvider = DataProvider();
        self.title = "Hybrid Health Store"
    }

    override func viewDidLoad() {
        
        //OPEN: threading issue around AutoLayout --> authenticateWithTouchID()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        /*
         * NB: pre Swift 2.x way, left in for now as reference
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            //self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
            
            self.detailViewController = (controllers[controllers.count-1] as? UINavigationController).topViewController
        }
        */
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        //actually - the entitlements appear to actually trap this so this logic may well be unnecessary...
        if ( UIDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad )
        {
            var message = "The User Interface Idiom of UIUserInterfaceIdiom.Pad does not have HealthKit, the HealthKit HealthStore will not be available";
            NSLog( message );

            var alert:UIAlertView = UIAlertView()
            alert.title = "HealthKitDataProvider"
            alert.message = message
            alert.delegate = self
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        
        HealthKitDataProvider.sharedInstance.requestHealthKitAuthorization()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        
        var timeIntervalInMonthsFromNow = 0;
        
        let alertController = UIAlertController(title: nil, message: "Select the time interval in Months for Distance histogram. Note that the calculations are based on Distance: Walking, Running samples from the Health Kit Store.", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
            print(action)
        }
        alertController.addAction(cancelAction)
        
        let oneMonthIntervalAction = UIAlertAction(title: "1 Month", style: .Default) { (action) in
            // ...
            print(action)
            timeIntervalInMonthsFromNow = 1
            
            self.generateChartSample(timeIntervalInMonthsFromNow)
            HealthKitDataProvider.sharedInstance.dispatchQueries( timeIntervalInMonthsFromNow,
                externalHandler: self.defaultExternalHandler)
        }
        alertController.addAction(oneMonthIntervalAction)

        let threeMonthIntervalAction = UIAlertAction(title: "3 Months", style: .Default) { (action) in
            // ...
            print(action)
            timeIntervalInMonthsFromNow = 3
            
            self.generateChartSample(timeIntervalInMonthsFromNow)
            HealthKitDataProvider.sharedInstance.dispatchQueries( timeIntervalInMonthsFromNow,
                externalHandler: self.defaultExternalHandler )
        }
        alertController.addAction(threeMonthIntervalAction)

        let sixMonthIntervalAction = UIAlertAction(title: "6 Months", style: .Default) { (action) in
            // ...
            print(action)
            timeIntervalInMonthsFromNow = 6
            
            self.generateChartSample(timeIntervalInMonthsFromNow)
            HealthKitDataProvider.sharedInstance.dispatchQueries( timeIntervalInMonthsFromNow,
                externalHandler: self.defaultExternalHandler )
        }
        alertController.addAction(sixMonthIntervalAction)

        let twelveMonthIntervalAction = UIAlertAction(title: "12 Months", style: .Default) { (action) in
            // ...
            print(action)
            timeIntervalInMonthsFromNow = 12
            
            self.generateChartSample(timeIntervalInMonthsFromNow)
            HealthKitDataProvider.sharedInstance.dispatchQueries( timeIntervalInMonthsFromNow,
                externalHandler: self.defaultExternalHandler )
        }
        alertController.addAction(twelveMonthIntervalAction)
        
        self.presentViewController(alertController, animated: true) {

        }
        //...
    }
    
    func defaultExternalHandler(key: String, value: Double ) -> String {
        self.sample?.dataPoints[key] = value;

        //this write should actually be an update, effectively
        let formatter = NSDateFormatter( )
        formatter.timeStyle = .FullStyle
        let dateTimeKey = formatter.stringFromDate( (self.sample?.dateTime)! )
        print( "dateTimeKey \(dateTimeKey)" )
        
        self.dataProvider.append( dateTimeKey, item: sample! )
        
        return "\(key) / \(value)"
    }
    
    func generateChartSample( timeInterval: Int )
    {
        let anchorDate = NSDate()
        self.sample = DistanceHistogram( id: 0, dateTime: anchorDate, timeInterval: timeInterval,
            description: "Distance: Walking, Running" + " [ \(timeInterval) ]", dataPoints: [String: Double]() )
        
        self.objects.insert(anchorDate, atIndex: 0)
        
        let formatter = NSDateFormatter( )
        formatter.timeStyle = .FullStyle
        let dateTimeKey = formatter.stringFromDate( anchorDate )
        print( "dateTimeKey \(dateTimeKey)" )
        
        self.dataProvider.append( dateTimeKey, item: sample! )

        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        log( "object (NSDate) \(dateTimeKey) indexPath \(indexPath) Histogram:Interval \(sample!.timeInterval) | Histogram:Description \(sample!.description)" )

        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func showUserAlert( title: NSString, message: NSString)
    {
        /* pre swift 2.x, ios 9.x code
        let alert:UIAlertView = UIAlertView()
        alert.title = title as String
        alert.message = message as String
        alert.delegate = self
        alert.addButtonWithTitle("OK")
        alert.show()
        */
        
        let alertController = UIAlertController(title: title as String, message: message as String, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "OK", style: .Default ) { (action) in }
        alertController.addAction(alertAction)
        self.presentViewController(alertController, animated: true, completion: nil )
        
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
 
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
  
                // TODO: Simplify:
                // - DataProvider key was Int/Id in previous iteration, shifted to key : <ElementType> Dictionary
                // - indexPath (tableView row location) Int but Key for histogram is NSDate

                let formatter = NSDateFormatter( )
                formatter.timeStyle = .FullStyle
                let dateTimeKey = formatter.stringFromDate( object )
                print( "dateTimeKey \(dateTimeKey)" )
                
                let histogram = self.dataProvider[ dateTimeKey ]

                log( "object (NSDate) \(object) indexPath.row \(indexPath.row) Histogram:Interval \(histogram.timeInterval) | Histogram:Description \(histogram.description)" )
                
                //controller.detailItem = object
                controller.detailItem = histogram
                
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 

        let object = objects[indexPath.row] as! NSDate
        cell.textLabel!.text = object.description
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}

