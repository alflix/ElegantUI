//
//  ViewController.m
//  MultithreadedProgramming
//
//  Created by JieYuanZhuang on 15/3/3.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "ViewController.h"
#define kURL @"http://c.hiphotos.baidu.com/image/pic/item/bd3eb13533fa828b5c141beefe1f4134970a5a8c.jpg"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *urlImageView;
@end

@implementation ViewController

//NSThread实例
- (void)viewDidLoad {
    [super viewDidLoad];
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(downloadImage:) object:kURL];
    [thread start];
}


-(void)downloadImage:(NSString *) url{
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [[UIImage alloc]initWithData:data];
    if(image == nil){
        
    }else{
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
    }
}

-(void)updateUI:(UIImage*) image{
    self.urlImageView.image = image;
}


@end
