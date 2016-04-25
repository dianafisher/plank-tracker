//
//  PTPlankUtils.h
//  PlankTracker
//
//  Created by Diana Fisher on 4/24/16.
//  Copyright © 2016 Diana Fisher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTPlankUtils : NSObject


// Returns a string with format MM:SS.m
+ (NSString *)stringFromElapsedTime:(NSTimeInterval)time;

@end
