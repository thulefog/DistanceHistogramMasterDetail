//
//  DataProvider.swift
//
//  Created by John Matthew Weston in February 2015, revised December 2015.
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


class DataProvider<Element>: IContainer, IDataProvider {
  
    
    var keyValueStore = [String: Element]()

//    var items = [Element]()
    var json: JSON!
    var elementCount: Int!
    var hydrated: Bool!
    
    var ElementCount:Int {
        return keyValueStore.count
    }
    

    init() {

        //Populate()
    }

    var Hydrated:Bool {
        return hydrated;
    }
    
    //NB: deprecated for now - not a static store for this Master-Detail iteration; revisit.
    func Populate() -> Bool
    {
        elementCount = 0

        if let file = NSBundle(forClass:AppDelegate.self).pathForResource("SimpleStore", ofType: "json") {
            let data = NSData(contentsOfFile: file)!
            
            json = JSON(data:data)
            
            for (_, _): (String, JSON) in json {
                log( "index \(index) " )
            }
            
            //traverse the data set and log to sanity check
            for (index, subJson): (String, JSON) in json["SimpleStore"] {
                let instance = subJson["Instance"].string;
                let description = subJson["Description"].string;
                log( "index \(index) Instance \(instance) | Description \(description)" )
                elementCount!++
            }
            //test: instance zero
            log( "instance \(json["SimpleStore"][0]["Instance"]) ")
            
        }
        hydrated = true
        return hydrated
    }
    
    func push(key: String, item: Element) {
        
        if( !keyValueStore.isEmpty && keyValueStore[key] != nil )
        {
            keyValueStore.updateValue(item, forKey: key)
        }
        else
        {
            keyValueStore[key] = item
        }

    }
/* - removed for now; re-think pop method due to shift to key-value collection
    func pop() -> Element {
        //effectively this -> keyValueStore.reverse().popFirst()
        return...
    }
*/
    func append(key: String, item: Element) {
        
        if( !keyValueStore.isEmpty && keyValueStore[key] != nil )
        {
            keyValueStore.updateValue(item, forKey: key)
        }
        else
        {
            keyValueStore[key] = item
        }
    }
    func remove(key: String)
    {
        keyValueStore.removeValueForKey( key )
    }
    var count: Int {
        return keyValueStore.count
    }
    subscript(key: String) -> Element {
        return keyValueStore[key]!
    }
}