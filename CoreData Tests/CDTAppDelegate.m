//
//  CDTAppDelegate.m
//  CoreData Tests
//
//  Created by Alexandr Nikishin on 07/09/14.
//  Copyright (c) 2014 Alexansdf1der Nikishin. All rights reserved.
//

#import "CDTAppDelegate.h"

#import "CDTPhotoEntityRandomizer.h"

@implementation CDTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSError *error;
    _stack = [[CDTCoreDataStack alloc] initStackError:&error];
    NSAssert(error == nil, @"Can't initialize stack!");
    
    [CDTPhotoEntityRandomizer shared]; // Randomize assets
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

@end
