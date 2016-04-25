//
//  PTPlankRecordStore.h
//  PlankTracker
//
//  Created by Diana Fisher on 4/24/16.
//  Copyright © 2016 Diana Fisher. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTPlankRecord;

@interface PTPlankRecordStore : NSObject

@property (nonatomic, strong, readonly) NSArray *records;

#pragma mark Class methods

// Returns the Singleton records store object.
+ (PTPlankRecordStore *)sharedStore;

#pragma mark Instance methods

// Creates and returns a new PTPlankRecord object.  Does not save to the archive.
- (PTPlankRecord *)createRecordWithDate:(NSDate *)date withElapsedTime:(NSTimeInterval)elapsedTime;

/** 
 Removes the specified record from the records array.  
 Does not remove from the archive.  
 A separate call to saveRecords is required to update the archive.
 */
- (void)removeRecord:(PTPlankRecord *)plankRecord;

// Saves all records in the records array to the archive.
- (BOOL)saveRecords;

// Returns the record with the longest duration.
- (PTPlankRecord *)recordWithLongestElapsedTime;



@end
