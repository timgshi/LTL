//
//  LTLTrip.m
//  LyftTripLogger
//
//  Created by Tim Shi on 5/26/15.
//  Copyright (c) 2015 Tim Shi. All rights reserved.
//

#import "LTLTrip.h"

#import <CoreLocation/CoreLocation.h>

@implementation LTLTrip

@dynamic startDate;
@dynamic endDate;
@dynamic startAddress;
@dynamic endAddress;

+ (NSFetchedResultsController *)allSortedTripsController {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startDate != nil AND endDate != nil"];
    return [self MR_fetchAllGroupedBy:nil
                        withPredicate:predicate
                             sortedBy:@"startDate"
                            ascending:NO];
}

- (NSString *)addressStringFromPlacemark:(CLPlacemark *)placemark {
    NSString *addressString = @"";
    if (placemark.subThoroughfare) {
        addressString = [NSString stringWithFormat:@"%@ ", placemark.subThoroughfare];
    }
    if (placemark.thoroughfare) {
        addressString = [addressString stringByAppendingString:placemark.thoroughfare];
    }
    return addressString;
}

@end
