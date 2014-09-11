//
//  DigitView.h
//  bezier-clock
//
//  Created by Alexey Yukin on 11.09.14.
//  Copyright (c) 2014 Simbirsoft Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DigitView : UIView

@property (strong, nonatomic) UIColor*   color;
@property (assign, nonatomic) NSUInteger digit;
@property (assign, nonatomic) CGFloat    thickness;

- (void) setDigit:(NSUInteger)digit animated:(BOOL)animated;

+ (NSTimeInterval) animationDuration;

@end
