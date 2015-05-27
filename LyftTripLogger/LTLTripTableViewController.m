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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    [LTLTripTableViewCell registerWithTableView:self.tableView];
    
    self.fetchedResultsController = [LTLTrip allSortedTripsController];
    
    self.title = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTLTripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LTLTripTableViewCell defaultIdentifier]];
    cell.trip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return cell;
}

@end
