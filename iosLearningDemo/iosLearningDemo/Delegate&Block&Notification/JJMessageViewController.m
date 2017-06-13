//
//  JJMessageViewController.m
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/12.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "JJMessageViewController.h"
#import "JJTestModel.h"
#import "JJDog.h"

typedef int(^BlockName)(int a);

@interface JJMessageViewController ()<JJTestModelDelegate>

@property (nonatomic, copy) int(^BlockName)(int a);

@property (nonatomic, copy) BlockName blockName;

@end

@implementation JJMessageViewController{
    JJTestModel *_model;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _model = [[JJTestModel alloc]init];
    _model.delegate = self;
    [_model start];
    
    JJDog *dog = [JJDog new];
    [dog think];
    
    self.BlockName = ^(int a){
        return 1;
    };
    
    [self testBlock:self.BlockName];
    
    [self testBlock:^(int a){
        return 1;
    }];
    
    __block NSString *string = @"string";
    
    [self testBlock2:^int(int a) {
        string = @"";
        
        return 1;
    }];
}

- (void)testBlock:(int(^)(int a))BlockName{
    NSLog(@"----- %@",BlockName);
}

- (void)testBlock2:(BlockName)blockName{
    NSLog(@"----- %@",blockName);
}

- (void)JJTestModel:(JJTestModel *)model didCreateByString:(NSString *)string{
    NSLog(@"===== %@",string);
}

void (^block)() = ^{
    NSLog(@"this is a block");
};

- (NSInteger)numberOfTimeModelShouldWait:(JJTestModel *)model{
    return 1;
}

- (void)testNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)inputKeyboardShow:(NSNotification *)noti{
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

@end
