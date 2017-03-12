//
//  OperationViewController.m
//  MultithreadedProgramming
//
//  Created by JieYuanZhuang on 15/3/3.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "OperationViewController.h"
#define kURL @"http://c.hiphotos.baidu.com/image/pic/item/bd3eb13533fa828b5c141beefe1f4134970a5a8c.jpg"

@interface OperationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end

@implementation OperationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSynchronouslyOperations];
    [self createAsynchronouslyOperations];
    [self BlockOperation];
    [self DependencyOperation];
}

//同步执行Operations
- (void)createSynchronouslyOperations {
    NSNumber *simpleObject = [NSNumber numberWithInteger:123];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(operationEntry:) object:simpleObject];
    [operation start];
}

-(void)operationEntry:(id)paramObject{
    NSLog(@"***Parameter Object = %@",paramObject);
    NSLog(@"***Main Thread = %@",[NSThread mainThread]);
    NSLog(@"***current Thread = %@",[NSThread currentThread]);
}

//并发执行Operations
- (void)createAsynchronouslyOperations{
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self
                                                                           selector:@selector(downloadImage:)
                                                                             object:kURL];
    [operation setCompletionBlock:^() {
        NSLog(@"下载完成");
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
}

-(void)downloadImage:(NSString *)url{
    UIImage * image = [[UIImage alloc]initWithData:[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]]];
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
}
-(void)updateUI:(UIImage*) image{
    self.image.image = image;
}

//并发地执行一个或多个block对象
-(void)BlockOperation{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
        NSLog(@"1，线程：%@", [NSThread currentThread]);
    }];
    
    [operation addExecutionBlock:^() {
        NSLog(@"2，线程：%@", [NSThread currentThread]);
    }];
    
    [operation addExecutionBlock:^() {
        NSLog(@"3，线程：%@", [NSThread currentThread]);
    }];
    
    [operation addExecutionBlock:^() {
        NSLog(@"4，线程：%@", [NSThread currentThread]);
    }];  
    
    // 开始执行任务  
    [operation start];
}

//依赖关系：在某个任务完成后执行特定的任务
-(void)firstOperationEntry:(id)paramObject{
    NSLog(@"***Parameter Object = %@",paramObject);
    NSLog(@"***Main Thread = %@",[NSThread mainThread]);
    NSLog(@"***current Thread = %@",[NSThread currentThread]);
}

-(void)secondOperationEntry:(id)paramObject{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"***Parameter Object = %@",paramObject);
    NSLog(@"***Main Thread = %@",[NSThread mainThread]);
    NSLog(@"***current Thread = %@",[NSThread currentThread]);
}


-(void)DependencyOperation{
    NSString *firstNumber = @"1";
    NSString *secondNumber = @"2";
    NSInvocationOperation *firstOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(firstOperationEntry:) object:firstNumber];
    NSInvocationOperation *secondOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(secondOperationEntry:) object:secondNumber];
    [firstOperation addDependency:secondOperation];//与之相反的是removeDependency
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc]init];
    [operationQueue addOperation:firstOperation];
    [operationQueue addOperation:secondOperation];
    
    NSLog(@"******Main Thread is here");
}


@end