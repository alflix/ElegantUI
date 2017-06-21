//
//  JJAutoLayoutViewController.m
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/21.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "JJAutoLayoutViewController.h"

@interface JJAutoLayoutViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewToViewSpace;

@end

@implementation JJAutoLayoutViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews{
    //    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
    //        self.imageViewToViewSpace.constant = 30;
    //    }
    //    else{
    //        self.imageViewToViewSpace.constant = 82;
    //    }
}

@end
