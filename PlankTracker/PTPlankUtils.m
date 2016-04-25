//
//  PTPlankUtils.m
//  PlankTracker
//
//  Created by Diana Fisher on 4/24/16.
//  Copyright © 2016 Diana Fisher. All rights reserved.
//

#import "PTPlankUtils.h"

@implementation PTPlankUtils

// Converts NSTimeInterval into NSString with format MM:SS.m
+ (NSString *)stringFromElapsedTime:(NSTimeInterval)elapsedTime
{
    NSInteger minutes = (NSInteger)elapsedTime / 60;
    NSInteger seconds = (NSInteger)elapsedTime % 60;
    
    NSInteger millis = (NSInteger)(elapsedTime * 10) % 10;
    
    NSString *timeStr = [NSString stringWithFormat:@"%02lu:%02lu.%lu",minutes, seconds, millis];
    return timeStr;
}

@end
