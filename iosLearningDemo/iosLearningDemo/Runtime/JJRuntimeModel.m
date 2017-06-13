//
//  JJRuntimeModel.m
//  yzwgo
//
//  Created by jieyuan on 2017/6/13.
//
//

#import "JJRuntimeModel.h"

@implementation JJRuntimeModel

- (void)sendMessage{
    NSLog(@"=== sendMessage");
}

+ (NSString *)sendMessage{
    return @"=== sendMessage";
}

- (void)p_sendMessage{
    NSLog(@"=== 😄😄");
}

+ (BOOL)resolveInstanceMethod:(SEL)selector {
    
    class_addMethod([self class], selector,(IMP)emptyMethodIMP,"v@:");
    return YES;
}

void emptyMethodIMP(){
    NSLog(@"=== 😢😢");
}

@end
