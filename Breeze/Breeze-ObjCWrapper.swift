//
//  Breeze+ObjCWrapper.swift
//  Breeze
//
//  Created by André Lind on 2014-08-11.
//  Copyright (c) 2014 André Lind. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    public class func bz_findAll() -> [AnyObject]! {
        return bz_findAllInContextType(BreezeContextType.Main)
    }
    
    public class func bz_findAllInContextType(contextType: BreezeContextType) -> [AnyObject]! {
        return bz_findAllWithPredicate(nil, contextType: contextType)
    }
    
    public class func bz_findAllWithPredicate(predicate: NSPredicate?, contextType:BreezeContextType) -> [AnyObject]! {
        return bz_findAllSortedBy(nil, ascending: true, predicate: predicate, contextType: contextType)
    }
    
    public class func bz_findAllSortedBy(sortedBy: String?, ascending: Bool, predicate: NSPredicate?, contextType: BreezeContextType) -> [AnyObject]! {
        return findAll(predicate: predicate, contextType: contextType, sortedBy: sortedBy, ascending: ascending)
    }
}