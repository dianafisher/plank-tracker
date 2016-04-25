//
//  PTStopwatch.m
//  PlankTracker
//
//  Created by Diana Fisher on 4/24/16.
//  Copyright © 2016 Diana Fisher. All rights reserved.
//

#import "PTStopwatch.h"

@interface PTStopwatch ()

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, assign) NSTimeInterval elapsedTime;
@property (nonatomic, assign) NSTimeInterval totalTime;

@end

@implementation PTStopwatch

- (void)start
{
    self.startTime = [NSDate date];  // current date and time.
}

- (void)stop
{
    self.startTime = nil;
    self.elapsedTime = 0;
}

- (void)reset
{
    self.startTime = nil;
    self.elapsedTime = 0;
    self.totalTime = 0;
}

- (BOOL)isRunning
{
    return self.startTime != nil;
}

- (NSTimeInterval)time
{
    return self.totalTime;
}

// Called every tick.
- (NSString *)elapsedTimeAsString
{
    if (self.startTime == nil) {
        return @"00:00.0";
    }
    
    NSTimeInterval previous = self.elapsedTime;
    NSLog(@"previous: %g", previous);
    
    self.elapsedTime = [self.startTime timeIntervalSinceNow] * -1.0;
    self.totalTime += (self.elapsedTime - previous);
    
    NSLog(@"elapsedTime: %g", self.elapsedTime);
    NSLog(@"totalTime: %g", self.totalTime);
    
    NSInteger minutes = (NSInteger)self.totalTime / 60;
    NSInteger seconds = (NSInteger)self.totalTime % 60;
    
    if (self.seconds != seconds) {
        self.seconds = seconds;
    }
    
    if (self.minutes != minutes) {
        self.minutes = minutes;
    }
    
    NSInteger millis = (NSInteger)(self.totalTime * 10) % 10;
    
    NSString *timeStr = [NSString stringWithFormat:@"%02lu:%02lu.%lu",minutes, seconds, millis];
    return timeStr;
}

@end
