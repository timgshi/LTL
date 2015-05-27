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
#import <Masonry/Masonry.h>

@interface LTLTripTableViewController ()

@property (nonatomic, strong) UIView *loggingSwitchView;
@property (nonatomic, strong) UILabel *loggingSwitchLabel;
@property (nonatomic, strong) UISwitch *loggingSwitch;

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
    
    [self setupLoggingSwitch];
    
    self.title = nil;
}

- (void)setupLoggingSwitch {
    
    const CGFloat kLoggingSwitchLabelFontSize = 20;
    const CGFloat kLoggingSwitchViewHeight = 80;
    const CGFloat kHorizontalMargin = 15;
    const CGFloat kSeparatorHeight = 1;
    
    self.loggingSwitchView = [UIView new];
    self.loggingSwitchView.backgroundColor = [UIColor whiteColor];
    
    self.loggingSwitchLabel = [UILabel new];
    self.loggingSwitchLabel.font = [UIFont boldSystemFontOfSize:kLoggingSwitchLabelFontSize];
    self.loggingSwitchLabel.text = NSLocalizedString(@"Trip logging", nil);
    [self.loggingSwitchView addSubview:self.loggingSwitchLabel];
    
    self.loggingSwitch = [UISwitch new];
    [self.loggingSwitchView addSubview:self.loggingSwitch];
    
    UIView *separatorView = [UIView new];
    separatorView.backgroundColor = self.tableView.separatorColor;
    [self.loggingSwitchView addSubview:separatorView];

    self.tableView.tableHeaderView = self.loggingSwitchView;
    
    [self.loggingSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kLoggingSwitchViewHeight));
        make.width.equalTo(self.tableView.mas_width);
    }];
    
    [self.loggingSwitchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loggingSwitchView.mas_left).with.offset(kHorizontalMargin);
        make.centerY.equalTo(self.loggingSwitchView.mas_centerY);
    }];
    
    [self.loggingSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.loggingSwitchView.mas_right).with.offset(-kHorizontalMargin);
        make.centerY.equalTo(self.loggingSwitchView.mas_centerY);
    }];
    
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.loggingSwitchView.mas_width);
        make.height.equalTo(@(kSeparatorHeight));
        make.bottom.equalTo(self.loggingSwitchView.mas_bottom);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTLTripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LTLTripTableViewCell defaultIdentifier]];
    cell.trip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return cell;
}

@end
