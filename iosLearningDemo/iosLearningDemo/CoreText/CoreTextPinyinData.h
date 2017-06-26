//
//  CoreTextPinyinData.h
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/24.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface CoreTextPinyinData : NSObject

@property (strong, nonatomic) NSString * name;
@property (nonatomic) int position;

// 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
@property (nonatomic) CGRect imagePosition;

@end
