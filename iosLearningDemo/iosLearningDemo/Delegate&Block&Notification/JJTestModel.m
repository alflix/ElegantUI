//
//  JJTestModel.m
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/12.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "JJTestModel.h"

@implementation JJTestModel{
    _Bool value;
}

- (id)copyWithZone:(NSZone *)zone{
    JJTestModel *model = [[JJTestModel allocWithZone:zone] init];
    model->value = YES;
    return model;
}

- (void)start{
    if ([self.delegate respondsToSelector:@selector(numberOfTimeModelShouldWait:)]) {
        NSInteger time = [self.delegate numberOfTimeModelShouldWait:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"=== %@",@(time));
        });
    }
    
    if ([self.delegate respondsToSelector:@selector(JJTestModel:didCreateByString:)]) {
        [self.delegate JJTestModel:self didCreateByString:@"JJTestModel create"];
    }
}

@end
