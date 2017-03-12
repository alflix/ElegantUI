//
//  MyLayer.m
//  AnimationDemo
//
//  Created by JieYuanZhuang on 15/3/15.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "MyLayer.h"

@implementation MyLayer

-(void)display{
    self.bounds=CGRectMake(50, 50, 50, 50);
    self.position=CGPointMake(50, 50);
    self.contents=(id)[UIImage imageNamed:@"photo"].CGImage;
    self.cornerRadius=5;
    self.masksToBounds=YES;
    self.borderWidth=3;
    self.borderColor=[UIColor brownColor].CGColor;
}



@end
