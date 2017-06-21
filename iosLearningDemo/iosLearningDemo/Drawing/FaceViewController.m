//
//  FaceViewController.m
//  DrawingDemo
//
//  Created by JieYuanZhuang on 15/3/13.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "FaceViewController.h"
#import "FaceView.h"


@interface FaceViewController ()

@end

@implementation FaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FaceView *faceView = [[FaceView alloc]initWithFrame:CGRectOffset(self.view.frame, 5, 10)];
    faceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:faceView];
}


@end
