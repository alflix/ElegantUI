//
//  JJCoreTextViewController.m
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/24.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "JJCoreTextViewController.h"
#import "JJDisplayView.h"
#import "UIView+frameAdjust.h"
#import "OutlineTextView.h"
#import <YYKit.h>

@interface JJCoreTextViewController ()

@end

@implementation JJCoreTextViewController

- (void)viewDidLoad{
    [super viewDidLoad];
//    JJDisplayView *view = [[JJDisplayView alloc]initWithFrame:CGRectMake(0, 64, 250, self.view.height)];
    
//    OutlineTextView *textView = [[OutlineTextView alloc]initWithFrame:CGRectMake(0, 64, 250, self.view.height)];
//    [textView setText:@"测试dd"];
    
    YYTextView *textView = [[YYTextView alloc]initWithFrame:CGRectMake(0, 64, 250, self.view.height)];
    textView.verticalForm = YES;
    textView.text = @"兔子和乌龟要赛跑了。小鸟一叫：“一二三！”兔子就飞快地跑了出去。乌龟一步一步地向前爬。";
    [self.view addSubview:textView];
}

@end
