//
//  NSManagedObject+Finding.swift
//  Breeze
//
//  Created by André Lind on 2014-08-11.
//  Copyright (c) 2014 André Lind. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    public func inContextOfType(type: BreezeContextType) -> AnyObject? {
        if objectID.temporaryID {
            var error: NSError?
            if managedObjectContext.obtainPermanentIDsForObjects([self], error: &error) == false {
                println("Breeze - Unable to obtain permantent IDs for object: \(self). Error: \(error)")
                return nil
            }
        }
        
        return BreezeStore.contextForType(type).objectWithID(objectID)
    }
    
    public class func findFirst(attribute: String? = nil, value: AnyObject?, contextType: BreezeContextType = .Main) -> AnyObject? {
        let predicate = predicateForAttribute(attribute, value: value)
        return findFirst(predicate: predicate, contextType: contextType, sortedBy: nil, ascending: false)
    }
    
    public class func findFirst(predicate: NSPredicate? = nil, contextType: BreezeContextType = .Main, sortedBy: String? = nil, ascending: Bool = true) -> AnyObject? {
        let request = fetchRequest(predicate, sortedBy: sortedBy, ascending: ascending)
        request.fetchLimit = 1
        return BreezeStore.executeRequest(request, contextType: contextType).result.first
    }
    
    public class func findAll(attribute: String? = nil, value: AnyObject?, contextType: BreezeContextType = .Main) -> [AnyObject]! {
        let predicate = predicateForAttribute(attribute, value: value)
        return findAll(predicate: predicate, contextType: contextType, sortedBy: nil, ascending: false)
    }
    
    public class func findAll(predicate: NSPredicate? = nil, contextType: BreezeContextType = .Main, sortedBy: String? = nil, ascending: Bool = true) -> [AnyObject]! {
        let request = fetchRequest(predicate, sortedBy: sortedBy, ascending: ascending)
        return BreezeStore.executeRequest(request, contextType: contextType).result
    }
    
    public class func countAll(predicate: NSPredicate? = nil, contextType: BreezeContextType = .Main, sortedBy: String? = nil, ascending: Bool = true) -> Int {
        let request = fetchRequest(predicate, sortedBy: sortedBy, ascending: ascending)
        return BreezeStore.executeCountRequest(request, contextType: contextType).count
    }
    
    public class func fetchAll(predicate: NSPredicate? = nil, delegate: NSFetchedResultsControllerDelegate?, contextType: BreezeContextType = .Main, groupedBy: String? = nil, sortedBy: String? = nil, ascending: Bool = true) -> NSFetchedResultsController? {
        let request = fetchRequest(predicate, sortedBy: sortedBy, ascending: ascending)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: BreezeStore.contextForType(contextType), sectionNameKeyPath: groupedBy, cacheName: nil)
        fetchedResultsController.delegate = delegate
        
        var error: NSError?
        if fetchedResultsController.performFetch(&error) == false {
            println("Breeze - Error setting up NSFetchedResultsController \(fetchedResultsController). Error: \(error)")
            return nil
        }
        return fetchedResultsController
    }
    
    private class func predicateForAttribute(attribute: String?, value: AnyObject?) -> NSPredicate {
        return NSPredicate(format: "%K = %@", argumentArray: [attribute!, value!])
    }
    
    private class func fetchRequest(predicate: NSPredicate?, sortedBy: String? = nil, ascending: Bool = true) -> NSFetchRequest! {
        let fetchRequest = NSFetchRequest(entityName: NSStringFromClass(self))
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortedBy != nil ? [NSSortDescriptor(key: sortedBy, ascending: ascending)] : nil
        return fetchRequest
    }
}