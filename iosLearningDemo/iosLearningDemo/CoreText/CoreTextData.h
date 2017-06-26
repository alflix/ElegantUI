//
//  CoreTextData.h
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/24.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreText/CoreText.h"

@interface CoreTextData : NSObject

@property (assign, nonatomic) CTFrameRef ctFrame;
@property (strong, nonatomic) NSAttributedString *content;
@property (assign, nonatomic) CGFloat height;

@end
