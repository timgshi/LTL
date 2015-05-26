//
//  LTLTripTableViewCell.m
//  LyftTripLogger
//
//  Created by Tim Shi on 5/26/15.
//  Copyright (c) 2015 Tim Shi. All rights reserved.
//

#import "LTLTripTableViewCell.h"

@interface LTLTripTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *addressLabel, *timeLabel;

@property (nonatomic) BOOL hasInstalledViewConstraints;

@end

@implementation LTLTripTableViewCell

+ (NSString *)defaultIdentifier {
    static NSString * const LTLTripTableViewCellIdentifier = @"LTLTripTableViewCellIdentifier";
    return LTLTripTableViewCellIdentifier;
}

+ (void)registerWithTableView:(UITableView *)tableView {
    [tableView registerClass:self forCellReuseIdentifier:[self defaultIdentifier]];
}

+ (CGFloat)heightWithTrip:(LTLTrip *)trip inTableView:(UITableView *)tableView {
    return 0;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    const CGFloat kAddressLabelFontSize = 14;
    const CGFloat kTimeLabelFontSize = 12;
    
    self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_car"]];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.iconImageView];
    
    self.addressLabel = [UILabel new];
    self.addressLabel.font = [UIFont boldSystemFontOfSize:kAddressLabelFontSize];
    self.addressLabel.numberOfLines = 0;
    [self.contentView addSubview:self.addressLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont italicSystemFontOfSize:kTimeLabelFontSize];
    self.timeLabel.numberOfLines = 0;
    [self.contentView addSubview:self.timeLabel];
}

- (void)updateConstraints {
    if (!self.hasInstalledViewConstraints) {
        self.hasInstalledViewConstraints = YES;
    }
    
    [super updateConstraints];
}

@end
