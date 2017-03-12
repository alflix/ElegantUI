//
//  AnimationViewController.m
//  AnimationDemo
//
//  Created by JieYuanZhuang on 15/3/16.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "AnimationViewController.h"

@interface AnimationViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *pathView;

@property (weak, nonatomic) IBOutlet UIImageView *groupViewFirst;


@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    
    self.pathView.layer.borderWidth=2;
    self.pathView.layer.borderColor=[UIColor yellowColor].CGColor;
    self.pathView.layer.cornerRadius=25;
    self.pathView.layer.contents=(id)[UIImage imageNamed:@"photo"].CGImage;
    self.pathView.layer.shadowRadius = 1;
    self.pathView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pathAnimation:)];
    [self.pathView addGestureRecognizer:tap];
    
    self.groupViewFirst.layer.cornerRadius=10;
    self.groupViewFirst.layer.contents=(id)[UIImage imageNamed:@"id"].CGImage;
    self.groupViewFirst.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(groupAnimation:)];
    [self.groupViewFirst addGestureRecognizer:tap2];
    
}

- (IBAction)enter:(id)sender {
    if (![self.textField.text isEqualToString:@"123456"]) {
        [self lockAnimationForView:self.textField];
    }
}

-(void)lockAnimationForView:(UIView*)view
{
    CALayer *layer = [view layer];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[ @0, @5, @10, @-10, @10, @5, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0),@(2 / 6.0), @(3 / 6.0), @(5 / 6.0),@(2 / 6.0), @1 ];
    animation.duration = 0.4;
    animation.additive = YES;
    [layer addAnimation:animation forKey:@"shake"];
}

-(void)pathAnimation:(UITapGestureRecognizer*)tap{
    tap.enabled = NO;
    CALayer *layer = [self.pathView layer];
    CGRect boundingRect = CGRectMake(-150, -150, 300, 300);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.path = CFAutorelease(CGPathCreateWithEllipseInRect(boundingRect, NULL));
    animation.duration = 4;
    animation.additive = YES;
    animation.repeatCount = HUGE_VALF;
    animation.calculationMode = kCAAnimationPaced;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    [layer addAnimation:animation forKey:@"path"];
}


-(void)groupAnimation:(UITapGestureRecognizer*)tap{
    // 平移动画
    CABasicAnimation *animation1 = [CABasicAnimation animation];
    animation1.keyPath = @"transform.translation.y";
    animation1.toValue = @(100);
    // 缩放动画
    CABasicAnimation *animation2 = [CABasicAnimation animation];
    animation2.keyPath = @"transform.scale";
    animation2.toValue = @(0.0);
    // 旋转动画
    CABasicAnimation *animation3 = [CABasicAnimation animation];
    animation3.keyPath = @"transform.rotation";
    animation3.toValue = @(M_PI_2);

    // 组动画
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];

    groupAnima.animations = @[animation1, animation2, animation3];

    //设置组动画的时间
    groupAnima.duration = 2;
    groupAnima.fillMode = kCAFillModeForwards;
    groupAnima.removedOnCompletion = NO;
    [self.groupViewFirst.layer addAnimation:groupAnima forKey:@"group"];

}
@end
