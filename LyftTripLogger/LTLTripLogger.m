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
#import "LTLTrip.h"

@interface LTLTripLogger () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) BOOL isCurrentlyTracking;

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
    if (!isLoggingEnabled) {
        [self stopLogging];
    }
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
    if (self.isLoggingEnabled) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)stopLogging {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    const CLLocationSpeed kMinSpeed = 4.4704; // 10 MPH
    
    CLLocation *location = [locations lastObject];
    if (self.isCurrentlyTracking) {
        
    } else {
        CLLocationSpeed speed = [location speed];
        if (speed > kMinSpeed) {
            self.isCurrentlyTracking = YES;
            
        }
    }
}

@end
