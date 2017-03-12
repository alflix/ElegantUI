//
//  CALayoutViewController.m
//  AnimationDemo
//
//  Created by JieYuanZhuang on 15/3/15.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "CALayoutViewController.h"
#import "MyLayer.h"
#import "DelegateView.h"
#import <QuartzCore/QuartzCore.h>
//#import "CALayer+RNAnimation.h"

@interface CALayoutViewController ()
@property (weak, nonatomic) IBOutlet UIView *CALayoutView;

@end

@implementation CALayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.CALayoutView.layer.borderWidth=5;
    self.CALayoutView.layer.borderColor=[UIColor purpleColor].CGColor;
    self.CALayoutView.layer.cornerRadius=60;
    
    self.CALayoutView.layer.contents=(id)[UIImage imageNamed:@"photo"].CGImage;
    self.CALayoutView.layer.shadowColor=[UIColor blackColor].CGColor;
    self.CALayoutView.layer.shadowOffset=CGSizeMake(15, 5);
    self.CALayoutView.layer.shadowOpacity=0.6;
    self.CALayoutView.layer.shadowRadius = 1;
    
    self.CALayoutView.layer.masksToBounds = YES;
    //self.CALayoutView.layer.transform=CATransform3DMakeRotation(M_PI_4, 1, 1, 0.5);

    UIView *delegateView = [[DelegateView alloc] initWithFrame:CGRectMake(120, 400, 120, 50)];
    delegateView.center = self.view.center;
    [self.view addSubview:delegateView];
    
    
    MyLayer *myLayer = [MyLayer layer];
    [myLayer setNeedsDisplay];
    [self.view.layer addSublayer:myLayer];
    
    [self.view addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drop:)]];
}

- (void)drop:(UIGestureRecognizer *)recognizer {
    //[CATransaction setAnimationDuration:1.0];
    NSArray *layers = self.view.layer.sublayers;
    //由打印出来的数组得知第5个是MyLayer
    CALayer *layer = [layers objectAtIndex:4];
      CGPoint toPoint = CGPointMake(160, 210);
      [layer setContents:(id)[UIImage imageNamed:@"id"].CGImage];
      [layer setPosition:toPoint];
      [layer setBounds:CGRectMake(0, 0, 90, 90)];
    
//    CABasicAnimation *anim = [CABasicAnimation
//                              animationWithKeyPath:@"opacity"];
//    anim.fromValue = @1.0;
//    anim.toValue = @0.0;
//    anim.autoreverses = YES;
//    anim.repeatCount = INFINITY;
//    anim.duration = 2.0;
//    anim.fillMode = kCAFillModeBackwards;
//    [layer addAnimation:anim forKey:@"anim"];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.x";
    //animation.byValue = @120;
    animation.fromValue = @50;
    animation.toValue = @170;
    animation.fillMode = kCAFillModeBackwards;
    
    animation.duration = 2;
//    animation.fillMode = kCAFillModeBoth;
//    animation.removedOnCompletion = NO;
    
    animation.beginTime = CACurrentMediaTime()+1.2;
    [layer addAnimation:animation forKey:@"positionX"];
    
    layer.position = CGPointMake(170, 50);
    [CATransaction commit];
}


@end
