//
//  Adress.m
//  CommunicationPatterns
//
//  Created by JieYuanZhuang on 15/2/28.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "Address.h"

@implementation Address

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.country = @"中国";
        self.city = @"广州";
    }
    return self;
}

@end
