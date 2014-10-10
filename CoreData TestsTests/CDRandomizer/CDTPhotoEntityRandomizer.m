//
//  PSPhotoEntityRandomizer.m
//  my
//
//  Created by Alexander Nikishin on 04.07.14.
//  Copyright (c) 2014 mail.ru. All rights reserved.
//

#import "CDTPhotoEntityRandomizer.h"

@interface CDTPhotoTest()
@end

@implementation CDTPhotoTest
@end

@implementation CDTPhotoEntityRandomizer

+ (CDTPhotoEntityRandomizer *)shared {
    static CDTPhotoEntityRandomizer *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initWithCount:kTestPhotosCount];
        [manager randomize];
    });
    return manager;
}

- (instancetype)initWithCount:(NSInteger)count {
   if ((self = [super init])) {
      _count = count;
      _minDate = [NSDate dateWithTimeIntervalSinceNow:-(365 * 2 * 24 * 60 * 60)];
      _maxDate = [NSDate date];
   }
   
   return self;
}

- (void)randomize {
   NSMutableArray *photos = [NSMutableArray array];
   NSInteger groupIndex = 0;
   CDTPhotoTest *groupRoot;
   for (NSInteger i = 0; i < self.count; i++) {
      if (groupIndex == 0) {
         groupRoot = [self randomizePhoto];
         [photos addObject:groupRoot];
      } else {
         [photos addObject:[self slightlyRandomizeByPhoto:groupRoot]];
      }
      groupIndex++;
      if (groupIndex == self.groupSize) {
         groupIndex = 0;
      }
   }
   self.randomizedPhotos = [photos copy];
}

- (CDTPhotoTest *)randomizePhoto {
   CDTPhotoTest *test = [CDTPhotoTest new];
   NSString *srcID = [self randomDigitStringWithLenght:10];
   test.assetURL = [NSString stringWithFormat:@"assets-library://asset/asset.JPG?id=%@&ext=JPG", srcID];
   test.width = [self randomNumberInRangeBetween:100 andMax:2000];
   test.height = [self randomNumberInRangeBetween:100 andMax:2000];
   test.size = [self randomNumberInRangeBetween:10000 andMax:10000000];
   test.likes = [self randomNumberInRangeBetween:0 andMax:1000];
   test.originalDate = [self randomizedDate];
   test.location = [self randomizeLocation];
   test.country = [self randomStringWithLength:12];
   test.locationDescription = [self randomStringWithLength:25];
   
   return test;
}

- (CDTPhotoTest *)slightlyRandomizeByPhoto:(CDTPhotoTest *)photo {
   CDTPhotoTest *test = [[CDTPhotoTest alloc] init];
   NSString *srcID = [self randomDigitStringWithLenght:10];
   test.assetURL = [NSString stringWithFormat:@"assets-library://asset/asset.JPG?id=%@&ext=JPG", srcID];
   test.width = [self randomNumberInRangeBetween:100 andMax:2000];
   test.height = [self randomNumberInRangeBetween:100 andMax:2000];
   test.likes = [self randomNumberInRangeBetween:0 andMax:1000];
   test.originalDate = [self randomizeDateInRangeBetweenMin:[photo.originalDate dateByAddingTimeInterval:-(100 * 60)]
                                                     andMax:[photo.originalDate dateByAddingTimeInterval:(100 * 60)]];
   CGFloat latitude, longitude;
   latitude = photo.location.coordinate.latitude + [self randomNumberInRangeBetween:0 andMax:1000] / 100000.f;
   longitude = photo.location.coordinate.longitude + [self randomNumberInRangeBetween:0 andMax:1000] / 100000.f;
   test.location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
   test.country = photo.country;
   test.locationDescription = photo.locationDescription;
   
   return test;
}

- (NSDate *)randomizedDate {
   return [self randomizeDateInRangeBetweenMin:self.minDate andMax:self.maxDate];
}

- (NSDate *)randomizeDateInRangeBetweenMin:(NSDate *)min andMax:(NSDate *)max {
   NSTimeInterval UNIXTime = [self randomNumberInRangeBetween:[min timeIntervalSince1970] andMax:[max timeIntervalSince1970]];
   return [NSDate dateWithTimeIntervalSince1970:UNIXTime];
}

- (CLLocation *)randomizeLocation {
   CGFloat latitude, longitude;
   latitude = [self randomNumberInRangeBetween:-90 andMax:89] + [self randomNumberInRangeBetween:0 andMax:100000] / 100000.f;
   longitude = [self randomNumberInRangeBetween:-180 andMax:179] + [self randomNumberInRangeBetween:0 andMax:100000] / 100000.f;
   return [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
}

- (NSInteger)randomNumberInRangeBetween:(NSInteger)min andMax:(NSInteger)max {
   return min + arc4random() % (max-min);
}

NSString *letters = @"abcdefghijklmnopqrstuvwxyz0123456789";
- (NSString *)randomStringWithLength:(int)len {
   NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
   for (int i=0; i<len; i++) {
      [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint)[letters length]) % [letters length]]];
   }
   
   return randomString;
}

NSString *digits = @"0123456789";
- (NSString *)randomDigitStringWithLenght:(int)len {
   NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
   for (int i=0; i<len; i++) {
      [randomString appendFormat: @"%C", [digits characterAtIndex: arc4random_uniform((uint)[digits length]) % [digits length]]];
   }
   
   return randomString;
}

@end

