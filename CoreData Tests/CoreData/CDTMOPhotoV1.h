//
//  CDTMOPhotoV1.h
//  CoreData Tests
//
//  Created by Alexandr Nikishin on 14/09/14.
//  Copyright (c) 2014 Alexansdf1der Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CDTPhotoV1Interface.h"

@interface CDTMOPhotoV1 : NSManagedObject <CDTPhotoV1Interface>

@property (nonatomic, retain) NSString * assetURL;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * likes;
@property (nonatomic, retain) NSString * locationDesc;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSNumber * width;

@end
