//
//  DelegateView.m
//  AnimationDemo
//
//  Created by JieYuanZhuang on 15/3/15.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//


#import "DelegateView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DelegateView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self.layer setNeedsDisplay];
  }
  return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
  UIGraphicsPushContext(ctx);
  [[UIColor lightGrayColor] set];
  UIRectFill(layer.bounds);

  UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
  UIColor *color = [UIColor blackColor];

  NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
  [style setAlignment:NSTextAlignmentCenter];
  
  NSDictionary *attribs = @{NSFontAttributeName: font,
                            NSForegroundColorAttributeName: color,
                            NSParagraphStyleAttributeName: style};

  NSAttributedString *
  text = [[NSAttributedString alloc] initWithString:@"孙悟空"
                                         attributes:attribs];

  [text drawInRect:CGRectInset([layer bounds], 10, 10)];
  UIGraphicsPopContext();
}




@end
