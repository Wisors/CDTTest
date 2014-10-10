//
//  CDTThirdModelTest.m
//  CoreData Tests
//
//  Created by Alexandr Nikishin on 21/09/14.
//  Copyright (c) 2014 Alexansdf1der Nikishin. All rights reserved.
//

#import "CDTThirdModelTest.h"

#import "CDTPhotoEntityRandomizer.h"
#import "CDTMOPhotoMetaV3.h"
#import "CDTMOPhotoV3.h"

@implementation CDTThirdModelTest

- (NSString *)photoEntityName {
    return NSStringFromClass([CDTMOPhotoV3 class]);
}

- (NSString *)metaEntityName {
    return NSStringFromClass([CDTMOPhotoMetaV3 class]);
}

- (void)makeInsertOperations {
    NSString *photoEntityName = [self photoEntityName];
    NSString *metaEntityName = [self metaEntityName];
    [self.backgroundMOC performBlockAndWait:^{
        for (CDTPhotoTest *testPhoto in [CDTPhotoEntityRandomizer shared].randomizedPhotos) {
            CDTMOPhotoV3 *photo = [NSEntityDescription insertNewObjectForEntityForName:photoEntityName
                                                                inManagedObjectContext:self.backgroundMOC];
            CDTMOPhotoMetaV3 *meta = [NSEntityDescription insertNewObjectForEntityForName:metaEntityName
                                                                   inManagedObjectContext:self.backgroundMOC];
            photo.assetURL = testPhoto.assetURL;
            photo.likes = @(testPhoto.likes);
            photo.date = testPhoto.originalDate;
            photo.meta = meta;
            
            meta.size = @(testPhoto.size);
            meta.latitude = @(testPhoto.location.coordinate.latitude);
            meta.longitude = @(testPhoto.location.coordinate.longitude);
            meta.likes = @(testPhoto.likes);
            meta.width = @(testPhoto.width);
            meta.height = @(testPhoto.height);
            meta.date = testPhoto.originalDate;
            meta.country = testPhoto.country;
            meta.locationDesc = testPhoto.locationDescription;
        }
        NSError *error;
        [self.backgroundMOC save:&error];
        NSAssert(error == nil, @"Core Data error occurred!");
    }];
}

- (void)makeFetchRequest {
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:[NSEntityDescription entityForName:[self photoEntityName]
                                   inManagedObjectContext:self.mainMOC]];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
    NSArray *result = [self.mainMOC executeFetchRequest:request error:NULL];
    result = nil; // Suppress warning
}

- (void)simulateNSFetchedResultsControllerUseBatches:(BOOL)allowBatchLimit {
    NSFetchedResultsController *controller = [self createFetchedResultsControllerUseBatches:allowBatchLimit];
    
    NSError *error = nil;
    [controller performFetch:&error];
    NSAssert(error == nil, @"Core Data error occurred!");
    
    //Simulate data access.
    NSInteger sectionIndex = 0;
    NSInteger objectsCount = 0;
    CDTMOPhotoMetaV3 *currentObject;
    while (sectionIndex < [[controller sections] count] && objectsCount < kBatchSize) {
        NSInteger numberOfObjects = [[[controller sections] objectAtIndex:sectionIndex] numberOfObjects];
        objectsCount += numberOfObjects;
        currentObject = [controller objectAtIndexPath:[NSIndexPath indexPathForRow:(numberOfObjects - 1) inSection:sectionIndex]];
        sectionIndex++;
    }
}

- (void)simulateNSFetchedResultsControllerWithDirectObjectAccess {
    NSFetchedResultsController *controller = [self createFetchedResultsControllerUseBatches:YES];
    
    NSError *error = nil;
    [controller performFetch:&error];
    NSAssert(error == nil, @"Core Data error occurred!");
    
    //Simulate data access.
    NSInteger sectionIndex = 0;
    NSInteger objectsCount = 0;
    NSManagedObject *currentObject;
    while (sectionIndex < [[controller sections] count] && objectsCount < kBatchSize) {
        NSArray *objects = [[[controller sections] objectAtIndex:sectionIndex] objects];
        objectsCount += [objects count];
        currentObject = [objects lastObject];
        sectionIndex++;
    }
}

- (NSFetchedResultsController *)createFetchedResultsControllerUseBatches:(BOOL)allowBatchLimit {
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:[NSEntityDescription entityForName:[self photoEntityName]
                                   inManagedObjectContext:self.mainMOC]];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"likes" ascending:NO],
                                  [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
    [request setIncludesSubentities:NO];
    if (allowBatchLimit) {
        [request setFetchBatchSize:kBatchSize];
    }
    
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                 managedObjectContext:self.mainMOC
                                                                                   sectionNameKeyPath:@"likes"
                                                                                            cacheName:nil];
    return controller;
}

- (NSUInteger)numberOfObjects {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:[self photoEntityName] inManagedObjectContext:self.mainMOC]];
    [request setIncludesSubentities:NO];
    
    NSError *error;
    NSUInteger count = [self.mainMOC countForFetchRequest:request error:&error];
    NSAssert(error == nil, @"Core Data error occurred!");
    
    return count;
}

- (void)cleanStorage {
    [self deleteAllObjectsFrom:[self photoEntityName] inContext:self.mainMOC];
    [self deleteAllObjectsFrom:[self metaEntityName] inContext:self.mainMOC];
}

@end
