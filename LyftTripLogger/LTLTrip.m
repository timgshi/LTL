//
//  LTLTrip.m
//  LyftTripLogger
//
//  Created by Tim Shi on 5/26/15.
//  Copyright (c) 2015 Tim Shi. All rights reserved.
//

#import "LTLTrip.h"


@implementation LTLTrip

@dynamic startDate;
@dynamic endDate;
@dynamic startAddress;
@dynamic endAddress;

+ (NSFetchedResultsController *)allSortedTripsController {
    return [self MR_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithValue:YES] sortedBy:@"startDate" ascending:YES];
}

@end
