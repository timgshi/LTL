//
//  LTLTripLogger.m
//  LyftTripLogger
//
//  Created by Julienne Lam on 5/26/15.
//  Copyright (c) 2015 Tim Shi. All rights reserved.
//

#import "LTLTripLogger.h"

#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <CoreLocation/CoreLocation.h>
#import "LTLConstants.h"
#import "LTLTrip.h"
#import <MagicalRecord/MagicalRecord.h>

@interface LTLTripLogger () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) BOOL isCurrentlyTracking;
@property (nonatomic, strong) NSTimer *stationaryTimer;

@end

@implementation LTLTripLogger

static NSString * const LTLTripStationaryTimerLocationKey = @"LTLTripStationaryTimerLocationKey";

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

- (BOOL)isCurrentlyTracking {
    return [[NSUserDefaults standardUserDefaults] boolForKey:LTLTripCurrentlyTrackingKey];
}

- (void)setIsCurrentlyTracking:(BOOL)isCurrentlyTracking {
    [[NSUserDefaults standardUserDefaults] setBool:isCurrentlyTracking forKey:LTLTripCurrentlyTrackingKey];
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
    if (self.isLoggingEnabled) {
        [self.locationManager startUpdatingLocation];
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void)stopLogging {
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (void)stationaryTimerDidFire:(NSTimer *)timer {
    if (self.isCurrentlyTracking) {
        
        self.isCurrentlyTracking = NO;
        CLLocation *location = timer.userInfo[LTLTripStationaryTimerLocationKey];
        [[CLGeocoder new] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placemark = [placemarks firstObject];
            [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"endDate == nil"];
                LTLTrip *trip = [LTLTrip MR_findFirstWithPredicate:predicate inContext:localContext];
                trip.endDate = location.timestamp;
                trip.endAddress = [trip addressStringFromPlacemark:placemark];
            } completion:^(BOOL success, NSError *error) {
                
            }];
        }];
    }
}

- (void)startStationaryTimerWithLastLocation:(CLLocation *)location {
    const NSTimeInterval kStationaryTimeInterval = 2;
    [self.stationaryTimer invalidate];
    self.stationaryTimer = [NSTimer scheduledTimerWithTimeInterval:kStationaryTimeInterval
                                                            target:self
                                                          selector:@selector(stationaryTimerDidFire:)
                                                          userInfo:@{LTLTripStationaryTimerLocationKey: location}
                                                           repeats:NO];
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    const CLLocationSpeed kMinSpeed = 4.4704; // 10 MPH
    
    CLLocation *location = [locations lastObject];
    if (self.isCurrentlyTracking) {
        [self startStationaryTimerWithLastLocation:location];
    } else {
        CLLocationSpeed speed = [location speed];
        if (speed > kMinSpeed) {
            
            
            self.isCurrentlyTracking = YES;
            
            [[CLGeocoder new] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                CLPlacemark *placemark = [placemarks firstObject];
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    LTLTrip *trip = [LTLTrip MR_createInContext:localContext];
                    trip.startDate = location.timestamp;
                    trip.startAddress = [trip addressStringFromPlacemark:placemark];
                }];
            }];
            [self startStationaryTimerWithLastLocation:location];
        }
    }
}

@end
