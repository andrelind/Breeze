//
//  BreezeStore.swift
//  Breeze
//
//  Created by André Lind on 2014-08-10.
//  Copyright (c) 2014 André Lind. All rights reserved.
//

import Foundation
import CoreData

public enum BreezeContextType {
    case Main
    case Background
}

let BreezeCloudStoreWillReplaceLocalStore = "BreezeCloudStoreWillReplaceLocalStore"
let BreezeCloudStoreDidReplaceLocalStore = "BreezeCloudStoreDidReplaceLocalStore"

private var _breezeStore: BreezeStore!

public class BreezeStore: NSObject {
    public class func setupInMemoryStore() {
        setupStoreWithName("InMemoryStore", storeType: NSInMemoryStoreType, options: nil)
    }
    
    public class func setupStoreWithName(name: String) {
        setupStoreWithName(name, storeType: NSSQLiteStoreType, options: nil)
    }
    
    public class func setupStoreWithName(name: String, storeType: String, options: Dictionary<NSObject, AnyObject>?) {
        if _breezeStore == nil {
            _breezeStore = BreezeStore(name: name, storeType: storeType, options: options)
        } else {
            println("Breeze - Store already setup!")
        }
    }
    
    public class func contextForType(type: BreezeContextType) -> NSManagedObjectContext {
        switch type {
        case .Main:
            return _breezeStore.mainContext
        case .Background:
            return _breezeStore.backgroundContext
        }
    }
    
    public class func executeRequest<T: NSManagedObject>(request: NSFetchRequest, context: NSManagedObjectContext) -> (result: [T], error: NSError?) {
        var error: NSError?
        if let results = context.executeFetchRequest(request, error: &error) {
            return (result: results as! [T], error: nil)
        } else {
            println("Breeze - Error in fetch request: \(request). Error: \(error!)")
            return (result: [], error: error)
        }
    }
    
    public class func executeCountRequest(request: NSFetchRequest, context: NSManagedObjectContext) -> (count: Int, error: NSError?) {
        var error: NSError?
        let results = context.countForFetchRequest(request, error: &error)
        
        if error != nil {
            println("Breeze - Error in fetch request: \(request). Error: \(error)")
        }
        
        return (count: results, error: error)
    }
    
    public class func tearDown() {
        NSNotificationCenter.defaultCenter().removeObserver(_breezeStore)
        _breezeStore = nil
    }
    
    // MARK: Instance functions and variables
    
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    private init(name: String, storeType: String, options: Dictionary<NSObject, AnyObject>?) {
        let model = NSManagedObjectModel.mergedModelFromBundles(nil)
        
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
        mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        backgroundContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        
        var error: NSError?
        let persistentStore = persistentStoreCoordinator.addPersistentStoreWithType(storeType,
            configuration: nil,
            URL: BreezeStore.URLToStoreWithFilename(name, useiCloud: options?[NSPersistentStoreUbiquitousContentNameKey] != nil),
            options: options,
            error: &error)
        
        if error != nil || persistentStore == nil {
            println("\(error)")
        }
        
        mainContext.persistentStoreCoordinator = persistentStoreCoordinator
        backgroundContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        super.init()
        
        registerNotifications()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contextDidSaveHandler:", name: NSManagedObjectContextDidSaveNotification, object: backgroundContext)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storesWillChangeHandler:", name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storesDidChangeHandler:", name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storesDidImportHandler:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: persistentStoreCoordinator)
    }
    
    func contextDidSaveHandler(notification: NSNotification) {
        mainContext.performBlock {
            self.mainContext.mergeChangesFromContextDidSaveNotification(notification)
        }
    }
    
    func storesWillChangeHandler(notification: NSNotification) {
        let moc = mainContext
        moc.performBlock {
            if moc.hasChanges {
                var error: NSError?
                moc.save(&error)
                
                if error != nil {
                    println("Breeze - Error saving main context: \(error)")
                }
            }
            
            moc.reset()
            NSNotificationCenter.defaultCenter().postNotificationName(BreezeCloudStoreWillReplaceLocalStore, object: nil)
        }
    }
    
    func storesDidChangeHandler(notification: NSNotification) {
        mainContext.performBlock {
            self.mainContext.mergeChangesFromContextDidSaveNotification(notification)
            NSNotificationCenter.defaultCenter().postNotificationName(BreezeCloudStoreDidReplaceLocalStore, object: nil)
            println("Breeze - Using iCloud store")
        }
    }
    
    func storesDidImportHandler(notification: NSNotification) {
        mainContext.performBlock {
            self.mainContext.mergeChangesFromContextDidSaveNotification(notification)
        }
    }
}
