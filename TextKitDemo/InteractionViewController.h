//
//  TKDInteractionViewController.h
//  TextKitDemo
//
//  Created by Max Seelemann on 29.09.13.
//  Copyright (c) 2013 Max Seelemann. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircleView;

@interface InteractionViewController : UIViewController

@property (weak, nonatomic) IBOutlet CircleView *circleView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end
