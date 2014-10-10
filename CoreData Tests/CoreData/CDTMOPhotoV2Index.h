//
//  CDTMOPhotoV2Index.h
//  CoreData Tests
//
//  Created by Alexandr Nikishin on 20/09/14.
//  Copyright (c) 2014 Alexansdf1der Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "CDTPhotoV2Interface.h"
#import "CDTMetaInterface.h"

@class CDTMOPhotoMetaIndex;

@interface CDTMOPhotoV2Index : NSManagedObject <CDTPhotoV2Interface>

@property (nonatomic, retain) NSString * assetURL;
@property (nonatomic, retain) NSManagedObject * meta;

@end
