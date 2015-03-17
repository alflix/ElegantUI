//
//  CircleViewController.m
//  TextKitDemo
//
//  Created by JieYuanZhuang on 15/3/10.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "CircleViewController.h"
#import "CircleTextContainer.h"

@interface CircleViewController ()

@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample.txt" ofType:nil];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    [style setAlignment:NSTextAlignmentJustified];
    
    NSTextStorage *text = [[NSTextStorage alloc] initWithString:string
                                                     attributes:@{
                                                                  NSParagraphStyleAttributeName: style,
                                                                  NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2]
                                                                  }];
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    [text addLayoutManager:layoutManager];
    
    CGRect textViewFrame = CGRectMake(20, 20, 280, 280);
    CircleTextContainer *textContainer = [[CircleTextContainer alloc] initWithSize:textViewFrame.size];
    [textContainer setExclusionPaths:@[ [UIBezierPath bezierPathWithOvalInRect:CGRectMake(80, 120, 50, 50)]]];
    
    [layoutManager addTextContainer:textContainer];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame
                                               textContainer:textContainer];
    textView.allowsEditingTextAttributes = YES;
    textView.scrollEnabled = NO;
    textView.editable = NO;
    
    [self.view addSubview:textView];
}


@end
