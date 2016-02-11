# Breeze

Lightweight CoreData manager written in Swift

Breeze takes a lot of cues from both [MagicalRecord](https://github.com/magicalpanda/MagicalRecord) and [Nimble](https://github.com/MarcoSero/Nimble)

* Lightweight and simple to setup and use
* 1 row of code to find first/any object in database
* iCloud support
* Simple architecture using only a main and a background context.

## Install

Install using CocoaPods

    pod "Breeze"

Then import <Breeze.h/Breeze.h> into your .pch file

__Right now Swift does not work with CocoaPods, so download the files and include them manually... :-(__

## Setup

First, setup either a local or a iCloud store

    if BreezeStore.iCloudAvailable() {
        BreezeStore.setupiCloudStoreWithContentNameKey("iCloudTestContentName", localStoreName: "iCloudTest", transactionLogs: "iCloud_transactions_logs")
    } else {
        BreezeStore.setupStoreWithName("Test", type: NSSQLiteStoreType, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
    }

## Saving

    BreezeStore.saveInBackground { contextType -> Void in
        let car = Car.createInContextOfType(contextType)
        car.color = UIColor.blueColor()
    }

## Finding

Find single objects by attribute

    let car = Car.findFirst(attribute: "myAttribute", value: 1, contextType: BreezeContextType.Main)

or by predicate

    let car = Car.findFirst(predicate: myPredicate, sortedBy: "anotherAttribute", ascending: false, contextType: BreezeContextType.Main)


Likewise, find all objects by attribute

    let cars = Car.findAll(attribute: "myAttribute", value: 1, contextType: BreezeContextType.Main)

or by predicate

    let cars = Car.findAll(predicate: myPredicate, sortedBy: "anotherAttribute", ascending: false, contextType: BreezeContextType.Main)

## Counting

If you just need to count the objects of a query, use the countAll function

    let carCount = Car.countAll(predicate: myPredicate, sortedBy: "anotherAttribute", ascending: false, contextType: BreezeContextType.Main)

## License

Breeze is available under the MIT license. See the file LICENSE.
