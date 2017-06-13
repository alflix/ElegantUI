//
//  NSTimer+JJHelper.h
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/11.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (JJHelper)

+ (NSTimer *)jj_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

+ (NSTimer *)jj_timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

@end
