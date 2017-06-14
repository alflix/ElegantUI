//
//  NSObject+JJExtension.h
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/14.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JJExtension)

- (NSArray *)ignoredNames;
- (void)encode:(NSCoder *)aCoder;
- (void)decode:(NSCoder *)aDecoder;

@end
