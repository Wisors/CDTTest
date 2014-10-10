//
//  PSPhotoEntityRandomizer.h
//  my
//
//  Created by Alexander Nikishin on 04.07.14.
//  Copyright (c) 2014 mail.ru. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@class CDTPhotoTest;

@interface CDTPhotoTest : NSObject

@property (nonatomic, strong) NSString *assetURL;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) NSDate *originalDate;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *locationDescription;

@end

@interface CDTPhotoEntityRandomizer : NSObject

@property (strong, nonatomic) NSArray *randomizedPhotos;
// Parameters
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) NSDate *minDate; //two years ago by default
@property (strong, nonatomic) NSDate *maxDate; //now
@property (assign, nonatomic) NSInteger groupSize;

+ (CDTPhotoEntityRandomizer *)shared;

@end

