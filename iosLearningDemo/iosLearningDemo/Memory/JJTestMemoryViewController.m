//
//  JJTestMemoryViewController.m
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/11.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "JJTestMemoryViewController.h"

@interface JJTestMemoryViewController ()

@property (nonatomic, copy) void(^block)();

@end

@implementation JJTestMemoryViewController

- (void)dealloc{
    NSLog(@" JJTestMemoryViewController delloc ");
    //确保没有内存泄漏问题，导致 dealloc 不执行，从而导致 removeObserver 不执行。
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad{
    __weak typeof(self) weakSelf = self;
    self.block = ^{
        __strong typeof(self) strongSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@", strongSelf.title);
        });
    };
    self.block();
}

- (void)registNotification{
    [[NSNotificationCenter defaultCenter] addObserverForName:@"JJMemoryViewControllerNotification"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * notification) {
                                                      self.title = notification.userInfo[@"title"];
                                                  }];
}

@end
