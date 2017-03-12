//
//  DownloadImageOperation.h
//  MultithreadedProgramming
//
//  Created by JieYuanZhuang on 15/3/3.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DownloadOperationDelegate;

@interface DownloadImageOperation : NSOperation

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, retain) id<DownloadOperationDelegate> delegate;
- (id)initWithUrl:(NSString *)url delegate:(id<DownloadOperationDelegate>)delegate;

@end


@protocol DownloadOperationDelegate <NSObject>
- (void)downloadFinishWithImage:(UIImage *)image;
@end