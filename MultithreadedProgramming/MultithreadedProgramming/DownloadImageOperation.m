//
//  DownloadImageOperation.m
//  MultithreadedProgramming
//
//  Created by JieYuanZhuang on 15/3/3.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "DownloadImageOperation.h"

@implementation DownloadImageOperation

@synthesize delegate = _delegate;
@synthesize imageUrl = _imageUrl;

// 初始化
- (id)initWithUrl:(NSString *)url delegate:(id<DownloadOperationDelegate>)delegate {
    if (self = [super init]) {
        self.imageUrl = url;
        self.delegate = delegate;
    }
    return self;
}

// 执行主任务
- (void)main {
    // 新建一个自动释放池，如果是异步执行操作，那么将无法访问到主线程的自动释放池
    @autoreleasepool {
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
        
        if ([self.delegate respondsToSelector:@selector(downloadFinishWithImage:)]) {
            // 把图片数据传回到主线程
            [(NSObject *)self.delegate performSelectorOnMainThread:@selector(downloadFinishWithImage:) withObject:image waitUntilDone:NO];
        }
    }
}

@end
