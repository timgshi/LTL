//
//  LTLTripTableViewController.m
//  LyftTripLogger
//
//  Created by Tim Shi on 5/26/15.
//  Copyright (c) 2015 Tim Shi. All rights reserved.
//

#import "LTLTripTableViewController.h"

#import "LTLTrip.h"
#import "LTLTripTableViewCell.h"

@interface LTLTripTableViewController ()

@end

@implementation LTLTripTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [LTLTripTableViewCell registerWithTableView:self.tableView];
    
    self.fetchedResultsController = [LTLTrip allSortedTripsController];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTLTripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LTLTripTableViewCell defaultIdentifier]];
    cell.trip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTLTrip *trip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [LTLTripTableViewCell heightWithTrip:trip inTableView:tableView];
}

@end
