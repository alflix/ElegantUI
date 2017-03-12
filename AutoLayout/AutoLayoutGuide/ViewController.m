//
//  ViewController.m
//  AutoLayoutGuide
//
//  Created by JieYuanZhuang on 15/3/6.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewToViewSpace;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewWillLayoutSubviews{
//    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
//        self.imageViewToViewSpace.constant = 30;
//    }
//    else{
//        self.imageViewToViewSpace.constant = 82;
//    }
}



@end
