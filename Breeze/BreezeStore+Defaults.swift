//
//  BreezeStore+Defaults.swift
//  Breeze
//
//  Created by André Lind on 2014-08-10.
//  Copyright (c) 2014 André Lind. All rights reserved.
//

import Foundation

extension BreezeStore {
    class func appName() -> String {
        return NSBundle.mainBundle().infoDictionary["CFBundleDisplayName"]! as String
    }
    
    class func documentsDirectory() -> AnyObject? {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
    }
    
    public class func URLToStoreWithFilename(fileName: String) -> NSURL? {
        if let documentDir = documentsDirectory() as? String {
            return NSURL(fileURLWithPath: "\(documentDir)/\(fileName).sqlite")
        }
        return nil
    }
}