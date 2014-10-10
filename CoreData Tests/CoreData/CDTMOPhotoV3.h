//
//  CDTMOPhotoV3.h
//  CoreData Tests
//
//  Created by Alexandr Nikishin on 21/09/14.
//  Copyright (c) 2014 Alexansdf1der Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDTMOPhotoMetaV3;

@interface CDTMOPhotoV3 : NSManagedObject

@property (nonatomic, retain) NSString * assetURL;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * likes;
@property (nonatomic, retain) CDTMOPhotoMetaV3 *meta;

@end
