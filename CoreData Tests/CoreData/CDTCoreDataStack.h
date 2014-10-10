//
//  CDTCoreDataStack.h
//  CoreData Tests
//
//  Created by Alexandr Nikishin on 07/09/14.
//  Copyright (c) 2014 Alexansdf1der Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CDTCoreDataVersion) {
    CDTCoreDataVersionFlat,
    CDTCoreDataVersionMetaRelation,
    CDTCoreDataVersionMetaRelationWithCache
};

@interface CDTCoreDataStack : NSObject

@property (nonatomic, readonly) NSPersistentStoreCoordinator *mainCoordinator;
@property (nonatomic, readonly) NSManagedObjectContext *mainContext;
@property (nonatomic, readonly) NSManagedObjectContext *backgroundContext;

- (instancetype)initStackWithVersion:(CDTCoreDataVersion)version error:(NSError *__autoreleasing *)error;

@end

@interface CDTCoreDataStack(DesctructiveDev)

+ (BOOL)deleteStore;

@end
