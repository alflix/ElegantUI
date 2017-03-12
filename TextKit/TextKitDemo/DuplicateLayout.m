//
//  TKDConfigurationViewController.m
//  TextKitDemo
//
//  Created by Max Seelemann on 29.09.13.
//  Copyright (c) 2013 Max Seelemann. All rights reserved.
//

#import "DuplicateLayout.h"
#define kstring @"如上图所示，它们的关系是 1 对 N 的关系。就是那样：一个 Text Storage 可以拥有多个 Layout Manager，一个 Layout Manager 也可以拥有多个 Text Container。这些多重性带来了多容器布局的特性"
@interface DuplicateLayout ()

@property (weak, nonatomic) UITextView *otherTextView;
@property (weak, nonatomic) UITextView *thirdTextView;

@end

@implementation DuplicateLayout

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Load text
	NSTextStorage *sharedTextStorage = self.originalTextView.textStorage;
	[sharedTextStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:kstring];
	
	
	// 将一个新的 Layout Manager 附加到上面的 Text Storage 上
	NSLayoutManager *otherLayoutManager = [NSLayoutManager new];
	[sharedTextStorage addLayoutManager: otherLayoutManager];
	
	NSTextContainer *otherTextContainer = [NSTextContainer new];
	[otherLayoutManager addTextContainer: otherTextContainer];
	
	UITextView *otherTextView = [[UITextView alloc] initWithFrame:self.otherContainerView.bounds textContainer:otherTextContainer];
	otherTextView.backgroundColor = self.otherContainerView.backgroundColor;
	otherTextView.translatesAutoresizingMaskIntoConstraints = YES;
	otherTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	otherTextView.scrollEnabled = NO;
	
	[self.otherContainerView addSubview: otherTextView];
	self.otherTextView = otherTextView;
	
	
	// 将一个新的 Text Container 附加到同一个 Layout Manager，这样可以将一个文本分布到多个视图展现出来。
	NSTextContainer *thirdTextContainer = [NSTextContainer new];
	[otherLayoutManager addTextContainer: thirdTextContainer];
	
	UITextView *thirdTextView = [[UITextView alloc] initWithFrame:self.thirdContainerView.bounds textContainer:thirdTextContainer];
	thirdTextView.backgroundColor = self.thirdContainerView.backgroundColor;
	thirdTextView.translatesAutoresizingMaskIntoConstraints = YES;
	thirdTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	[self.thirdContainerView addSubview: thirdTextView];
	self.thirdTextView = thirdTextView;
}



- (IBAction)endEdit:(id)sender {
    [self.view endEditing: YES];
}
@end