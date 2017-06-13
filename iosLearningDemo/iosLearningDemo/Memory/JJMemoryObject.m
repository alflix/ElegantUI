//
//  JJMemoryObject.m
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/9.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "JJMemoryObject.h"

@interface JJMemoryObject ()

@property (nonatomic, copy) JJMemoryObjectCompletionHandler completion;

@end

@implementation JJMemoryObject

#pragma mark - Block 问题

- (void)loadDataWithCompletionHandler:(JJMemoryObjectCompletionHandler)completion{
    _completion = completion;//注意，这里编译器会自动执行 copy 操作
}

+ (id)shareInstance{
    static dispatch_once_t onceToken;
    static JJMemoryObject *object = nil;
    dispatch_once(&onceToken, ^{
        object = [[JJMemoryObject alloc]init];
    });
    return object;
}

+ (void)easyLoadDataWithCompletionHandler:(JJMemoryObjectCompletionHandler)completion{
    JJMemoryObject *object = [JJMemoryObject shareInstance];
    object.completion = completion;
}

//假设类调用了这个方法，通知给 block
- (void)p_requestCompleted{
    if (_completion) {
        NSData *data = nil;
        _completion(data);
//        _completion = nil;
    }
}

#pragma mark - performSelector 问题

- (NSNumber *)copyOne:(NSNumber *)number{
    NSNumber *returnNumber = [number copy];
    return returnNumber;
}

- (NSNumber *)addOne:(NSNumber *)number{
    NSNumber *returnNumber = @(number.integerValue + 1);
    return returnNumber;
}

- (id)copyWithZone:(NSZone *)zone{
    JJMemoryObject *model = [[[self class] allocWithZone:zone] init];
    return model;
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params{
    NSString *targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
    NSString *actionString = [NSString stringWithFormat:@"Action_%@:", actionName];
    Class targetClass = NSClassFromString(targetClassString);
    id target = [[targetClass alloc] init];
    SEL action = NSSelectorFromString(actionString);
    if (target == nil) {
        // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
        return nil;
    }
    if ([target respondsToSelector:action]) {
        return [target performSelector:action withObject:params];
    } else {
        // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
        } else {
            // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
            return nil;
        }
    }
}

@end
