//
//  CDTTestWithIndex.m
//  CoreData Tests
//
//  Created by Alexandr Nikishin on 20/09/14.
//  Copyright (c) 2014 Alexansdf1der Nikishin. All rights reserved.
//

#import "CDTSecondModelTest.h"

#import "CDTMOPhotoV2.h"
#import "CDTMOPhotoV2Index.h"
#import "CDTMOPhotoMeta.h"
#import "CDTMOPhotoMetaIndex.h"

@implementation CDTSecondModelTest

- (NSString *)photoEntityName {
    return (self.indexType != CDTModelWithoutIndex) ? NSStringFromClass([CDTMOPhotoV2Index class]) : NSStringFromClass([CDTMOPhotoV2 class]);
}

- (NSString *)metaEntityName {
    return (self.indexType != CDTModelWithoutIndex) ? NSStringFromClass([CDTMOPhotoMetaIndex class]) : NSStringFromClass([CDTMOPhotoMeta class]);
}

- (void)makeInsertOperations {
    NSString *photoEntityName = [self photoEntityName];
    NSString *metaEntityName = [self metaEntityName];
    [self.backgroundMOC performBlockAndWait:^{
        for (CDTPhotoTest *testPhoto in [CDTPhotoEntityRandomizer shared].randomizedPhotos) {
            NSManagedObject <CDTPhotoV2Interface> *photo = [NSEntityDescription insertNewObjectForEntityForName:photoEntityName
                                                                                         inManagedObjectContext:self.backgroundMOC];
            NSManagedObject <CDTMetaInterface> *meta = [NSEntityDescription insertNewObjectForEntityForName:metaEntityName
                                                                                     inManagedObjectContext:self.backgroundMOC];
            photo.assetURL = testPhoto.assetURL;
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
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"meta.date" ascending:YES]]];
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
    NSManagedObject *currentObject;
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
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"meta.likes" ascending:NO],
                                  [NSSortDescriptor sortDescriptorWithKey:@"meta.date" ascending:NO]]];
    if (allowBatchLimit) {
        [request setFetchBatchSize:kBatchSize];
    }
    
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                 managedObjectContext:self.mainMOC
                                                                                   sectionNameKeyPath:@"meta.likes"
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
