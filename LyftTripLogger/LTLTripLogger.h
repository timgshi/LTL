//
//  LTLTripLogger.h
//  LyftTripLogger
//
//  Created by Julienne Lam on 5/26/15.
//  Copyright (c) 2015 Tim Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTLTripLogger : NSObject

@property (nonatomic) BOOL isLoggingEnabled;

+ (instancetype)sharedLogger;
- (void)startLogging;
- (void)stopLogging;

@end
