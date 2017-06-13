//
//  JJMemoryObject.h
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/9.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JJMemoryViewController;

@protocol JJMemoryObjectDelegate <NSObject>

@end

typedef void(^JJMemoryObjectCompletionHandler)(NSData *data);

@interface JJMemoryObject : NSObject<NSCopying>

#pragma mark - performSelector 问题

- (NSNumber *)copyOne:(NSNumber *)number;

- (NSNumber *)addOne:(NSNumber *)number;

#pragma mark - 互相引用问题

//@property (nonatomic, strong) JJMemoryViewController *vc;

@property (nonatomic, weak) JJMemoryViewController *vc;

@property (nonatomic, weak) id<JJMemoryObjectDelegate> delegate;

#pragma mark - Block 问题

- (void)loadDataWithCompletionHandler:(JJMemoryObjectCompletionHandler)completion;

+ (void)easyLoadDataWithCompletionHandler:(JJMemoryObjectCompletionHandler)completion;

@end

