//
//  RectView.m
//  DrawingDemo
//
//  Created by JieYuanZhuang on 15/3/12.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "RectView.h"

@implementation RectView

- (void)drawRect:(CGRect)rect
{
    UIColor *color = [UIColor colorWithRed:0 green:0.7 blue:0 alpha:1];
    [color set];
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 5.0;
    
    aPath.lineCapStyle = kCGLineCapRound;
    aPath.lineJoinStyle = kCGLineCapRound;
    
    // 起点
    [aPath moveToPoint:CGPointMake(60.0, 10.0)];
    
    // 绘制线条
    [aPath addLineToPoint:CGPointMake(120.0, 40.0)];
    [aPath addLineToPoint:CGPointMake(100, 140)];
    [aPath addLineToPoint:CGPointMake(40.0, 140)];
    [aPath addLineToPoint:CGPointMake(10.0, 40.0)];
    [aPath closePath];//第五条线通过调用closePath方法得到的
    
    //根据坐标点连线
    [aPath stroke];
    [aPath fill];
}
@end
