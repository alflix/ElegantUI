//
//  JJRuntimeModel+JJModify.m
//  yzwgo
//
//  Created by jieyuan on 2017/6/13.
//
//

#import "JJRuntimeModel+JJModify.h"
#import "JJRuntimeForwardModel.h"
#import "JJRuntimeInvocation.h"
#import <objc/Runtime.h>

@implementation JJRuntimeModel (JJModify)

#pragma mark - Method Resolution

+ (BOOL)resolveInstanceMethod:(SEL)selector {
    if (selector == NSSelectorFromString(@"test")) {
        class_addMethod([self class], selector,(IMP)emptyMethodIMP,"v@:");
        return YES;
    }
    return [super resolveInstanceMethod:selector];
}

void emptyMethodIMP(){
    NSLog(@"=== 😢😢");
}

#pragma mark - Fast forwarding

- (id)forwardingTargetForSelector:(SEL)aSelector{
    // 将消息转发给 _forwardModel 来处理
    if ([NSStringFromSelector(aSelector) isEqualToString:@"forward"]) {
        return [JJRuntimeForwardModel new];
    }
    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark - Normal forwarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        if ([JJRuntimeInvocation instancesRespondToSelector:aSelector]) {
            signature = [JJRuntimeInvocation instanceMethodSignatureForSelector:aSelector];
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    [invocation invokeWithTarget:[JJRuntimeInvocation new]];
}

//==========================================================================================

#pragma mark - 使用 Category 添加 @property 变量


//动态添加对象的成员变量和成员方法

static void *JJRuntimeModelModifyName;

- (void)setModifyName:(NSString *)modifyName{
    objc_setAssociatedObject(self, JJRuntimeModelModifyName, modifyName, OBJC_ASSOCIATION_COPY);
}

- (NSString *)modifyName{
    return objc_getAssociatedObject(self, JJRuntimeModelModifyName);
}

/**
 一般情况下，类别里的方法会重写掉主类里相同命名的方法。如果有两个类别实现了相同命名的方法，只有一个方法会被调用。
 但 +load: 是个特例，当一个类被读到内存的时候， Runtime 会给这个类及它的每一个类别都发送一个 +load: 消息。
 */
+ (void)load{
    NSLog(@"\n 👆👆👆👆");
    [self swizzledInstanceMethod];
    [self swizzledClassMethod];
}

#pragma mark - 动态交换两个方法的实现

//对象方法
+ (void)swizzledInstanceMethod{
    swizzleMethod(self, @selector(sendMessage), @selector(xxx_sendMessage));
}

- (void)xxx_sendMessage{
    [self xxx_sendMessage];
    NSLog(@"\n === 😄");
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector){
    // 使用 class_getInstanceMethod 获取对象方法的 Method
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    //使用 method_getImplementation 获取 IMP（方法的实现）
    IMP originIMP = method_getImplementation(originalMethod);
    IMP swizzledIMP = method_getImplementation(swizzledMethod);
    
    //使用 method_getTypeEncoding 获取 Type
    const char *originType = method_getTypeEncoding(originalMethod);
    const char *swizzledType = method_getTypeEncoding(swizzledMethod);
    
    /**
     要先尝试添加原 selector 是为了做一层保护，因为如果这个类没有实现 originalSelector ，但其父类实现了，那 class_getInstanceMethod 会返回父类的方法。
     这样 method_exchangeImplementations 替换的是父类的那个方法，这当然不是你想要的。
     所以我们先尝试添加 orginalSelector ，如果已经存在，再用 method_exchangeImplementations 把原方法的实现跟新的方法实现给交换掉。
     */
    BOOL didAddMethod = class_addMethod(class, originalSelector, swizzledIMP, swizzledType);
    
    // the method doesn’t exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, originIMP, originType);
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

//类方法
+ (void)swizzledClassMethod{
    swizzledClassMethod(self, @selector(getSendMessage), @selector(xxx_getSendMessage));
}

+ (NSString *)xxx_getSendMessage{
    //经过了方法替换，所以下面的方法调用的是原来的方法，即 sendMessage
    NSString *string = [[JJRuntimeModel xxx_getSendMessage] stringByAppendingString:@"====="];
    NSLog(@"%@", string);
    return string;
}

void swizzledClassMethod(Class class, SEL originalSelector, SEL swizzledSelector){
    
    // 使用 class_getClassMethod 获取类方法的 Method
    
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    
    //使用 method_getImplementation 获取 IMP（方法的实现）
    IMP originIMP = method_getImplementation(originalMethod);
    IMP swizzledIMP = method_getImplementation(swizzledMethod);
    
    //使用 method_getTypeEncoding 获取 Type
    const char *originType = method_getTypeEncoding(originalMethod);
    const char *swizzledType = method_getTypeEncoding(swizzledMethod);
    
    //使用 objc_getMetaClass 获取 metaClass
    Class metaClass = objc_getMetaClass(class_getName([class class]));
    
    //方法替换
    BOOL didAddMethod = class_addMethod(metaClass, @selector(getSendMessage), swizzledIMP, swizzledType);
    if (didAddMethod) {
        class_replaceMethod(metaClass, @selector(xxx_getSendMessage), originIMP, originType);
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - 获得某个类的所有成员方法、所有成员变量

@end
