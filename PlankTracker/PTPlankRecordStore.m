//
//  PTPlankRecordStore.m
//  PlankTracker
//
//  Created by Diana Fisher on 4/24/16.
//  Copyright © 2016 Diana Fisher. All rights reserved.
//

#import "PTPlankRecordStore.h"

#import "PTPlankRecord.h"

@interface PTPlankRecordStore ()

@property (nonatomic, strong) NSMutableArray *records;

@end

@implementation PTPlankRecordStore

#pragma mark Singleton sharedStore
+ (PTPlankRecordStore *)sharedStore
{
    static PTPlankRecordStore *sharedStore = nil;
    
    // Make sure the sharedStore is initialized only once.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] init];
    });
    return sharedStore;
}

#pragma mark Initialization
- (instancetype)init {
    self = [super init];
    if (self) {
        // Load the records from the archive.
        NSString *path = [self recordArchivePath];
        _records = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!_records) {
            _records = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

// Returns the path of the archive file.
- (NSString *)recordArchivePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"plankTracker.archive"];
    return filePath;
}

// Saves all records to the archive file.
- (BOOL)saveRecords {
    NSString *path = [self recordArchivePath];
    return [NSKeyedArchiver archiveRootObject:_records toFile:path];
}

// Creates a new record and adds it to the records array.  Does not save to the archive.
- (PTPlankRecord *)createRecordWithDate:(NSDate *)date withElapsedTime:(NSTimeInterval)elapsedTime;
{
    PTPlankRecord *record = [[PTPlankRecord alloc] initWithDate:date withElapsedTime:elapsedTime];
    [_records addObject:record];
    return record;
}

// Removes the specified record from the records array.
- (void)removeRecord:(PTPlankRecord *)plankRecord
{
    [_records removeObject:plankRecord];
}

- (PTPlankRecord *)recordWithLongestElapsedTime
{
    // Sort the records array by elapsedTime.
    NSSortDescriptor *timeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"elapsedTime" ascending:NO];
    NSArray *sortDescriptors = @[timeDescriptor];
    NSArray *sortedArray = [_records sortedArrayUsingDescriptors:sortDescriptors];
    return [sortedArray firstObject];
}


@end
