//
//  LTLTripLogger.m
//  LyftTripLogger
//
//  Created by Julienne Lam on 5/26/15.
//  Copyright (c) 2015 Tim Shi. All rights reserved.
//

#import "LTLTripLogger.h"

#import "LTLConstants.h"

@implementation LTLTripLogger

+ (instancetype)sharedLogger {
    static LTLTripLogger *sharedLogger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLogger = [self new];
    });
    return sharedLogger;
}

- (BOOL)isLoggingEnabled {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:LTLTripLoggingKey]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LTLTripLoggingKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:LTLTripLoggingKey];
}

- (void)setIsLoggingEnabled:(BOOL)isLoggingEnabled {
    [[NSUserDefaults standardUserDefaults] setBool:isLoggingEnabled forKey:LTLTripLoggingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
