//
//  LTLTripLogger.m
//  LyftTripLogger
//
//  Created by Julienne Lam on 5/26/15.
//  Copyright (c) 2015 Tim Shi. All rights reserved.
//

#import "LTLTripLogger.h"

#import <CoreLocation/CoreLocation.h>
#import "LTLConstants.h"

@interface LTLTripLogger () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

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

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        [_locationManager requestAlwaysAuthorization];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)startLogging {
    [self.locationManager startUpdatingLocation];
}

- (void)stopLogging {
    [self.locationManager stopUpdatingLocation];
}

@end
