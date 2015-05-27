//
//  AppDelegate.m
//  LyftTripLogger
//
//  Created by Tim Shi on 5/26/15.
//  Copyright (c) 2015 Tim Shi. All rights reserved.
//

#import "AppDelegate.h"

#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <MagicalRecord/MagicalRecord.h>
#import "LTLTrip.h"
#import "LTLTripLogger.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupAutoMigratingCoreDataStack];
    [[LTLTripLogger sharedLogger] startLogging];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}

@end
