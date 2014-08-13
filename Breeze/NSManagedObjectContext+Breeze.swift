//
//  NSManagedObjectContext+Breeze.swift
//  Breeze
//
//  Created by André Lind on 2014-08-11.
//  Copyright (c) 2014 André Lind. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    public class func mainContext() -> NSManagedObjectContext {
        return BreezeStore.contextForType(.Main)
    }
    
    public class func backgroundContext() -> NSManagedObjectContext {
        return BreezeStore.contextForType(.Background)
    }
    
    public class func contextForCurrentThread() -> NSManagedObjectContext {
        if NSThread.isMainThread() {
            return mainContext()
        }
        return backgroundContext()
    }
}