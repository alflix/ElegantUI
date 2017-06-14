//
//  JJRuntimeInvocation.m
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/13.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "JJRuntimeInvocation.h"
#import <objc/Runtime.h>

@implementation JJRuntimeInvocation

+ (BOOL)resolveInstanceMethod:(SEL)selector {
    class_addMethod([self class], selector,(IMP)forwardMethodIMP,"v@:");
    return YES;
}

void forwardMethodIMP(){
    NSLog(@"=== 所有执行不了的方法都给我吧");
}

@end
