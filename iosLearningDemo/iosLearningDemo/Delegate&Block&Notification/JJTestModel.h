//
//  JJTestModel.h
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/12.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JJTestModel;

@protocol JJTestModelDelegate <NSObject>
@required
- (NSInteger)numberOfTimeModelShouldWait:(JJTestModel *)model;

@optional
- (void)JJTestModel:(JJTestModel *)model didCreateByString:(NSString *)string;

@end

@interface JJTestModel : NSObject<NSCopying>

@property (nonatomic, weak) id<JJTestModelDelegate> delegate;

- (void)start;

@end
