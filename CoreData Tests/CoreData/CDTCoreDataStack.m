//
//  CDTCoreDataStack.m
//  CoreData Tests
//
//  Created by Alexandr Nikishin on 07/09/14.
//  Copyright (c) 2014 Alexansdf1der Nikishin. All rights reserved.
//

#import "CDTCoreDataStack.h"

static NSString *const PLCoreDataSQLFileName = @"CDTmodel";
static NSString *const PLCoreDataModelFileName = @"CDTmodel";

@implementation CDTCoreDataStack {
    NSURL *_storeURL;
    NSManagedObjectModel *_objectModel;
    NSPersistentStoreCoordinator *_backgroundCoordinator;
}

- (instancetype)initStackError:(NSError *__autoreleasing *)error {
    if (self = [super init]) {
        _storeURL = [CDTCoreDataStack storeURL];
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:PLCoreDataModelFileName withExtension:@"momd"];
        _objectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        // main
        _mainCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_objectModel];
        NSError *error;
        if (![_mainCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:_storeURL options:[self _persistentStoreOptions] error:&error]) {
            NSAssert(false, @"Fail to add persistentStore");
            return nil;
        }
        
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainContext setPersistentStoreCoordinator:_mainCoordinator];
        
        // background
        _backgroundCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_objectModel];
        if (![_backgroundCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:_storeURL options:[self _persistentStoreOptions] error:&error]) {
            NSAssert(false, @"Fail to add persistentStore");
            return nil;
        }
        
        _backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_backgroundContext setPersistentStoreCoordinator:_backgroundCoordinator];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_mocDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:_backgroundContext];
        
    }
    return self;
}

- (NSDictionary *)_persistentStoreOptions {
    return @{ NSInferMappingModelAutomaticallyOption: @YES,
              NSMigratePersistentStoresAutomaticallyOption: @YES,
              NSSQLitePragmasOption: @{@"synchronous": @"OFF"}};
}

#pragma mark - Paths

+ (NSURL *)storeURL {
    NSString *storeFilename = [NSString stringWithFormat:@"%@.sqlite", PLCoreDataSQLFileName];
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:storeFilename];
}

+ (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Background Context Notifications

- (void)_mocDidSaveNotification:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        for(NSManagedObject *object in [[notification userInfo] objectForKey:NSUpdatedObjectsKey]) {
            [[_mainContext objectWithID:[object objectID]] willAccessValueForKey:nil];
        }
        [_mainContext mergeChangesFromContextDidSaveNotification:notification];
    });
}

@end

@implementation CDTCoreDataStack (DesctructiveDev)

+ (BOOL)deleteStore {
    NSString *path = [[self storeURL] path];
    NSError *error;
    BOOL didDelete = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    NSAssert(error == nil, @"Fail to delete database");

    return didDelete;
}

@end