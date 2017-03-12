//
//  ViewController.m
//  CommunicationPatterns
//
//  Created by JieYuanZhuang on 15/2/27.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<CustomViewDelegate>
@property (nonatomic,copy)NSString *stringProperty;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (readwrite,strong)NSNumber *now;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //delegate
    CustomView *customView = [[CustomView alloc]initWithFrame:CGRectMake(100, 100, 150, 50)];
    customView.delegate = self;
    
    //NSNotification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(click:) name:@"buttonClick" object:nil];
    
    //block
    customView.ButtonClickBlock = ^{
        [self blockClick];
    };
    [self.view addSubview:customView];
    [self testAccessVariable];
    
    //KVC
    _contact = [[Contact alloc]init];
    [self updateTextFields];
    
    
}

//delegate
-(void)CustomView:(CustomView *)CustomView didClickButton:(UIButton *)button{
    NSLog(@"delegate--click!");
}

//NSNotification
-(void)click:(NSNotification*)notification{
    NSLog(@"notification--%@!",[notification.userInfo objectForKey:@"buttonKey"]);
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"buttonClick" object:nil];
}


//block
-(void)blockClick{
    NSLog(@"block--click!");
}

- (void)testAccessVariable
{
    __block NSUInteger outsideVariable = 10;//如果没有前缀，只能读取outsideVariable的值，不能写入，加入__block前缀则可以
    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:@"obj1",@"obj2",nil];
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSUInteger insideVariable = 20;
        insideVariable = 30;//block内部的变量可读/写
        outsideVariable = 30;//block外部的变量可读，写的话必须先声明为__block
        self.stringProperty = @"Block Objects";//property变量可读/写
        NSLog(@"outside Variable = %ld",(unsigned long)outsideVariable);
        NSLog(@"inside Variable = %ld",(unsigned long)insideVariable);
        NSLog(@"self = %@",self);//因为testAccessVariable是instance method所以可以access self
        NSLog(@"string property = %@",self.stringProperty);
        return NSOrderedSame;
    }];
}

//KVC
- (void)updateTextFields;
{
    _nameField.text = [_contact valueForKey:@"name"];
    //[_contact setValue:@"潮州" forKey:@"address"];
    _cityField.text = [_contact valueForKeyPath:@"address.city"];
    NSArray *items = [_contact valueForKey:@"numbers"];
    NSLog(@"numbers---%@",items);
    
    NSString *dic = [_contact valueForKeyPath:@"dic.1"];
    NSLog(@"dic：%@",dic);
    
    NSArray *array = @[@"foo",@"bar",@"hello"];
    NSArray *capitals = [array valueForKey:@"capitalizedString"];
    NSLog(@"---%@",capitals);
    
    NSInteger totalLength = [[array valueForKeyPath:@"@max.length"]intValue];
    NSLog(@"totalLength--%ld",(long)totalLength);
}


//KVO
- (IBAction)countSlider:(UISlider *)sender {
    self.now = @(sender.value);
    [_contact setProperty:@"now"];
    [_contact setObject:self];
}


@end
