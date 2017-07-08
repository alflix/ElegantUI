//
//  JJMRCTestObject.m
//  iosLearningDemo
//
//  Created by jieyuan on 2017/7/3.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "JJMRCTestObject.h"

@implementation JJMRCTestObject

- (instancetype)init{
    self = [super init];
    if (self) {
        NSNumber *a = @(1);
        void (^b)() = ^{};
        NSLog(@"MRC:\n a:%p, &a:%p \n b:%p, &b:%p",a,&a,b,&b);
    }
    return self;
}

- (void)dealloc{
    [super dealloc];
}

@end
