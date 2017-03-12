//
//  TKDSecondViewController.m
//  TextKitDemo
//
//  Created by Max Seelemann on 29.09.13.
//  Copyright (c) 2013 Max Seelemann. All rights reserved.
//

#import "TKDLayoutingViewController.h"

#import "TKDLinkDetectingTextStorage.h"
#import "TKDOutliningLayoutManager.h"


@interface TKDLayoutingViewController () <NSLayoutManagerDelegate>
{
	// Text storage must be held strongly, only the default storage is retained by the text view.
	TKDLinkDetectingTextStorage *_textStorage;
}
@end

@implementation TKDLayoutingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Create componentes
	_textStorage = [TKDLinkDetectingTextStorage new];
	
	NSLayoutManager *layoutManager = [TKDOutliningLayoutManager new];
	[_textStorage addLayoutManager: layoutManager];
	
	NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize: CGSizeZero];
	[layoutManager addTextContainer: textContainer];
	
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectInset(self.view.bounds, 5, 20) textContainer: textContainer];
	textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	textView.translatesAutoresizingMaskIntoConstraints = YES;
	textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	[self.view addSubview: textView];
	
	
	// Set delegate
	layoutManager.delegate = self;
	
	// Load layout text
	[_textStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:[NSString stringWithContentsOfURL:[NSBundle.mainBundle URLForResource:@"layout" withExtension:@"txt"] usedEncoding:NULL error:NULL]];
}


#pragma mark - Layout

- (BOOL)layoutManager:(NSLayoutManager *)layoutManager shouldBreakLineByWordBeforeCharacterAtIndex:(NSUInteger)charIndex
{
	NSRange range;
	NSURL *linkURL = [layoutManager.textStorage attribute:NSLinkAttributeName atIndex:charIndex effectiveRange:&range];
	
	// Do not break lines in links unless absolutely required
	if (linkURL && charIndex > range.location && charIndex <= NSMaxRange(range))
		return NO;
	else
		return YES;
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
	return floorf(glyphIndex / 100);
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager paragraphSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
	return 10;
}

@end
