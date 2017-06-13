//
//  NSTimer+JJHelper.m
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/11.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "NSTimer+JJHelper.h"

@implementation NSTimer (JJHelper)

+ (NSTimer *)jj_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats{
    NSTimer * timer = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(__executeTimerBlock:) userInfo:[inBlock copy] repeats:inRepeats];
    return timer;
}

+ (NSTimer *)jj_timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats{
    NSTimer * timer = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(__executeTimerBlock:) userInfo:[inBlock copy] repeats:inRepeats];
    return timer;
}

+ (void)__executeTimerBlock:(NSTimer *)inTimer;{
    if([inTimer userInfo]){//相当于 if(block)
        void (^block)() = (void (^)())[inTimer userInfo];
        block();
    }
}

@end
