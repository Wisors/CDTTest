//
//  CDTSecondModelPerfomanceTest.m
//  CoreData Tests
//
//  Created by Alexandr Nikishin on 20/09/14.
//  Copyright (c) 2014 Alexansdf1der Nikishin. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CDTAppDelegate.h"
#import "CDTCoreDataStack.h"

#import "CDTSecondModelTest.h"

@interface CDTSecondModelPerfomanceTest : XCTestCase

@property (nonatomic, strong) NSManagedObjectContext *mainMOC;
@property (nonatomic, strong) NSManagedObjectContext *backgroundMOC;
@property (nonatomic, strong) CDTSecondModelTest *test;
@property (nonatomic, assign) BOOL dataInserted;
@property (nonatomic, assign) BOOL dataIndexedInserted;

@end

@implementation CDTSecondModelPerfomanceTest

- (void)setUp {
    [super setUp];
    CDTCoreDataStack *stack = ((CDTAppDelegate *)[UIApplication sharedApplication].delegate).stack;
    self.mainMOC = stack.mainContext;
    self.backgroundMOC = stack.backgroundContext;
    self.test = [[CDTSecondModelTest alloc] initWithMainContext:self.mainMOC
                                              backgroundContext:self.backgroundMOC];
}

- (void)tearDown {
    self.test = nil;
    [super tearDown];
}

- (void)testModelInsertPerfomanceWithoutIndex {
    [self measureMetrics:[[self class] defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        [self.test cleanStorage];
        [self startMeasuring];
        [self.test makeInsertOperations];
        [self stopMeasuring];
    }];
}

- (void)testModelInsertPerfomanceWithIndex  {
    self.test.indexType = CDTModelSingularIndexes;
    [self measureMetrics:[[self class] defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        [self.test cleanStorage];
        [self startMeasuring];
        [self.test makeInsertOperations];
        [self stopMeasuring];
    }];
}

- (void)testModelFetchPerfomanceWithoutIndex {
    [self populateDataIfNeeded];
    [self measureBlock:^{
        [self.test makeFetchRequest];
    }];
}

- (void)testModelFetchPerfomanceWithIndex {
    self.test.indexType = CDTModelSingularIndexes;
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

- (void)testNSFetchedResultControllerWithIndexAndWithoutBacthes {
    self.test.indexType = CDTModelSingularIndexes;
    [self populateDataIfNeeded];
    [self measureBlock:^{
        [self.test simulateNSFetchedResultsControllerUseBatches:NO];
    }];
}

- (void)testNSFetchedResultControllerWithIndexAndBacthes {
    self.test.indexType = CDTModelSingularIndexes;
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
