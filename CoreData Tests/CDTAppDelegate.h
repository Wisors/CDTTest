//
//  CDTAppDelegate.h
//  CoreData Tests
//
//  Created by Alexandr Nikishin on 07/09/14.
//  Copyright (c) 2014 Alexansdf1der Nikishin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CDTCoreDataStack.h"

@interface CDTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CDTCoreDataStack *stack;

@end
