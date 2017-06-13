//
//  JJMultithreadingViewController.m
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/12.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "JJMultithreadingViewController.h"
#import "JJCustomOperation.h"

@interface JJMultithreadingViewController ()<JJCustomOperationDelegate>

@end

@implementation JJMultithreadingViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self testNSOperationQueue];
}

- (void)testInvocationOperation{
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(operation1Action) object:nil];
    [operation start];
    
    NSInvocationOperation *operation2 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(operation2Action) object:nil];
    [operation2 start];
    [operation setCompletionBlock:^{
        NSLog(@"完成");
    }];
}

- (void)operation1Action{
    NSLog(@"1，线程");
}

- (void)operation2Action{
    NSLog(@"5，线程：%@", [NSThread currentThread]);
}

- (void)testBlockOperation{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
        NSLog(@"1，线程");
    }];
    [operation addExecutionBlock:^() {
        NSLog(@"2，线程");
    }];
    [operation addExecutionBlock:^() {
        NSLog(@"3，线程");
    }];
    [operation addExecutionBlock:^() {
        NSLog(@"4，线程");
    }];
    // 开始执行任务
    [operation start];
}

- (void)testCustomOperation{
    JJCustomOperation *operation = [[JJCustomOperation alloc]initWithUrl:@"https://ws3.sinaimg.cn/large/006tKfTcgy1fgihaomf1xj30e80e8wej.jpg" delegate:self];
    [operation start];
}

- (void)downloadFinishWithImage:(UIImage *)image{
    NSLog(@"下载完成");
}

- (void)testNSOperationQueue{
    //主线程
//    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
//    [myQueue setMaxConcurrentOperationCount:1];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(operation1Action) object:nil];
    JJCustomOperation *customOperation = [[JJCustomOperation alloc]initWithUrl:@"https://ws3.sinaimg.cn/large/006tKfTcgy1fgihaomf1xj30e80e8wej.jpg" delegate:self];
    [customOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    
    [operation addDependency:customOperation];
    
    [myQueue addOperation:operation];
    [myQueue addOperation:customOperation];
    [myQueue addOperationWithBlock:^{
        //不会导致正在执行的 operation 在任务中途暂停
        [myQueue setSuspended:YES];
        NSLog(@"我在图片下载完成前显示的话就说明是异步的");
    }];
}

@end
