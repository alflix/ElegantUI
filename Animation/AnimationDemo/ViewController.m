//
//  ViewController.m
//  AnimationDemo
//
//  Created by JieYuanZhuang on 15/3/15.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"

@interface ViewController ()
@property (nonatomic,strong) UIView* squareView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.circleView = [[CircleView alloc] initWithFrame:
                       CGRectMake(0, 0, 20, 20)];
    self.circleView.center = CGPointMake(100, 40);
    [[self view] addSubview:self.circleView];
    

    self.squareView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    _squareView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_squareView];
    
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropAnimate:)];
    [[self view] addGestureRecognizer:g];
}


- (void)dropAnimate:(UIGestureRecognizer *)recognizer {
    [UIView animateWithDuration:3 animations:^{
         recognizer.enabled = NO;
         self.circleView.center = CGPointMake(100, 300);
        
        CGRect newFrame = CGRectMake(self.squareView.frame.origin.x + 150,
                                     self.squareView.frame.origin.y,
                                     self.squareView.frame.size.width,
                                     self.squareView.frame.size.height);
        self.squareView.frame = newFrame;
        self.squareView.alpha = 0.5;
        
     }
     completion:^(BOOL finished){
         [UIView animateWithDuration:1 animations:^{
              self.circleView.center = CGPointMake(250, 300);
          }
          completion:^(BOOL finished){
              recognizer.enabled = YES;
          }
          ];
     }];
}


@end
