//
//  CDTModelTest.h
//  CoreData Tests
//
//  Created by Alexandr Nikishin on 20/09/14.
//  Copyright (c) 2014 Alexansdf1der Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CDTModelIndexType) {
    CDTModelWithoutIndex,
    CDTModelSingularIndexes,
    CDTModelCompoundIndex
};

@interface CDTModelTest : NSObject

@property (nonatomic, strong) NSManagedObjectContext *mainMOC;
@property (nonatomic, strong) NSManagedObjectContext *backgroundMOC;
@property (nonatomic, assign) CDTModelIndexType indexType;

- (id)initWithMainContext:(NSManagedObjectContext *)mainMOC backgroundContext:(NSManagedObjectContext *)backgroundMOC;

- (void)deleteAllObjectsFrom:(NSString*)entity inContext:(NSManagedObjectContext*)context;

@end
