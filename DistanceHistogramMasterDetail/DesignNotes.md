# Design Notes

## Distance Histogram - Master Detail

This application is based on the original Master Detail application seed of a "Hybrid Health Store".

The use case is the user is interested in generating a histogram of their step count or Distance Walking/Running samples stored in the iOS Health Store and available by way of the HealthKit API. The Distance Walking/Running settled out as a more intuitive measure of activity in the first spike or iteration of this app.

The overall flow is as below:

- application starts
- from Master list user can add a sample (+ in upper right corner)
- the user is asked for a time interval in months from the following values: 1, 3, 6, 12 and adding a sample causes a sequence of events below
- the passed in value for time interval in months is converted to an NSDate relative to today's date. This could be generalized later to define the specific start and end NSDate time interval.
- call to HealthKitProvider generates HKStatisticsCollectionQuery for the NSDate range
- the HKStatisticsCollectionQuery results are iteratively processes generating a histogram for total walk/run distance as function of Weekday. This could be generalized later to define different bins for the data samples.
- the histogram is communicated back by way of a Distance Histogram data structure which contains the array of data and some additional descriptive metadata.
- when the line item selected in Master list, the corresponding data structure is used to render a simple line plot for the histogram. This is a "Line Chart" using the open source library ios-charts.

## Design Inventory

- Master Detail approach as a user interaction experiment
- HealthKit with Health Kit Provider layer to coordinate data queries
- Data Provider to provide a very rough local store
- Data plots rendered using ios-charts: https://github.com/danielgindi/ios-charts.git
- Biometrics Provider to provide Touch ID, removed temporarily due to minor defect with threading issue around Auto Layout

NB: Although it is not a goal of this project to be portable to Android, interestingly - the chart API for ios-charts is by design intended to be symmetric with MPAndroidChart
https://github.com/PhilJay/MPAndroidChart

## Next Steps

- Revise or, more likely, replace the current Master Detail approach
- Instead of primitive Action sheet based selection of plot variant - auto generate a batch of plots and display using Stack View. Related - provide flexibility to select NSDates - to and from.
- Refactor and streamline Data Provider data store and interface
- Refactor the "external data handler" away from the Master view controller to a more natural place for the distilled data capture from HK query
- Generate a text readable representation of the HealthKit samples in JSON format, and potentially even save and export the rendered data plot as a JPEG or PNG image.
- Encrypt local data stored by application as well as exported data.



This is rough works-in-progress code and there are some minor indexing issues with the interaction between the UI and the simple store. Will experiment with Stack View of multiple charts in batch to simplify user steps (no Action sheet required) and address issues in next iterations.

## Integration Issues
Solved or in progress...

- xcode : Target > General > Embedded Binaries

~~~
dyld: Library not loaded: @rpath/Charts.framework/Charts
  Referenced from: /var/mobile/Containers/Bundle/Application/A1EE0BC7-75A7-46D4-B42F-840F108D1492/HybridHealthStore.app/HybridHealthStore
  Reason: image not found
~~~


Issue with alert controller in pathway where Touch ID is confirmed.

~~~
2015-12-29 10:01:21.394 HybridHealthStore[9909:272653] This application is modifying the autolayout engine from a background thread, which can lead to engine corruption and weird crashes.  This will cause an exception in a future release.
 Stack:(
	0   CoreFoundation                      0x00000001838ed918 <redacted> + 148
	1   libobjc.A.dylib                     0x0000000182f5bf80 objc_exception_throw + 56
	2   CoreFoundation                      0x00000001838ed848 <redacted> + 0
	3   Foundation                          0x000000018438b2d4 <redacted> + 88
	4   Foundation                          0x000000018421199c <redacted> + 56
	5   Foundation                          0x000000018420d55c <redacted> + 260
	6   UIKit                               0x0000000188e4d800 <redacted> + 992
	7   UIKit                               0x0000000188e4ed28 <redacted> + 788
	8   UIKit                               0x0000000188e4e95c <redacted> + 296
	9   UIKit                               0x0000000188f1e7ac <redacted> + 480
	10  UIKit                               0x0000000188f1b774 <redacted> + 172
	11  UIKit                               0x0000000188f1b9e4 <redacted> + 96
	12  UIKit                               0x0000000188f1bea8 <redacted> + 80
	13  UIKit                               0x0000000188f2043c <redacted> + 492
	14  UIKit                               0x0000000188f1f5a8 <redacted> + 148
	15  UIKit                               0x0000000188f1f4e8 <redacted> + 284
	16  UIKit                               0x0000000188a48cc4 <redacted> + 444
	17  UIKit                               0x0000000188a48d98 <redacted> + 60
	18  UIKit                               0x0000000188a48ed8 <redacted> + 28
	19  UIKit                               0x0000000188a48488 <redacted> + 100
	20  UIKit                               0x00000001885e00c0 <redacted> + 996
	21  UIKit                               0x00000001885dfcc4 <redacted> + 28
	22  UIKit                               0x0000000188962344 <redacted> + 108
	23  UIKit                               0x000000018895b4c4 <redacted> + 1328
	24  UIKit                               0x000000018895cf84 <redacted> + 4644
	25  UIKit                               0x000000018895f9c0 <redacted> + 472
	26  UIKit                               0x00000001886d9cec <redacted> + 184
	27  HybridHealthStore                   0x000000010001c620 _TFE17HybridHealthStoreCSo21UITableViewController19showAlertControllerfS0_FSST_ + 680
	28  HybridHealthStore                   0x000000010001c780 _TToFE17HybridHealthStoreCSo21UITableViewController19showAlertControllerfS0_FSST_ + 72
	29  HybridHealthStore                   0x000000010001d1d0 _TFFE17HybridHealthStoreCSo21UITableViewController23authenticateWithTouchIDFS0_FT_SbU_FTSbGSqCSo7NSError__T_ + 120
	30  HybridHealthStore                   0x000000010001669c _TTRXFo_dSboGSqCSo7NSError__dT__XFdCb_dSbdGSqS___dT__ + 72
	31  LocalAuthentication                 0x000000018e2d70a8 <redacted> + 72
	32  LocalAuthentication                 0x000000018e2d6a64 <redacted> + 256
	33  LocalAuthentication                 0x000000018e2d3f18 <redacted> + 324
	34  LocalAuthentication                 0x000000018e2d359c <redacted> + 128
	35  CoreFoundation                      0x00000001838f3430 <redacted> + 144
	36  CoreFoundation                      0x00000001837f0eb4 <redacted> + 284
	37  Foundation                          0x0000000184395b48 <redacted> + 20
	38  Foundation                          0x000000018439593c <redacted> + 796
	39  Foundation                          0x00000001843979c4 <redacted> + 292
	40  libxpc.dylib                        0x0000000183588c28 <redacted> + 28
	41  libxpc.dylib                        0x0000000183588bcc <redacted> + 40
	42  libdispatch.dylib                   0x00000001014f9bb0 _dispatch_client_callout + 16
	43  libdispatch.dylib                   0x00000001015066c8 _dispatch_queue_drain + 1036
	44  libdispatch.dylib                   0x00000001014fd8a0 _dispatch_queue_invoke + 464
	45  libdispatch.dylib                   0x00000001014f9bb0 _dispatch_client_callout + 16
	46  libdispatch.dylib                   0x0000000101508e10 _dispatch_root_queue_drain + 2344
	47  libdispatch.dylib                   0x00000001015084d8 _dispatch_worker_thread3 + 132
	48  libsystem_pthread.dylib             0x0000000183555470 _pthread_wqthread + 1092
	49  libsystem_pthread.dylib             0x0000000183555020 start_wqthread + 4
)
~~~


# Related:
http://www.raywenderlich.com/90693/modern-core-graphics-with-swift-part-2
http://www.appcoda.com/ios-charts-api-tutorial/
https://www.codebeaulieu.com/57/How-to-create-a-Line-Chart-using-ios-charts

http://nshipster.com/uialertcontroller/
https://www.hackingwithswift.com
https://github.com/shinobicontrols/iOS9-day-by-day
