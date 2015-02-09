//
//  BreezeStore+iCloud.swift
//  Breeze
//
//  Created by André Lind on 2014-08-10.
//  Copyright (c) 2014 André Lind. All rights reserved.
//

import Foundation
import CoreData

extension BreezeStore {
    public class func iCloudAvailable() -> Bool {
        return NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil) != nil
    }
    
    public class func setupiCloudStoreWithContentNameKey(key: String, localStoreName: String, transactionLogs: String) {
        if let ubiquityURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil) {            
            let iCloudOptions: Dictionary<NSObject, AnyObject> = [
                NSPersistentStoreUbiquitousContentNameKey: key,
                NSPersistentStoreUbiquitousContentURLKey: transactionLogs,
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            setupStoreWithName(localStoreName, storeType: NSSQLiteStoreType, options: iCloudOptions)

        } else {
            println("Breeze - iCloud not available, using local store instead")
            setupStoreWithName(localStoreName)
        }
        
    }
}