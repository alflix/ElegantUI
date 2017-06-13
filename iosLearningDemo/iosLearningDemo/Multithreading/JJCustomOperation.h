//
//  JJCustomOperation.h
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/12.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol JJCustomOperationDelegate <NSObject>

- (void)downloadFinishWithImage:(UIImage *)image;

@end

@interface JJCustomOperation : NSOperation

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, weak) id<JJCustomOperationDelegate> delegate;

- (id)initWithUrl:(NSString *)url delegate:(id<JJCustomOperationDelegate>)delegate;

@end


