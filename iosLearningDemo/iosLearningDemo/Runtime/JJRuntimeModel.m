//
//  JJRuntimeModel.m
//  yzwgo
//
//  Created by jieyuan on 2017/6/13.
//
//

#import "JJRuntimeModel.h"
#import "NSObject+JJExtension.h"

@implementation JJRuntimeModel

- (void)sendMessage{
    NSLog(@"=== sendMessage");
    
    for (id object in @[@1,@"string"]) {
        if ([object isKindOfClass:[NSNumber class]]) {
            //
        }else if ([object isKindOfClass:[NSString class]]){
            //
        }
    }
    typedef struct objc_object {
        Class isa;
    } *id;
    
    
}

+ (NSString *)getSendMessage{
    return @"=== sendMessage";
}

- (void)p_sendMessage{
    NSLog(@"=== 😄😄");
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self encode:aCoder];
//    [aCoder encodeObject:self.message forKey:@"message"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        [self decode:aDecoder];
//        self.message = [aDecoder decodeObjectForKey:@"message"];
    }
    return self;
}

@end
