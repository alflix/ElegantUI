//
//  JJRuntimeViewController.m
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/13.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "JJRuntimeViewController.h"
#import "JJRuntimeModel.h"
#import "JJRuntimeModel+JJModify.h"

@interface JJRuntimeViewController ()

@end

@implementation JJRuntimeViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    JJRuntimeModel *model = [JJRuntimeModel new];
//    NSString *modifyName = model.modifyName;
    NSLog(@"%@",[JJRuntimeModel getSendMessage]);
    [model sendMessage];
    
    //调用私有消息
//    if ([model respondsToSelector:@selector(p_sendMessage)]) {
//        [model performSelector:@selector(p_sendMessage) withObject:nil];
//    }
//    
//    //调用没有声明过的消息
//    if ([model respondsToSelector:@selector(test)]) {
//        [model performSelector:@selector(test) withObject:nil];
//    }
//    
//    if ([model respondsToSelector:@selector(forward)]) {
//        [model performSelector:@selector(forward) withObject:nil];
//    }
//    
//    [model performSelector:@selector(xxxxxx) withObject:nil];
}

@end
