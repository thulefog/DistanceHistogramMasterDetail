//
//  DetailViewController.swift
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
import Charts

class DetailViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
  
    @IBOutlet weak var lineChartView: LineChartView!
 
    let weekdays = [ "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" ]

    var detailItem: DistanceHistogram? {
        didSet {
            // Update the view.
            if isViewLoaded() {
                self.configureView()
            }
        }
    }
    func configureView() {
        // Update the user interface for the detail item.
        if let metadata: DistanceHistogram = self.detailItem {
            if let label = self.detailDescriptionLabel {
                detailDescriptionLabel.text = metadata.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        self.lineChartView.delegate = self
        // 2
        self.lineChartView.descriptionText = (detailItem?.description!)!//"Tap node for details" // 
        // 3
        self.lineChartView.descriptionTextColor = UIColor.whiteColor()
        self.lineChartView.gridBackgroundColor = UIColor.darkGrayColor()
        // 4
        self.lineChartView.noDataText = "No data provided"
        
        self.lineChartView.setVisibleXRangeMaximum( 7 )
        // 5
        setChartData(weekdays)
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func setChartData(weekdays : [String]) {
        // 1 - creating an array of data entries
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        //NB: could be a dictionary or other unified collection to ensure x+y in synch

        for var i = 0; i < weekdays.count; i++ {
            yVals1.append(ChartDataEntry(value: (detailItem?.dataPoints[weekdays[i]])!, xIndex: i))
        }
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(yVals: yVals1, label: "Total Distance [miles] vs Weekday")
        set1.axisDependency = .Left // Line will correlate with left axis values
        set1.setColor(UIColor.redColor().colorWithAlphaComponent(0.5)) // our line's opacity is 50%
        set1.setCircleColor(UIColor.redColor()) // our circle will be dark red
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.redColor()
        set1.highlightColor = UIColor.whiteColor()
        set1.drawCircleHoleEnabled = true
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)

        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(xVals: weekdays, dataSets: dataSets)
        data.setValueTextColor(UIColor.whiteColor())

        //5 - finally set our data
        self.lineChartView.data = data            
    }

}

