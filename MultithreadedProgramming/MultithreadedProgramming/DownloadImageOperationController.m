//
//  DownloadImageOperationController.m
//  MultithreadedProgramming
//
//  Created by JieYuanZhuang on 15/3/3.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "DownloadImageOperationController.h"
#import "DownloadImageOperation.h"

#define kURL @"http://c.hiphotos.baidu.com/image/pic/item/bd3eb13533fa828b5c141beefe1f4134970a5a8c.jpg"

@interface DownloadImageOperationController ()<DownloadOperationDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *image;
@end

@implementation DownloadImageOperationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    DownloadImageOperation *customOperation = [[DownloadImageOperation alloc]initWithUrl:kURL delegate:self];
    [queue addOperation:customOperation];
    
}

-(void)downloadFinishWithImage:(UIImage *)image{
    self.image.image = image;
}

@end
