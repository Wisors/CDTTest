//
//  CDTPerformanceTest.h
//  CoreData Tests
//
//  Created by Alexandr Nikishin on 20/09/14.
//  Copyright (c) 2014 Alexansdf1der Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CDTPhotoEntityRandomizer.h"

@protocol CDTPerformanceTest <NSObject>

- (void)makeInsertOperations;
- (void)makeFetchRequest;
- (void)simulateNSFetchedResultsControllerUseBatches:(BOOL)allowBatchLimit;
- (void)simulateNSFetchedResultsControllerWithDirectObjectAccess;

- (NSUInteger)numberOfObjects;
- (void)cleanStorage;

@end
