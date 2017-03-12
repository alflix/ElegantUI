//
//  DynamicCellHeightViewController.m
//  AutoLayoutGuide
//
//  Created by JieYuanZhuang on 15/3/7.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "DynamicCellHeightViewController.h"
#import "CustomTableViewCell.h"

@interface DynamicCellHeightViewController ()
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) UITableViewCell *prototypeCell;
@end

@implementation DynamicCellHeightViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableData = @[@"1\n2\n3\n4\n5\n6", @"123456789012345678901234567890", @"1\n2", @"1\n2\n3", @"1"];
    self.prototypeCell  = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.label.text = self.tableData[indexPath.row];
    return cell;
}

//#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CustomTableViewCell *cell = (CustomTableViewCell *)self.prototypeCell;
//    cell.label.text = [self.tableData objectAtIndex:indexPath.row];
//    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    NSLog(@"h=%f", size.height + 1);
//    return 1  + size.height;//加1是因为分隔线的高度
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 66;
//}

@end
