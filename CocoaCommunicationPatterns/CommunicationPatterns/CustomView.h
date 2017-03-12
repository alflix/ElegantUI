//
//  CustomView.h
//  CommunicationPatterns
//
//  Created by JieYuanZhuang on 15/2/27.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomView;
@protocol CustomViewDelegate <NSObject>

@optional
- (void) CustomView:(CustomView *)CustomView didClickButton:(UIButton*)button;
@end


@interface CustomView : UIView
@property (nonatomic,assign) id<CustomViewDelegate>delegate;
@property (nonatomic, copy) void (^ButtonClickBlock)();
@end
