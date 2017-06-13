//
//  JJPet.m
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/12.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "JJPet.h"

@interface JJPet ()

@property (nonatomic, weak) id<JJPetDelegate> delegate;

@end

@implementation JJPet

- (void)think{
    if ([self.delegate respondsToSelector:@selector(howThink)]) {
        NSString *string = [self.delegate howThink];
        NSLog(@"我在想：%@",string);
    }
}

@end
