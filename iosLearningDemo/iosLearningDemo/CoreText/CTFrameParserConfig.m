//
//  UIView+frameAdjust.h
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/24.
//  Copyright © 2017年 jieyuan. All rights reserved.
//


#import "CTFrameParserConfig.h"

@implementation CTFrameParserConfig

- (id)init {
    self = [super init];
    if (self) {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = [UIColor blackColor];
    }
    return self;
}

@end
