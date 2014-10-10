//
//  CDTMOPhotoV2.h
//  CoreData Tests
//
//  Created by Alexandr Nikishin on 14/09/14.
//  Copyright (c) 2014 Alexansdf1der Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CDTMOPhotoMeta.h"

#import "CDTPhotoV2Interface.h"

@interface CDTMOPhotoV2 : NSManagedObject <CDTPhotoV2Interface>

@property (nonatomic, retain) NSString * assetURL;
@property (nonatomic, retain) NSManagedObject * meta;

@end
