//
//  CDTThirdModelPerfomanceTest.m
//  CoreData Tests
//
//  Created by Alexandr Nikishin on 21/09/14.
//  Copyright (c) 2014 Alexansdf1der Nikishin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CDTAppDelegate.h"
#import "CDTCoreDataStack.h"

#import "CDTThirdModelTest.h"


@interface CDTThirdModelPerfomanceTest : XCTestCase

@property (nonatomic, strong) NSManagedObjectContext *mainMOC;
@property (nonatomic, strong) NSManagedObjectContext *backgroundMOC;
@property (nonatomic, strong) CDTThirdModelTest *test;
@property (nonatomic, assign) BOOL dataInserted;

@end

@implementation CDTThirdModelPerfomanceTest

- (void)setUp {
    [super setUp];
    CDTCoreDataStack *stack = ((CDTAppDelegate *)[UIApplication sharedApplication].delegate).stack;
    self.mainMOC = stack.mainContext;
    self.backgroundMOC = stack.backgroundContext;
    self.test = [[CDTThirdModelTest alloc] initWithMainContext:self.mainMOC
                                             backgroundContext:self.backgroundMOC];
}

- (void)tearDown {
    self.test = nil;
    [super tearDown];
}

- (void)testModelInsertPerfomanceWithIndex  {
    [self measureMetrics:[[self class] defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        [self.test cleanStorage];
        [self startMeasuring];
        [self.test makeInsertOperations];
        [self stopMeasuring];
    }];
}

- (void)testModelFetchPerfomanceWithIndex {
    [self populateDataIfNeeded];
    [self measureBlock:^{
        [self.test makeFetchRequest];
    }];
}

- (void)testNSFetchedResultControllerWithIndexAndWithoutBacthes {
    [self populateDataIfNeeded];
    [self measureBlock:^{
        [self.test simulateNSFetchedResultsControllerUseBatches:NO];
    }];
}

- (void)testNSFetchedResultControllerWithIndexAndBacthes {
    [self populateDataIfNeeded];
    [self measureBlock:^{
        [self.test simulateNSFetchedResultsControllerUseBatches:YES];
    }];
}

- (void)testNSFetchedResultControllerWithDirectAccess {
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
