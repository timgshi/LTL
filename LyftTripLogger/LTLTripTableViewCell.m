//
//  LTLTripTableViewCell.m
//  LyftTripLogger
//
//  Created by Tim Shi on 5/26/15.
//  Copyright (c) 2015 Tim Shi. All rights reserved.
//

#import "LTLTripTableViewCell.h"

#import <Masonry/Masonry.h>

@interface LTLTripTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *addressLabel, *timeLabel;
@property (nonatomic, strong) UIView *separatorView;

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
    static LTLTripTableViewCell *sizingCell = nil;
    static UITableView *sizingTableView = nil;
    if (sizingTableView != tableView) {
        sizingTableView = tableView;
        sizingCell = [tableView dequeueReusableCellWithIdentifier:[self defaultIdentifier]];
    }
    sizingCell.trip = trip;
    [sizingCell setNeedsLayout];
    return 0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    const CGFloat kAddressLabelFontSize = 14;
    const CGFloat kTimeLabelFontSize = 12;
    
    self.separatorInset = UIEdgeInsetsZero;
    self.preservesSuperviewLayoutMargins = NO;
    
    self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_car"]];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.iconImageView];
    
    self.addressLabel = [UILabel new];
    self.addressLabel.font = [UIFont boldSystemFontOfSize:kAddressLabelFontSize];
    self.addressLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.addressLabel.numberOfLines = 0;
    [self.contentView addSubview:self.addressLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont italicSystemFontOfSize:kTimeLabelFontSize];
    self.timeLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.timeLabel.numberOfLines = 0;
    [self.contentView addSubview:self.timeLabel];
    
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.contentView addSubview:self.separatorView];
    
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    if (!self.hasInstalledViewConstraints) {
        self.hasInstalledViewConstraints = YES;
        
        const CGFloat kHorizontalMargin = 15;
        const CGFloat kTopMargin = 10;
        const CGFloat kLabelSeparator = 5;
        const CGFloat kBottomMargin = 5;
        const CGSize kIconSize = {25, 19};
        const CGFloat kIconVerticalOffset = 4;
        const CGFloat kSeparatorHeight = 0.5;
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(kHorizontalMargin);
            make.top.equalTo(self.contentView.mas_top).with.offset(kTopMargin + kIconVerticalOffset);
            make.size.equalTo([NSValue valueWithCGSize:kIconSize]);
        }];
        
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).with.offset(kHorizontalMargin);
            make.top.equalTo(self.contentView.mas_top).with.offset(kTopMargin);
            make.right.equalTo(self.contentView.mas_right).with.offset(-kHorizontalMargin);
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).with.offset(kHorizontalMargin);
            make.top.equalTo(self.addressLabel.mas_bottom).with.offset(kLabelSeparator);
            make.right.equalTo(self.contentView.mas_right).with.offset(-kHorizontalMargin);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-kBottomMargin);
        }];
        
        [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@(kSeparatorHeight));
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addressLabel.mas_top).with.offset(-kTopMargin);
            make.bottom.equalTo(self.timeLabel.mas_bottom).with.offset(kBottomMargin);
            make.width.equalTo(self.mas_width);
        }];
    }
    
    [super updateConstraints];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.addressLabel.text = nil;
    self.timeLabel.text = nil;
}

- (void)setTrip:(LTLTrip *)trip {
    _trip = trip;
    
    static NSDateFormatter *dateFormatter = nil;
    static NSDateComponentsFormatter *dateComponentsFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"hh:mma"];
//        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
//        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        dateComponentsFormatter = [NSDateComponentsFormatter new];
        dateComponentsFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
    });
    
    if (trip) {
        self.addressLabel.text = [NSString stringWithFormat:@"%@ > %@", trip.startAddress, trip.endAddress];
        self.timeLabel.text = [NSString stringWithFormat:@"%@-%@ (%@)",
                               [[dateFormatter stringFromDate:trip.startDate] lowercaseString],
                               [[dateFormatter stringFromDate:trip.endDate] lowercaseString],
                               [dateComponentsFormatter stringFromTimeInterval:[trip.endDate timeIntervalSinceDate:trip.startDate]]];
    }
}

@end
