//
//  NSMutableArray+Sort.m
//  yzwgo
//
//  Created by jieyuan on 2017/5/31.
//
//

#import "NSMutableArray+Sort.h"

@implementation NSMutableArray (Sort)

/**
 以升序为例。 选择排序比较好理解，一句话概括就是依次按位置挑选出适合此位置的元素来填充。
 
 1:暂定第一个元素为最小元素，往后遍历，逐个与最小元素比较，若发现更小者，与先前的"最小元素"交换位置。达到更新最小元素的目的。
 
 2:一趟遍历完成后，能确保刚刚完成的这一趟遍历中，最的小元素已经放置在前方了。然后缩小排序范围，新一趟排序从数组的第二个元素开始。
 
 3:在新一轮排序中重复第1、2步骤，直到范围不能缩小为止，排序完成。
 */
- (void)selectionSort {
    if (self.count == 0) {
        return;
    }
    for (NSInteger i = 0; i < self.count - 1; i ++) {
        for (NSInteger j = i + 1; j < self.count; j ++) {
            if ([self[i] integerValue] > [self[j] integerValue]) {
                [self swapWithIndexA:i indexB:j];
            }
        }
    }
}


/**
 在一趟遍历中，不断地对相邻的两个元素进行排序，小的在前大的在后，这样会造成大值不断沉底的效果，当一趟遍历完成时，最大的元素会被排在后方正确的位置上。
 
 然后缩小排序范围，即去掉最后方位置正确的元素，对前方数组进行新一轮遍历，重复第1步骤。直到范围不能缩小为止，排序完成。
 */
- (void)bubbleSort{
    if (self.count == 0) {
        return;
    }
    for (NSInteger i = self.count - 1; i > 0; i --) {
        for (NSInteger j = 0; j < i; j ++) {
            if ([self[j] integerValue] > [self[j + 1] integerValue]) {
                [self swapWithIndexA:j indexB:j + 1];
            }
        }
    }
}


/**
 插入排序是从一个乱序的数组中依次取值，插入到一个已经排好序的数组中。 这看起来好像要两个数组才能完成，但如果只想在同一个数组内排序，也是可以的。此时需要想象出两个区域：前方有序区和后方乱序区。
 
 分区。开始时前方有序区只有一个元素，就是数组的第一个元素。然后把从第二个元素开始直到结尾的数组作为乱序区。
 
 从乱序区取第一个元素，把它正确插入到前方有序区中。把它与前方无序区的最后一个元素比较，亦即与它的前一个元素比较。
 
 如果比前一个元素要大，则不需要交换，这时有序区扩充一格，乱序区往后缩减一格，相当于直接拼在有序区末尾。
 
 如果和前一个元素相等，则继续和前二元素比较、再和前三元素比较......如果往前遍历到头了，发现前方所有元素值都长一个样的话(囧)，那也可以，不需要交换，这时有序区扩充一格，乱序区往后缩减一格，相当于直接拼在有序区末尾。如果比前一个元素大呢？对不起作为有序区不可能出现这种情况。如果比前一个元素小呢，请看下一点。
 
 如果比前一个元素小，则交换它们的位置。交换完后，继续比较取出元素和它此时的前一个元素，若更小就交换，若相等就比较前一个，直到遍历完成。 至此，把乱序区第一个元素正确插入到前方有序区中。
 
 往后缩小乱序区范围，继续取缩小范围后的第一个元素，重复第2步骤。直到范围不能缩小为止，排序完成。
 */
- (void)insertionSort {
    for (NSInteger i = 1; i < self.count; i ++) {
        for (NSInteger j = i; j > 0 && [self[j] integerValue] < [self[j - 1] integerValue]; j --) {
            [self swapWithIndexA:j indexB:j - 1];
        }
    }
}


/**
 从待排序数组中选一个值作为分区的参考界线，一般选第一个元素即可。这个选出来的值可叫做枢轴pivot，它将会在一趟排序中不断被移动位置，最终移动到位于整个数组的正确位置上。
 
 一趟排序的目标是把小于枢轴的元素放在前方，把大于枢轴的元素放在后方，枢轴放在中间。这看起来一趟排序实质上所干的事情就是把数组分区。接下来考虑怎么完成一次分区。
 
 记一个游标i，指向待排序数组的首位，它将会不断向后移动； 再记一个游标j，指向待排序数组的末位，它将会不断向前移动。 这样可以预见的是，i 、j终有相遇时，当它们相遇的时候，就是这趟排序完成时。
 
 现在让游标j从后往前扫描，寻找比枢轴小的元素x，找到后停下来，准备把这个元素扔到前方去。
 
 在同一个数组内排序并不能扩大数组的容量，那怎么扔呢？ 因为刚才把首位元素选作为pivot，所以当前它们的位置关系是pivot ... x。 又排序目标是升序，x是个小值却放在了pivot的后方，不妥，需要交换它们的位置。
 
 交换完后，它们的位置关系变成了x ... pivot。此时j指向了pivot，i指向了x。
 
 现在让游标i向后扫描，寻找比枢轴大的元素y，找到后停下来，与pivot进行交换。 完成后的位置关系是pivot ... y，此时i指向pivot，即pivot移到了i的位置。
 
 这里有个小优化，在i向后扫描开始时，i是指向x的，而在上一轮j游标的扫描中我们已经知道x是比pivot小的，所以完全可以让i跳过x，不需要拿着x和pivot再比较一次。 结论是在j游标的交换完成后，顺便把i往后移一位，i ++。 同理，在i游标的交换完成后，顺便把j往前移一位，j --。
 
 在扫描的过程中如果发现与枢轴相等的元素怎么办呢？ 因我们不讨论三向切分的快排优化算法，所以这里答案是：不理它。 随着一趟一趟的排序，它们会慢慢被更小的元素往后挤，被更大的元素往前挤，最后的结果就是它们都会和枢轴一起移到了中间位置。
 
 当i和j相遇时，i和j都会指向pivot。在我们的分区方法里，把i返回，即在分区完成后把枢轴位置返回。
 
 接下来，让分出的两个数组分别按上述步骤各自分区，这是个递归的过程，直到数组不能再分时，排序完成。
 
 */
- (void)quickSortWithLowIndex:(NSInteger)low highIndex:(NSInteger)high{
    if (low >= high) {
        return;
    }
    NSInteger baseIndex = [self quickPartitionWithLowIndex:low highIndex:high];
    [self quickSortWithLowIndex:low highIndex:baseIndex - 1];
    [self quickSortWithLowIndex:baseIndex + 1 highIndex:high];
}

- (NSInteger)quickPartitionWithLowIndex:(NSInteger)low highIndex:(NSInteger)high{
    NSInteger pivot = [self[low] integerValue];
    NSInteger i = low;
    NSInteger j = high;
    
    while (i < j) {
        // 略过大于等于pivot的元素
        while (i < j && [self[j] integerValue] >= pivot) {
            j --;
        }
        if (i < j) {
            // i、j未相遇，说明找到了小于pivot的元素。交换。
            [self swapWithIndexA:i indexB:j];
            i ++;
        }
        
        /// 略过小于等于pivot的元素
        while (i < j && [self[i] integerValue] <= pivot) {
            i ++;
        }
        if (i < j) {
            // i、j未相遇，说明找到了大于pivot的元素。交换。
            [self swapWithIndexA:i indexB:j];
            j --;
        }
    }
    return i;
}

#pragma mark - Private

// 交换两个元素
- (void)swapWithIndexA:(NSInteger)indexA indexB:(NSInteger)indexB{
    id temp = self[indexA];
    self[indexA] = self[indexB];
    self[indexB] = temp;
}

@end
