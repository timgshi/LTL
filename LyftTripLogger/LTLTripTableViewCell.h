//
//  LTLTripTableViewCell.h
//  LyftTripLogger
//
//  Created by Tim Shi on 5/26/15.
//  Copyright (c) 2015 Tim Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LTLTrip.h"

@interface LTLTripTableViewCell : UITableViewCell

+ (NSString *)defaultIdentifier;
+ (void)registerWithTableView:(UITableView *)tableView;
+ (CGFloat)heightWithTrip:(LTLTrip *)trip inTableView:(UITableView *)tableView;

@end
