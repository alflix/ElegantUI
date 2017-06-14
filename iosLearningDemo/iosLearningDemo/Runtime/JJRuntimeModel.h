//
//  JJRuntimeModel.h
//  yzwgo
//
//  Created by jieyuan on 2017/6/13.
//
//

#import <Foundation/Foundation.h>

@interface JJRuntimeModel : NSObject<NSCoding>

- (void)sendMessage;

+ (NSString *)getSendMessage;

@property (nonatomic, copy) NSString *message;

@end
