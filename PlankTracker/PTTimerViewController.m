//
//  PTTimerViewController.m
//  PlankTracker
//
//  Created by Diana Fisher on 4/24/16.
//  Copyright © 2016 Diana Fisher. All rights reserved.
//

@import AVFoundation;

#import "PTTimerViewController.h"

#import "PTStopwatch.h"
#import "PTPlankRecord.h"
#import "PTPlankRecordStore.h"
#import "PTPlankUtils.h"
#import "PTButtonView.h"
#import "PTRecordTableViewController.h"

@interface PTTimerViewController ()

@property (nonatomic, strong) PTStopwatch *stopwatch;
@property (nonatomic, strong) NSArray *plankRecords;
@property (nonatomic) BOOL announceTime;
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;

@property (weak, nonatomic) IBOutlet UILabel *elapsedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longestTimeLabel;
@property (weak, nonatomic) IBOutlet PTButtonView *resetButton;

@end

// UIStoryboardSegue identifier
static NSString *const ShowLogSegueIdentifier = @"ShowLog";

// Create a static value that stores its own pointer and uses it as a KVO context.
static void * contextForKVO = &contextForKVO;


@implementation PTTimerViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Initialize a PTStopwatch object.
    self.stopwatch = [[PTStopwatch alloc] init];
    
    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    
    // Get the longest time.
    PTPlankRecord *plankRecord = [[PTPlankRecordStore sharedStore] recordWithLongestElapsedTime];
    if (plankRecord) {
        NSString *timeStr = [PTPlankUtils stringFromElapsedTime:plankRecord.elapsedTime];
        self.longestTimeLabel.text = [NSString stringWithFormat:@"Longest: %@", timeStr];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AnnounceTimeOn"]) {
        self.announceTime = YES;
    }
    
    // Observe when the seconds property changes on the PTStopwatch object.
    [self.stopwatch addObserver:self
                     forKeyPath:@"seconds"
                        options:NSKeyValueObservingOptionNew
                        context:&contextForKVO];
    
    // Observe when the minutes property changes on the PTStopwatch object.
    [self.stopwatch addObserver:self
                     forKeyPath:@"minutes"
                        options:NSKeyValueObservingOptionNew
                        context:&contextForKVO];
    
    // Observe when the user changes the user defaults setting.
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"AnnounceTimeOn"
                                               options:NSKeyValueObservingOptionNew
                                               context:&contextForKVO];
}

- (void)dealloc
{
    // Remove KVO observers.
    [self.stopwatch removeObserver:self forKeyPath:@"seconds"];
    [self.stopwatch removeObserver:self forKeyPath:@"minutes"];
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"AnnounceTimeOn"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    // Check the context to see if this change is for us.
    if (context != &contextForKVO) {
        // It's not, so pass it on to the superclass.
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        
    } else {
        // Handle the change.
        if ([keyPath isEqualToString:@"seconds"]) {
            NSString *newValue = [change objectForKey:NSKeyValueChangeNewKey];
            NSInteger seconds = [newValue integerValue];
            if (seconds > 0 && seconds % 10 == 0) {
                [self speakTimeWithValue:seconds withUnit:@"seconds"];
            }
        } else if ([keyPath isEqualToString:@"minutes"]) {
            NSString *newValue = [change objectForKey:NSKeyValueChangeNewKey];
            NSInteger minutes = [newValue integerValue];
            
            if (minutes > 1) {
                [self speakTimeWithValue:minutes withUnit:@"minutes"];
            } else {
                [self speakTimeWithValue:minutes withUnit:@"minute"];
            }
        } else if ([keyPath isEqualToString:@"AnnounceTimeOn"]) {
            // The user has changed the setting, so update our property.
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AnnounceTimeOn"]) {
                self.announceTime = YES;
            }
        }
    }
}

#pragma mark - IBAction methods

- (IBAction)startButtonPressed:(id)sender {
    
    PTButtonView *button = (PTButtonView *)sender;
    if ([button isStartButton]) {
        
        // Schedule an NSTimer to trigger every 0.1 second.
        // NSTimer will retain its target.  It will release its target when it is invalidated.
        [NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:self
                                       selector:@selector(updateElapsedTimeLabel:)
                                       userInfo:nil
                                        repeats:YES];
        
        // Start the stopwatch.
        [self.stopwatch start];
        
        // Disable the reset button.
        [self.resetButton setEnabled:NO];

        // Swap the start button with the stop button.
        UIColor *stopColor = [UIColor redColor];
        
        [button setStrokeColor:stopColor];
        [button setTitle:@"Stop" forState:UIControlStateNormal];
        [button setTitleColor:stopColor forState:UIControlStateNormal];
        button.startButton = NO;
        
        // Redraw the button.
        [button setNeedsDisplay];
        
        
    } else {
        
        // Hold on to the time value before we reset the stopwatch.
        NSTimeInterval elapsed = self.stopwatch.time;
        
        // Stop the stopwatch.
        [self.stopwatch stop];
        
        // Enable the reset button.
        [self.resetButton setEnabled:YES];
        
        // Swap the stop button with the start button.
        UIColor *startColor = [UIColor colorWithRed:58/255.0 green:162/255.0 blue:112/255.0 alpha:1.0];
        
        [button setStrokeColor:startColor];
        [button setTitle:@"Start" forState:UIControlStateNormal];
        [button setTitleColor:startColor forState:UIControlStateNormal];
        button.startButton = YES;
        
        // Redraw the button.
        [button setNeedsDisplay];
        
        // Ask the user if they wish to save the time in the log.
        [self presentAlertControllerForTime:elapsed];
    }
}

- (IBAction)resetButtonPressed:(id)sender {
    
    // Stop the stopwatch if it is running.
    [self.stopwatch reset];
    
    // Update the UI.
    self.elapsedTimeLabel.text = [self.stopwatch elapsedTimeAsString];
}

- (void)presentAlertControllerForTime:(NSTimeInterval)time
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Save Time"
                                                                             message:@"Save this time in the log?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              // Create a record.
                                                              [[PTPlankRecordStore sharedStore] createRecordWithDate:[NSDate date]
                                                                                                     withElapsedTime:time];
                                                              
                                                              // Update the longest time, if needed.
                                                              
                                                              // Get the longest time.
                                                              PTPlankRecord *plankRecord = [[PTPlankRecordStore sharedStore] recordWithLongestElapsedTime];
                                                              if (plankRecord) {
                                                                  NSString *timeStr = [PTPlankUtils stringFromElapsedTime:plankRecord.elapsedTime];
                                                                  self.longestTimeLabel.text = [NSString stringWithFormat:@"Longest: %@", timeStr];
                                                              }
                                                          }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:alertController completion:nil];
    }];
    
    [alertController addAction:saveAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark

- (void)speakTimeWithValue:(NSInteger)value withUnit:(NSString *)unit
{
    // If the user has turned off time announcements, simply return.
    if (self.announceTime == NO) {
        return;
    }
    
    NSString *string = [NSString stringWithFormat:@"%lu %@", value, unit];
    
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:string];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    
    [self.synthesizer speakUtterance:utterance];
}

- (void)updateElapsedTimeLabel:(NSTimer *)timer
{
    if ([self.stopwatch isRunning]) {
        self.elapsedTimeLabel.text = [self.stopwatch elapsedTimeAsString];
        
    } else {
        [timer invalidate];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (![segue.destinationViewController isKindOfClass:[PTRecordTableViewController class]]) {
        return;
    }
    
    PTRecordTableViewController *tableViewController = segue.destinationViewController;
    tableViewController.title = @"Plank Times";
}



@end
