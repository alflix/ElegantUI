//
//  KVCModel.h
//  CommunicationPatterns
//
//  Created by JieYuanZhuang on 15/2/28.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"

@interface Contact : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, strong) Address *address;
@property (nonatomic, copy) NSDictionary *dic;


@property (nonatomic, readwrite, strong) id object;
@property (nonatomic, readwrite, copy) NSString *property;

- (NSUInteger)countOfNumbers;
- (id)objectInNumbersAtIndex:(NSUInteger)index;
//-(NSArray *)getNumbers;
@end
