//
//  BreezeTests.swift
//  BreezeTests
//
//  Created by André Lind on 2014-08-10.
//  Copyright (c) 2014 André Lind. All rights reserved.
//

import UIKit
import XCTest
import Breeze
import CoreData

class BreezeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        BreezeStore.tearDown()
        
        super.tearDown()
    }
    
    func testStore() {
        let expectation = expectationWithDescription("Wait for setup")
        
        BreezeStore.setupStoreWithName("Test", type: NSSQLiteStoreType, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
        
        BreezeStore.saveInBackground { contextType -> Void in
        
            
           NSManagedObject.findAll(predicate: NSPredicate(format: "%K = %@", argumentArray: ["myAttribute","myValue"]), contextType: BreezeContextType.Main, sortedBy: "anotherAttribute", ascending: false)
        }
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(5) * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue(), {
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testiCloudStore() {
        let expectation = expectationWithDescription("Wait for setup")
        
        BreezeStore.setupiCloudStoreWithContentNameKey("iCloudTestContentName", localStoreName: "iCloudTest", transactionLogs: "transactions_logs")

        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(5) * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue(), {
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }

    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
