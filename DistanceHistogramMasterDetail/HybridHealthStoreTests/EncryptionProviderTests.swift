//
//  EncryptionProviderTests.swift
//  HybridHealthStoreTests
//
//  Created by John Matthew Weston in January 2015, Swift updates in December 2015
//  Source Code - Copyright © 2015 John Matthew Weston but published as open source under MIT License.
//
import UIKit
import XCTest

//import EncryptionProviderWorkbench

class EncryptionProviderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    /*
    func testEncryptDecryptDateString() {
        
        var crypt = EncryptionProvider()
        var value = NSDate()
        
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        var dateAsString = dateFormatter.stringFromDate(value)
        var encryptedData: NSData = crypt.encryptStringData(dateAsString)
        print( "to encrypt \(encryptedData) " )
        var decryptedData: String = crypt.decryptStringData(encryptedData)
        print( "decrypted raw \(decryptedData)" )
        
        var dataAsString = NSString(data: encryptedData, encoding: NSUTF8StringEncoding)
        
        //showUserAlert( dataAsString!, message: decryptedData)
        //--------------
        print( "decrypted string \(dataAsString)" )
        
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testEncryptURLStream()
    {
        var crypt = EncryptionProvider()
        
        var folderPath = "/Users/TheChief/Code/DataCache/PostProcessed"
        let fileManager = NSFileManager.defaultManager()
        let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(folderPath)!
        
        var index = 0;
        while let element = enumerator.nextObject() as? String {
       
            if element.hasSuffix("png") || element.hasSuffix("jpg") { // checks the extension
                print( "Image file found: \(element) " )
        
                var fullPath = "\(folderPath)/\(element)";
                var url = NSURL(fileURLWithPath: fullPath )
        
                NSLog( "Encrypting file \(fullPath)")
                
                var fileData = NSData( contentsOfFile: fullPath )
                crypt.encryptFileData( fileData! )
                
                var encryptedStreamData: NSData = crypt.encryptURLStreamData( url! )
                
                NSLog( "Writing encrypted file...")
                encryptedStreamData.writeToFile("folderPath\(element).encrypted.stream", atomically: true)
                
                //escape clause
                break;
        
                //https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSData_Class/#//apple_ref/occ/instm/NSData/writeToFile:atomically:
                //...
                //...var image = UIImage(byReferencingURL: url!)
                //...just want to bounce out after one file
                index = index+1
            }
        }
    }
    func testEncryptFileDirectory()
    {
        var crypt = EncryptionProvider()
        
        var folderPath = "/Users/TheChief/Code/DataCache/PostProcessed"
        let fileManager = NSFileManager.defaultManager()
        let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(folderPath)!
        
        var index = 0;
        while let element = enumerator.nextObject() as? String {
            
            if element.hasSuffix("png") || element.hasSuffix("jpg") { // checks the extension
                print( "Image file found: \(element) " )
                
                var fullPath = "\(folderPath)/\(element)";
                var url = NSURL(fileURLWithPath: fullPath )
                
                NSLog( "Encrypting file \(fullPath)")
                
                var fileData = NSData( contentsOfFile: fullPath )
                var encryptedData = NSData(  data: crypt.encryptFileData( fileData! ))
                    
                
                var encryptedFileName = "\(folderPath)/\(element).encrypted"
                NSLog( "Writing encrypted file: %@", encryptedFileName )
                encryptedData.writeToFile(encryptedFileName, atomically: true)

                var decryptedData = NSData( data: crypt.decryptFileData( encryptedData ) )
                
                var decryptedFileName = "\(folderPath)/\(element).decrypted"
                NSLog( "Writing decrypted file: %@", decryptedFileName)
                decryptedData.writeToFile( decryptedFileName, atomically: true)
                
                break;
                
                //https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSData_Class/#//apple_ref/occ/instm/NSData/writeToFile:atomically:
                //...
                //...var image = UIImage(byReferencingURL: url!)
                //...just want to bounce out after one file
                index = index+1
            }
        }
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    */
}
