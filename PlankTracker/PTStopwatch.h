//
//  PTStopwatch.h
//  PlankTracker
//
//  Created by Diana Fisher on 4/24/16.
//  Copyright © 2016 Diana Fisher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTStopwatch : NSObject

@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, assign) NSInteger minutes;
@property (nonatomic, assign, readonly) NSTimeInterval time;

- (void)start;
- (void)stop;
- (void)reset;
- (BOOL)isRunning;
- (NSString *)elapsedTimeAsString;

@end
