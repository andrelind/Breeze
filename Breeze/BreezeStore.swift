//
//  BreezeStore.swift
//  Breeze
//
//  Created by André Lind on 2014-08-10.
//  Copyright (c) 2014 André Lind. All rights reserved.
//

import UIKit
import CoreData

private var _breezeStore: BreezeStore!

public class BreezeStore: NSObject {
    public class func setupInMemoryStore() {
        setupStoreWithName("InMemoryStore", storeType: NSInMemoryStoreType, options: nil)
    }
    
    public class func setupDefaultStore() {
        setupStoreWithName("\(BreezeStore.appName).sqlite", storeType: NSSQLiteStoreType, options: nil)
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
    
    public class func executeRequest(request: NSFetchRequest, contextType: BreezeContextType) -> (result: [AnyObject]!, error: NSError?) {
        var error: NSError?
        let results = contextForType(contextType).executeFetchRequest(request, error: &error)
        
        if error != nil {
            println("Breeze - Error in fetch request: \(request). Error: \(error)")
        }
        
        return (result: results, error: error)
    }
    
    public class func executeCountRequest(request: NSFetchRequest, contextType: BreezeContextType) -> (count: Int, error: NSError?) {
        var error: NSError?
        let results = contextForType(contextType).countForFetchRequest(request, error: &error)
        
        if error != nil {
            println("Breeze - Error in fetch request: \(request). Error: \(error)")
        }
        
        return (count: results, error: error)
    }
    
    public class func tearDown() {
        NSNotificationCenter.defaultCenter().removeObserver(_breezeStore)
        _breezeStore = nil
    }
    
    
    /*
        Instance functions and variables
    */
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    private init(name: String, storeType: String, options: Dictionary<NSObject, AnyObject>?) {
        let model = NSManagedObjectModel.mergedModelFromBundles(nil)
        
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        backgroundContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        
        var error: NSError?
        let persistentStore = persistentStoreCoordinator.addPersistentStoreWithType(storeType, configuration: nil, URL: BreezeStore.URLToStoreWithFilename(name), options: options, error: &error)
        
        if error != nil || persistentStore == nil {
            println(error)
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
        moc.performBlockAndWait {
            if moc.hasChanges {
                var error: NSError?
                moc.save(&error)
                
                if error != nil {
                    println("Breeze - Error saving main context: \(error)")
                }
            }
            
            moc.reset()
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(BreezeCloudStoreWillReplaceLocalStore, object: nil)
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
