//
//  NSManagedObject+Creating.swift
//  Breeze
//
//  Created by André Lind on 2014-08-11.
//  Copyright (c) 2014 André Lind. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    public class func createInContextOfType(type: BreezeContextType) -> AnyObject {
        return createInContext(BreezeStore.contextForType(type))
    }
    
    public class func createInContext(context: NSManagedObjectContext) -> AnyObject {
        return NSEntityDescription.insertNewObjectForEntityForName(NSStringFromClass(self), inManagedObjectContext: context) as! NSManagedObject
    }
}
