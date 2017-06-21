//
//  NSMutableArray+Sort.h
//  yzwgo
//
//  Created by jieyuan on 2017/5/31.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Sort)

- (void)selectionSort;

- (void)bubbleSort;

- (void)insertionSort;

- (void)quickSortWithLowIndex:(NSInteger)low highIndex:(NSInteger)high;

@end
