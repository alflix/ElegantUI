//
//  GCDViewController.m
//  MultithreadedProgramming
//
//  Created by JieYuanZhuang on 15/3/3.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "GCDViewController.h"
#define kURL @"http://c.hiphotos.baidu.com/image/pic/item/bd3eb13533fa828b5c141beefe1f4134970a5a8c.jpg"

@interface GCDViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSerialQueue];
    [self showImage];
    [self dispatchGroup];
    [self dispatchAfterSeconds];
    [self PerformingTaskOnlyOnce];
}

// 创建一个串行queue
-(void)createSerialQueue{
    dispatch_queue_t queue = dispatch_queue_create("queueName", NULL);
    
    dispatch_async(queue, ^{
        NSLog(@"开启了一个异步任务，当前线程：%@", [NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"开启了一个同步任务，当前线程：%@", [NSThread currentThread]);
    });
}

- (void)showImage{
    dispatch_queue_t concurrentQueue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        __block UIImage *image = nil;
        dispatch_sync(concurrentQueue, ^{//同步
            //download image
            NSLog(@"showImage thread is %@",[NSThread currentThread]);
            NSError *downError = nil;
            NSData *imageData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kURL]]
                                                      returningResponse:nil
                                                                  error:&downError];
            if (downError == nil&&imageData !=nil) {
                image = [UIImage imageWithData:imageData];
            }else if (downError != nil){
                NSLog(@"error happen:%@",downError);
            }else{
                NSLog(@"no data can get from the url");
            }
        });
//        dispatch_async(concurrentQueue, ^{//异步
//            //show image
//            if (image != nil){
//                [self.imageView setImage:image];
//                NSLog(@"image loading");
//            }else{
//                NSLog(@"image isn't download ,nothing to display");
//            }
//        });
        // 回到主线程显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
        
    });
}


-(void)dispatchGroup1{
    NSLog(@"group1");
}

-(void)dispatchGroup2{
    NSLog(@"group2");
}

-(void)dispatchGroup3{
    NSLog(@"group3");
}

-(void)dispatchGroup{
    dispatch_group_t taskGroup = dispatch_group_create();
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_group_async(taskGroup, mainQueue, ^{
        [self dispatchGroup1];
    });
    dispatch_group_async(taskGroup, mainQueue, ^{
        [self dispatchGroup2];
    });
    dispatch_group_async(taskGroup, mainQueue, ^{
        [self dispatchGroup3];
    });
    
    //dispatch_group_notify 以异步的方式工作。当 Dispatch Group中没有任何任务时会开始执行
    dispatch_group_notify(taskGroup, mainQueue, ^{
        [[[UIAlertView alloc]initWithTitle:@"Finish" message:@"all task are finished" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
    });
}


-(void)dispatchAfterSeconds{
    NSLog(@"current thread is %@",[NSThread currentThread]);
    double delayInSeconds = 4.0;
    //指定一个距离现在3秒的时间delayInNanoSeconds
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, (int64_t)delayInSeconds*NSEC_PER_SEC);
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^{
        NSLog(@"I'm showing");
    });
}

-(void)PerformingTaskOnlyOnce{
    void(^executeOnlyOnce)(void)=^{
        static NSUInteger numberOfEntries = 0;
        numberOfEntries++;
        NSLog(@"Executed %lu time(s)",(unsigned long)numberOfEntries);
    };
    
    static dispatch_once_t onceToken;
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_once(&onceToken, ^{
        dispatch_async(concurrentQueue, executeOnlyOnce);
    });
    dispatch_once(&onceToken, ^{
        dispatch_async(concurrentQueue, executeOnlyOnce);
    });
}


@end
