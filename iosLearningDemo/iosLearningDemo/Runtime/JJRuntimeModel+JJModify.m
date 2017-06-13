//
//  JJRuntimeModel+JJModify.m
//  yzwgo
//
//  Created by jieyuan on 2017/6/13.
//
//

#import "JJRuntimeModel+JJModify.h"
#import <objc/Runtime.h>

static void *JJRuntimeModelModifyName;

@implementation JJRuntimeModel (JJModify)


/**
 一般情况下，类别里的方法会重写掉主类里相同命名的方法。如果有两个类别实现了相同命名的方法，只有一个方法会被调用。
 但 +load: 是个特例，当一个类被读到内存的时候， Runtime 会给这个类及它的每一个类别都发送一个 +load: 消息。
 */
+ (void)load{
    
}

//动态交换两个方法的实现

//类方法
+ (void)swizzledClassMethod{
    
    // 使用 class_getClassMethod 获取类方法的 Method
    Method originMethod = class_getClassMethod([self class], @selector(sendMessage));
    Method swizzledMethod = class_getClassMethod([self class], @selector(xxx_sendMessage));
    
    if (!originMethod || !swizzledMethod) {
        return;
    }
    
    //使用 method_getImplementation 获取 IMP（方法的实现）
    IMP originIMP = method_getImplementation(originMethod);
    IMP swizzledIMP = method_getImplementation(swizzledMethod);
    
    //使用 method_getTypeEncoding 获取 Type
    const char *originType = method_getTypeEncoding(originMethod);
    const char *swizzledType = method_getTypeEncoding(swizzledMethod);
    
    //使用 objc_getMetaClass 获取 metaClass
    Class metaClass = objc_getMetaClass(class_getName([self class]));
    
    //方法替换
    class_replaceMethod(metaClass, @selector(xxx_sendMessage), originIMP, originType);
    class_replaceMethod(metaClass, @selector(sendMessage), swizzledIMP, swizzledType);
}

+ (NSString *)xxx_sendMessage{
    //经过了方法替换，所以下面的方法调用的是原来的方法，即 sendMessage
    NSString *string = [[JJRuntimeModel xxx_sendMessage] stringByAppendingString:@"====="];
    NSLog(@"%@", string);
    return string;
}

//对象方法
+ (void)swizzledObnjectMethod{
    swizzleMethod(self, @selector(sendMessage), @selector(xxx_sendMessage));
}

- (void)xxx_sendMessage{
    NSLog(@"\n === 😄");
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector){
    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    /**
     要先尝试添加原 selector 是为了做一层保护，因为如果这个类没有实现 originalSelector ，但其父类实现了，那 class_getInstanceMethod 会返回父类的方法。
     这样 method_exchangeImplementations 替换的是父类的那个方法，这当然不是你想要的。
     所以我们先尝试添加 orginalSelector ，如果已经存在，再用 method_exchangeImplementations 把原方法的实现跟新的方法实现给交换掉。
     */
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    // the method doesn’t exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

//动态添加对象的成员变量和成员方法

- (void)setModifyName:(NSString *)modifyName{
    objc_setAssociatedObject(self, JJRuntimeModelModifyName, modifyName, OBJC_ASSOCIATION_COPY);
}

- (NSString *)modifyName{
    return objc_getAssociatedObject(self, JJRuntimeModelModifyName);
}

//获得某个类的所有成员方法、所有成员变量

@end
