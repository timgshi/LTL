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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupAutoMigratingCoreDataStack];
    [self clearTestTrips];
    [self createTestTrips];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}

- (void)clearTestTrips {
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    [LTLTrip MR_deleteAllMatchingPredicate:predicate];
}

- (void)createTestTrips {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        LTLTrip *trip = [LTLTrip MR_createInContext:localContext];
        trip.startDate = [[NSDate date] dateByAddingTimeInterval:-60*60*5];
        trip.endDate = [NSDate date];
        trip.startAddress = @"Address 1";
        trip.endAddress = @"Address 2";
    }];
}

@end
