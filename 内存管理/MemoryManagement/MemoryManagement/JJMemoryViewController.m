//
//  JJMemoryViewController.m
//  MemoryManagement
//
//  Created by jieyuan on 2017/6/9.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "JJMemoryViewController.h"

@interface JJMemoryViewController ()

@end

@implementation JJMemoryViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}

#pragma mark - performSelector 问题

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

- (void)testPerformSelector{
    NSNumber *number = @1;
    
    //如果是这么写的话没问题。
    if (number.integerValue > 1) {
        [self performSelector:@selector(addOne:) withObject:number];
    }else{
        [self performSelector:@selector(subtractOne:) withObject:number];
    }
    
    //如果这么写的话就有问题
    SEL selector = number.integerValue > 1?@selector(addOne:):@selector(subtractOne:);
    [self performSelector:selector withObject:number];
}


- (void)addOne:(NSNumber *)number{
    number = @(number.integerValue + 1);
}

- (NSNumber *)subtractOne:(NSNumber *)number{
    number = @(number.integerValue - 1);
    return number;
}

@end
