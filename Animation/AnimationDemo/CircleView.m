//
//  CircleView.m
//  AnimationDemo
//
//  Created by JieYuanZhuang on 15/3/15.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.opaque = NO;
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  [[UIColor redColor] setFill];
  [[UIBezierPath bezierPathWithOvalInRect:self.bounds] fill];
}


@end
