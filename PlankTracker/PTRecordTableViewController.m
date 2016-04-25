//
//  PTRecordTableViewController.m
//  PlankTracker
//
//  Created by Diana Fisher on 4/24/16.
//  Copyright © 2016 Diana Fisher. All rights reserved.
//

#import "PTRecordTableViewController.h"

#import "PTPlankRecord.h"
#import "PTPlankRecordStore.h"
#import "PTPlankUtils.h"

@interface PTRecordTableViewController ()

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation PTRecordTableViewController

// UITableViewCell resuse identifier (set up in Interface Builder)
static NSString * const RecordCellReuseIdentifier = @"RecordCell";

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PTPlankRecordStore *recordStore = [PTPlankRecordStore sharedStore];
    return [[recordStore records] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue a reusable table view cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecordCellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:RecordCellReuseIdentifier];
    }
    
    // Get the record at this index.
    PTPlankRecord *record = [[[PTPlankRecordStore sharedStore] records] objectAtIndex:[indexPath row]];
    
    // Set the record data on the table view cell.
    NSString *timeStr = [PTPlankUtils stringFromElapsedTime:record.elapsedTime];
    cell.textLabel.text = timeStr;
    
    NSString *dateString = [self.formatter stringFromDate:record.recordDate];
    cell.detailTextLabel.text = dateString;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        PTPlankRecord *record = [[[PTPlankRecordStore sharedStore] records] objectAtIndex:[indexPath row]];
        
        // Remove the record from the records array.
        [[PTPlankRecordStore sharedStore] removeRecord:record];
        
        // Delete the row from the table view.
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Helper Methods

// Reuse the NSDateFormatter since it is slow to initialize.
- (NSDateFormatter *)formatter {
    if (! _formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateStyle:NSDateFormatterLongStyle];  // “November 23, 1937”
        [_formatter setTimeStyle:NSDateFormatterShortStyle]; // "3:30 PM"
    }
    return _formatter;
}


@end
