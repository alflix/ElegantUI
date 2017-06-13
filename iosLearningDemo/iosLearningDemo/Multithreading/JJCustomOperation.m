//
//  JJCustomOperation.m
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/12.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "JJCustomOperation.h"

@implementation JJCustomOperation{
    BOOL executing;
    BOOL finished;
    NSRecursiveLock *_lock;
}

- (id)initWithUrl:(NSString *)url delegate:(id<JJCustomOperationDelegate>)delegate {
    if (self = [super init]) {
        _imageUrl = url;
        _delegate = delegate;
        _lock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

- (void)start {
    [_lock lock];
    if ([self isCancelled]){
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }else if ([self isReady]){
        [self willChangeValueForKey:@"isFinished"];
        finished  = NO;
        [self didChangeValueForKey:@"isFinished"];
        
        [self willChangeValueForKey:@"isExecuting"];
        executing = YES;
        [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
        [self didChangeValueForKey:@"isExecuting"];
    }
    
    [_lock unlock];
}

// 执行主任务
- (void)main {
    // 新建一个自动释放池，如果是异步执行操作，那么将无法访问到主线程的自动释放池
    @autoreleasepool {
        //NSOperation 的-cancel 状态调用时 , 会通过 KVO 通知 isCancelled 的 keyPath 来修改 isCancelled 属性的返回值
        if (self.isCancelled) return;
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]];
        if (self.isCancelled) {
            imageData = nil;
            return;
        }
        // 初始化图片
        UIImage *image = [UIImage imageWithData:imageData];
        if (self.isCancelled) {
            image = nil;
            return;
        }
        [self finishOperation];
        if ([self.delegate respondsToSelector:@selector(downloadFinishWithImage:)]) {
            // 把图片数据传回到主线程
            [(NSObject *)self.delegate performSelectorOnMainThread:@selector(downloadFinishWithImage:) withObject:image waitUntilDone:NO];
        }
    }
}

- (void)finishOperation{
    [_lock lock];
    [self willChangeValueForKey:@"isExecuting"];
    executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self willChangeValueForKey:@"isFinished"];
    finished  = YES;
    [self didChangeValueForKey:@"isFinished"];
    [_lock unlock];
}


- (BOOL)isAsynchronous {
    return YES;
}

- (BOOL) isFinished{
    NSLog(@"is finished：%@",@(finished));
    return finished;
}

- (BOOL) isExecuting{
    NSLog(@"is executing");
    return executing;
}

@end
