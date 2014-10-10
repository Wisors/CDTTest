//
//  CDTPerfomanceTest.m
//  CoreData Tests
//
//  Created by Alexandr Nikishin on 20/09/14.
//  Copyright (c) 2014 Alexansdf1der Nikishin. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CDTAppDelegate.h"
#import "CDTCoreDataStack.h"

#import "CDTFirstModelTest.h"

@interface CDTFirstModelPerfomanceTest : XCTestCase

@property (nonatomic, strong) NSManagedObjectContext *mainMOC;
@property (nonatomic, strong) NSManagedObjectContext *backgroundMOC;
@property (nonatomic, strong) CDTFirstModelTest *test;

@end

@implementation CDTFirstModelPerfomanceTest

- (void)setUp {
    [super setUp];
    CDTCoreDataStack *stack = ((CDTAppDelegate *)[UIApplication sharedApplication].delegate).stack;
    self.mainMOC = stack.mainContext;
    self.backgroundMOC = stack.backgroundContext;
    self.test = [[CDTFirstModelTest alloc] initWithMainContext:self.mainMOC
                                             backgroundContext:self.backgroundMOC];
    
}

- (void)tearDown {
    self.test = nil;
    [super tearDown];
}

- (void)testModelInsertPerfomanceWithoutIndex {
    [self measureMetrics:[[self class] defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        [self performInserts];
    }];
}

- (void)testModelInsertPerfomanceWithSingularIndexes  {
    self.test.indexType = CDTModelSingularIndexes;
    [self measureMetrics:[[self class] defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        [self performInserts];
    }];
}

- (void)testModelInsertPerfomanceWithCompoundIndex {
    self.test.indexType = CDTModelCompoundIndex;
    [self measureMetrics:[[self class] defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        [self performInserts];
    }];
}

- (void)performInserts {
    [self.test cleanStorage];
    [self startMeasuring];
    [self.test makeInsertOperations];
    [self stopMeasuring];
}

- (void)testModelFetchPerfomanceWithoutIndex {
    [self populateDataIfNeeded];
    [self measureMetrics:[[self class] defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        [self startMeasuring];
        [self.test makeFetchRequest];
        [self stopMeasuring];
    }];
}

- (void)testModelFetchPerfomanceWithSingularIndexes {
    self.test.indexType = CDTModelSingularIndexes;
    [self populateDataIfNeeded];
    [self measureBlock:^{
        [self.test makeFetchRequest];
    }];
}

- (void)testModelFetchPerfomanceWithCompoundIndex {
    self.test.indexType = CDTModelCompoundIndex;
    [self populateDataIfNeeded];
    [self measureBlock:^{
        [self.test makeFetchRequest];
    }];
}

- (void)testNSFetchedResultControllerWithoutIndexAndBatches {
    [self populateDataIfNeeded];
    [self measureBlock:^{
        [self.test simulateNSFetchedResultsControllerUseBatches:NO];
    }];
}

- (void)testNSFetchedResultControllerWithoutIndexAndWithBacthes {
    [self populateDataIfNeeded];
    [self measureBlock:^{
        [self.test simulateNSFetchedResultsControllerUseBatches:YES];
    }];
}

- (void)testNSFetchedResultControllerWithSingularIndexesAndWithoutBacthes {
    self.test.indexType = CDTModelSingularIndexes;
    [self populateDataIfNeeded];
    [self measureBlock:^{
        [self.test simulateNSFetchedResultsControllerUseBatches:NO];
    }];
}

- (void)testNSFetchedResultControllerWithSingularIndexesAndBacthes {
    self.test.indexType = CDTModelSingularIndexes;
    [self populateDataIfNeeded];
    [self measureBlock:^{
        [self.test simulateNSFetchedResultsControllerUseBatches:YES];
    }];
}

- (void)testNSFetchedResultControllerWithCompoundIndexAndWithoutBacthes {
    self.test.indexType = CDTModelCompoundIndex;
    [self populateDataIfNeeded];
    [self measureBlock:^{
        [self.test simulateNSFetchedResultsControllerUseBatches:NO];
    }];
}

- (void)testNSFetchedResultControllerWithCompoundIndexAndBacthes {
    self.test.indexType = CDTModelCompoundIndex;
    [self populateDataIfNeeded];
    [self measureBlock:^{
        [self.test simulateNSFetchedResultsControllerUseBatches:YES];
    }];
}

- (void)testNSFetchedResultControllerWithDirectAccess {
    self.test.indexType = CDTModelSingularIndexes;
    [self populateDataIfNeeded];
    [self measureBlock:^{
        [self.test simulateNSFetchedResultsControllerWithDirectObjectAccess];
    }];
}

- (void)populateDataIfNeeded {
    if ([self.test numberOfObjects] == 0) {
        [self.test makeInsertOperations];
    }
}

@end
