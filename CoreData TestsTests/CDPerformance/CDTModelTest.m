//
//  CDTModelTest.m
//  CoreData Tests
//
//  Created by Alexandr Nikishin on 20/09/14.
//  Copyright (c) 2014 Alexansdf1der Nikishin. All rights reserved.
//

#import "CDTModelTest.h"

@implementation CDTModelTest

- (instancetype)initWithMainContext:(NSManagedObjectContext *)mainMOC backgroundContext:(NSManagedObjectContext *)backgroundMOC {
    if ((self = [super init])) {
        _mainMOC = mainMOC;
        _backgroundMOC = backgroundMOC;
        _indexType = CDTModelWithoutIndex;
    }
    
    return self;
}

- (void)deleteAllObjectsFrom:(NSString*)entity inContext:(NSManagedObjectContext*)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity];
    request.entity = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
    
    NSError *error = nil;
    NSArray *entityObjects = [context executeFetchRequest:request error:&error];
    NSAssert(error == nil, @"Core Data error occurred!");
    
    for (NSManagedObject *object in entityObjects) {
        [context deleteObject:object];
    }
    
    [context save:&error];
    NSAssert(error == nil, @"Core Data error occurred!");
}

@end
