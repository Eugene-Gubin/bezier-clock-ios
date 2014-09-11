//
//  ViewController.h
//  bezier-clock
//
//  Created by Alexey Yukin on 11.09.14.
//  Copyright (c) 2014 Simbirsoft Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DigitView.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(DigitView) NSArray* digitViews;

@end
