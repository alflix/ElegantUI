//
//  CustomView.m
//  CommunicationPatterns
//
//  Created by JieYuanZhuang on 15/2/27.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor lightGrayColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
        button.backgroundColor = [UIColor blackColor];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}


-(void)click:(UIButton *)sender{
    //delegate
    if ([self.delegate respondsToSelector:@selector(CustomView:didClickButton:)]) {
        [self.delegate CustomView:self didClickButton:sender];
    }
    //Notification
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"click" forKey:@"buttonKey"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"buttonClick" object:self userInfo:dic];
    //block
    if (_ButtonClickBlock) {
        _ButtonClickBlock();
    }
    
}


@end
