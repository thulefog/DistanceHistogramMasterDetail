//
//  BiometricsProvider.swift
//
//  Created by John Matthew Weston in September 2015 with iterative improvements since.
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
import LocalAuthentication

import UIKit

protocol IBiometricsProvider
{
    func Authenticate() -> Bool
}

//OPEN: considered a dedicate class implementing IBiometricsProvider, taking simpler extension approach for now...
//moved away from UIViewController to UITableViewController for this Master-Detail split view application
extension UITableViewController  {
    
    func showAlertController(message: String) {
        dispatch_async(dispatch_get_main_queue(), {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    func authenticateWithTouchID() -> Bool {
        // create the Local Authentication context and working variables
        let context = LAContext()
        var error: NSError?
        var result: Bool
        result = false
        
        // check if Touch ID is available
        do {
            context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error)
            // if biometrics available, go ahead and authenticate with Touch ID
            let reason = "Authenticate with Touch ID"
            context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:
                {(success: Bool, error: NSError?) in
                    // in line with typical UX flow these days, raise alert to user to show pass/fail state
                    if success {
                        self.showAlertController("Touch ID Authentication Succeeded")
                        result = true
                    }
                    else {
                        self.showAlertController("Touch ID Authentication Failed")
                        result = false
                    }
            })
        } catch let error1 as NSError { //this probably means we are running in the simulator, let this slide and mask as passed
            error = error1
            showAlertController("Touch ID not available")
            result = true;
        }
        return result
    }
}