//
//  PTPlankRecord.m
//  PlankTracker
//
//  Created by Diana Fisher on 4/24/16.
//  Copyright © 2016 Diana Fisher. All rights reserved.
//

#import "PTPlankRecord.h"

@implementation PTPlankRecord

static NSString * const kRecordDate = @"recordDate";
static NSString * const kElapsedTime = @"elapsedTime";

#pragma mark - NSCoding protocol methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSDate *date = [aDecoder decodeObjectForKey:kRecordDate];
    double elapsedTime = [aDecoder decodeDoubleForKey:kElapsedTime];
    
    // Call the designated initializer.
    return [self initWithDate:date withElapsedTime:elapsedTime];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.recordDate forKey:kRecordDate];
    [aCoder encodeDouble:self.elapsedTime forKey:kElapsedTime];
}

#pragma mark - Initialization

- (instancetype)initWithDate:(NSDate *)date withElapsedTime:(NSTimeInterval)elapsedTime
{
    self = [super init];
    if (self) {
        _recordDate = date;
        _elapsedTime = elapsedTime;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithDate:[NSDate date] withElapsedTime:0];
}

#pragma mark - Description

- (NSString *)description
{
    NSLog(@"%@", [self class]);
    return [NSString stringWithFormat:@"<PTPlankRecord: %p> %@ %f", self, _recordDate, _elapsedTime];
}

@end

