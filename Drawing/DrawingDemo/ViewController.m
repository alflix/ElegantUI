//
//  ViewController.m
//  DrawingDemo
//
//  Created by JieYuanZhuang on 15/3/12.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "ViewController.h"
#import "RectView.h"
#import "RetangleView.h"
#import "CurveView.h"
#import "QuadCurveView.h"
#import "CircleView.h"
#import "FlowerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RectView *rectView = [[RectView alloc]initWithFrame:CGRectMake(20, 20, 160, 160)];
    RetangleView *retangleView = [[RetangleView alloc]initWithFrame:CGRectMake(200, 20, 160, 160)];
    
    QuadCurveView *quadCurveView = [[QuadCurveView alloc]initWithFrame:CGRectMake(20, 200, 160, 160)];
    CurveView *curveView = [[CurveView alloc]initWithFrame:CGRectMake(200, 200, 160, 160)];
    CircleView *circleView = [[CircleView alloc]initWithFrame:CGRectMake(20, 380, 160, 160)];
    FlowerView *flowerView = [[FlowerView alloc]initWithFrame:CGRectMake(200, 380, 160, 160)];
    
    
    [self.view addSubview:rectView];
    [self.view addSubview:retangleView];
    
    [self.view addSubview:curveView];
    [self.view addSubview:quadCurveView];
    [self.view addSubview:circleView];
    [self.view addSubview:flowerView];
}



@end
