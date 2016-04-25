//
//  PTPlankRecord.h
//  PlankTracker
//
//  Created by Diana Fisher on 4/24/16.
//  Copyright © 2016 Diana Fisher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTPlankRecord : NSObject

@property (nonatomic, strong) NSDate *recordDate;
@property (nonatomic, assign) NSTimeInterval elapsedTime;

#pragma mark Designated Initializer

- (instancetype)initWithDate:(NSDate *)date withElapsedTime:(NSTimeInterval)elapsedTime;

@end
