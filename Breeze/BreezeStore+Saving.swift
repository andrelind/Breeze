//
//  BreezeStore+Saving.swift
//  Breeze
//
//  Created by André Lind on 2014-08-11.
//  Copyright (c) 2014 André Lind. All rights reserved.
//

import Foundation

public typealias BreezeSaveBlock = (BreezeContextType) -> Void
public typealias BreezeErrorBlock = (NSError?) -> Void

extension BreezeStore {
    public class func saveInMain(changes: BreezeSaveBlock) {
//        assert(changes != nil, "Invalid changes")
        let moc = BreezeStore.contextForType(.Main)
        moc.performBlock {
            changes!(.Main)

            var error: NSError?
            moc.save(&error)

            if error != nil {
                println("Breeze - Error saving main context: \(error)")
            }
        }
    }

    public class func saveInMainWaiting(changes: BreezeSaveBlock) {
//        assert(changes != nil, "Invalid changes")
        let moc = BreezeStore.contextForType(.Main)
        moc.performBlockAndWait { () -> Void in
            changes!(.Main)

            var error: NSError?
            moc.save(&error)

            if error != nil {
                println("Breeze - Error saving main context: \(error)")
            }
        }
    }

    public class func saveInBackground(changes: BreezeSaveBlock) {
        saveInBackground(changes, completion: nil)
    }

    public class func saveInBackground(changes: BreezeSaveBlock, completion: BreezeErrorBlock?) {
//        assert(changes != nil, "Invalid changes")    
        let moc = BreezeStore.contextForType(.Background)
        moc.performBlock { () -> Void in
            changes!(.Background)

            var error: NSError?
            moc.save(&error)

            if error != nil {
                println("Breeze - Error saving background context: \(error)")
            }

            if completion != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    completion!(error)
                }
            }
        }
    }
}
