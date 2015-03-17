//
//  EditorViewController.m
//  TextKitDemo
//
//  Created by JieYuanZhuang on 15/3/10.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "EditorViewController.h"
#import "SyntaxHighlightTextStorage.h"



#define KString @" ~Shopping List~ *Cheese* _Biscuits_ -Sausages- IMPORTANT  @庄洁元   #话题#   http://www.baidu.com"
#define ksize self.view.bounds.size
@interface EditorViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation EditorViewController
{
    SyntaxHighlightTextStorage* _textStorage;
    //UITextView* _textView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(preferredContentSizeChanged:)
                                                name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    _textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self createTextView];
}


- (void)createTextView {
    _textStorage = [SyntaxHighlightTextStorage new];
    [_textStorage addLayoutManager: self.textView.layoutManager];
    
    [_textStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:@"在从 Interface 文件中载入时，可以像这样将它插入文本视图,然后加 *星号* 的字就会高亮出来了"];
    _textView.delegate = self;
}


-(void)preferredContentSizeChanged:(NSNotification *)notification{
    _textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

- (IBAction)doneEditing:(id)sender {
    [self.textView endEditing: YES];
}

@end
