//
//  ViewController.m
//  MemoryManagement
//
//  Created by jieyuan on 2017/6/8.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "ViewController.h"
#import "JJMemoryViewController.h"
#import "JJMultithreadingViewController.h"
#import "JJMessageViewController.h"
#import "JJRuntimeViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        JJMemoryViewController *vc = [JJMemoryViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        JJMultithreadingViewController *vc = [JJMultithreadingViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        JJMessageViewController *vc = [JJMessageViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3){
        JJRuntimeViewController *vc = [JJRuntimeViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Property

- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"Memory Manager",@"Multithreading",@"Message",@"Runtime"];
    }
    return _dataSource;
}

@end
