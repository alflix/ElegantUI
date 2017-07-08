//
//  UIViewController+JJConfig.m
//  iosLearningDemo
//
//  Created by jieyuan on 2017/7/6.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "UIViewController+JJConfig.h"
#import <objc/runtime.h>

@implementation UIViewController (JJConfig)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod([self class], @selector(viewDidLayoutSubviews));
        Method swizzledMethod = class_getInstanceMethod([self class], @selector(swizzled_viewDidLayoutSubviews));
        
        BOOL didAddMethod = class_addMethod([self class],
                                            @selector(viewDidLayoutSubviews),
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod([self class],
                                @selector(swizzled_viewDidLayoutSubviews),
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)swizzled_viewDidLayoutSubviews {
    [self swizzled_viewDidLayoutSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSStringFromClass([self class]);
}

@end
