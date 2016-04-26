//
//  PTSettingsTableViewController.m
//  PlankTracker
//
//  Created by Diana Fisher on 4/25/16.
//  Copyright © 2016 Diana Fisher. All rights reserved.
//

#import "PTSettingsTableViewController.h"

@implementation PTSettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the value of the switch based on the user defaults setting.
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AnnounceTimeOn"]) {
        self.announceTimeSwitch.on = YES;
    } else {
        self.announceTimeSwitch.on = NO;
    }
    
    [self.announceTimeSwitch addTarget:self action:@selector(toggleAnnounceTime:) forControlEvents:(UIControlEventValueChanged | UIControlEventTouchDragInside)];
}

- (void)toggleAnnounceTime:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL announceTime = [(UISwitch *)sender isOn];
    
    if (announceTime) {
        // The user wants to have time announcements.
        [defaults setBool:YES forKey:@"AnnounceTimeOn"];
    } else {
        [defaults setBool:NO forKey:@"AnnounceTimeOn"];        
    }
}

@end
