//
//  CDTPhotoV2Interface.h
//  CoreData Tests
//
//  Created by Alexandr Nikishin on 20/09/14.
//  Copyright (c) 2014 Alexansdf1der Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CDTMetaInterface.h"

@protocol CDTPhotoV2Interface <NSObject>

@property (nonatomic, retain) NSString * assetURL;
@property (nonatomic, retain) NSManagedObject * meta;

@end
