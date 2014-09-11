//
//  ViewController.m
//  bezier-clock
//
//  Created by Alexey Yukin on 11.09.14.
//  Copyright (c) 2014 Simbirsoft Ltd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, copy) void (^clockUpdateBlock)(BOOL);

@end

@implementation ViewController

- (void) viewDidLoad
{
    [super viewDidLoad];

    // setup appearance
    self.view.backgroundColor = [UIColor blackColor];

    [_digitViews setValue:[UIColor colorWithRed:240.0/255.0 green:100.0/255.0 blue:0.0 alpha:1.0] forKey:@"color"];
    [_digitViews setValue:@(3.0) forKey:@"thickness"];

    // sort views
    _digitViews = [_digitViews sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];

    // update loop
    __weak __typeof(self) weakSelf = self;

    self.clockUpdateBlock = ^(BOOL animated)
    {
        NSDateComponents* components = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];

        [weakSelf.digitViews[0] setDigit:(components.hour   / 10) animated:animated];
        [weakSelf.digitViews[1] setDigit:(components.hour   % 10) animated:animated];
        [weakSelf.digitViews[2] setDigit:(components.minute / 10) animated:animated];
        [weakSelf.digitViews[3] setDigit:(components.minute % 10) animated:animated];
        [weakSelf.digitViews[4] setDigit:(components.second / 10) animated:animated];
        [weakSelf.digitViews[5] setDigit:(components.second % 10) animated:animated];

        CFAbsoluteTime time  = CFAbsoluteTimeGetCurrent();
        CFAbsoluteTime delta = ceil(time) - time - [DigitView animationDuration];

        while (delta < 0.0)
        {
            delta = delta + 1.0;
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void)
        {
            if (weakSelf.clockUpdateBlock)
            {
                weakSelf.clockUpdateBlock(YES);
            }
        });
    };

    _clockUpdateBlock(NO);
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

@end
