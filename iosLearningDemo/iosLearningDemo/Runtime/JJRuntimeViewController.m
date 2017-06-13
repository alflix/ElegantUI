//
//  JJRuntimeViewController.m
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/13.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "JJRuntimeViewController.h"
#import "JJRuntimeModel.h"
#import <objc/Runtime.h>

@interface JJRuntimeViewController ()

@end

@implementation JJRuntimeViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [JJRuntimeModel sendMessage];
    
    JJRuntimeModel *model = [JJRuntimeModel new];
    
    if ([model respondsToSelector:@selector(p_ddd)]) {
        [model performSelector:@selector(p_ddd) withObject:nil];
    }
    [model sendMessage];
}

@end
