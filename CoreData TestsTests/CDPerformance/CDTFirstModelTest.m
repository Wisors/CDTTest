//
//  CDTTestWithoutIndex.m
//  CoreData Tests
//
//  Created by Alexandr Nikishin on 20/09/14.
//  Copyright (c) 2014 Alexansdf1der Nikishin. All rights reserved.
//

#import "CDTFirstModelTest.h"

#import "CDTMOPhotoV1.h"
#import "CDTMOPhotoV1Index.h"
#import "CDTMOPhotoV1CompoundIndex.h"

@implementation CDTFirstModelTest

- (NSString *)entityName {
    switch (self.indexType) {
        case CDTModelSingularIndexes:
            return NSStringFromClass([CDTMOPhotoV1Index class]);
            break;
        case CDTModelCompoundIndex:
            return NSStringFromClass([CDTMOPhotoV1CompoundIndex class]);
            break;
        case CDTModelWithoutIndex:
        default:
            return NSStringFromClass([CDTMOPhotoV1 class]);
            break;
    }
}

- (void)makeInsertOperations {
    NSString *entityName = [self entityName];
    [self.backgroundMOC performBlockAndWait:^{
        for (CDTPhotoTest *testPhoto in [CDTPhotoEntityRandomizer shared].randomizedPhotos) {
            NSManagedObject <CDTPhotoV1Interface> *photo = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                                                        inManagedObjectContext:self.backgroundMOC];
            photo.assetURL = testPhoto.assetURL;
            photo.size = @(testPhoto.size);
            photo.latitude = @(testPhoto.location.coordinate.latitude);
            photo.longitude = @(testPhoto.location.coordinate.longitude);
            photo.likes = @(testPhoto.likes);
            photo.width = @(testPhoto.width);
            photo.height = @(testPhoto.height);
            photo.date = testPhoto.originalDate;
            photo.country = testPhoto.country;
            photo.locationDesc = testPhoto.locationDescription;
        }
        NSError *error;
        [self.backgroundMOC save:&error];
        NSAssert(error == nil, @"Core Data error occurred!");
    }];
}

- (void)makeFetchRequest {
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:[NSEntityDescription entityForName:[self entityName]
                                   inManagedObjectContext:self.mainMOC]];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
    NSError *error = nil;
    NSArray *result = [self.mainMOC executeFetchRequest:request error:&error];
    NSAssert(error == nil, @"Core Data error occurred!");
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
    [request setEntity:[NSEntityDescription entityForName:[self entityName]
                                   inManagedObjectContext:self.mainMOC]];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"likes" ascending:NO],
                                  [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
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
    [request setEntity:[NSEntityDescription entityForName:[self entityName] inManagedObjectContext:self.mainMOC]];
    [request setIncludesSubentities:NO];
    
    NSError *error;
    NSUInteger count = [self.mainMOC countForFetchRequest:request error:&error];
    NSAssert(error == nil, @"Core Data error occurred!");
    
    return count;
}

- (void)cleanStorage {
    [self deleteAllObjectsFrom:[self entityName] inContext:self.mainMOC];
}

@end
