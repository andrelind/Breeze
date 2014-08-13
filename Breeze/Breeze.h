//
//  Breeze.h
//  Breeze
//
//  Created by André Lind on 2014-08-10.
//  Copyright (c) 2014 André Lind. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for Breeze.
FOUNDATION_EXPORT double BreezeVersionNumber;

//! Project version string for Breeze.
FOUNDATION_EXPORT const unsigned char BreezeVersionString[];

typedef NS_ENUM(NSUInteger, BreezeContextType) {
    BreezeContextTypeMain,
    BreezeContextTypeBackground
};

#define BreezeCloudStoreWillReplaceLocalStore @"BreezeCloudStoreWillReplaceLocalStore"
#define BreezeCloudStoreDidReplaceLocalStore @"BreezeCloudStoreDidReplaceLocalStore"
