//
//  JJDisplayView.m
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/24.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "JJDisplayView.h"
#import "CoreText/CoreText.h"

@implementation JJDisplayView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);//CGPathAddEllipseInRect

    NSString *chinese = @"兔子和乌龟要赛跑了。小鸟一叫：“一二三！”兔子就飞快地跑了出去。乌龟一步一步地向前爬。";
    NSString *pinyin = @"tù zi hé wū ɡuī yào sài pǎo le xiǎo niǎo yí jiào yī èr sān tù zi jiù fēi kuài de pǎo le chu qu wū ɡuī yí bù yí bù de xiànɡ qián pá";
    NSArray *pinyinArray = [pinyin componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    long number = 6;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number);
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:chinese attributes:@{(id)kCTKernAttributeName:(__bridge id)num}];
    CFRelease(num);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter,
                             CFRangeMake(0, [attString length]), path, NULL);

    NSMutableAttributedString *generateAttritubeString = [[NSMutableAttributedString alloc] init];
    
    // 1.获得CTLine数组
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frameRef);

    // 2.获得行数
    NSInteger lineCount = [lines count];
    
    //获得每一行的origin, CoreText的origin是在字形的baseLine处的, 请参考字形图
    CGPoint origins[lineCount];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
    if (lines.count == 0) {
        return;
    }
    NSUInteger loc = 0;
    for (int i = 0; i<lineCount; i++) {
        CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
        
        //获取某一行的中文
        CFRange lineRange = CTLineGetStringRange(line);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [chinese substringWithRange:range];
        
        //移除标点符号
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"。！：“”"];
        NSArray *lineStringArray = [lineString componentsSeparatedByCharactersInSet:characterSet];
        NSString *removeSpecialString = [lineStringArray componentsJoinedByString:@""];
        
        //获取某一行中文对应的拼音
        NSRange pinyinRange = NSMakeRange(loc, removeSpecialString.length);
        NSArray *linePinyinArray = [pinyinArray subarrayWithRange:pinyinRange];
        NSString *linePinyin = [linePinyinArray componentsJoinedByString:@" "];
        
        NSLog(@"\n%@\n%@",linePinyin,removeSpecialString);
        loc += removeSpecialString.length;
        
        //拼接成新的 AttritubeString
        [generateAttritubeString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n",linePinyin]]];
        
        long number = 6;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number);
        NSAttributedString *lineAttributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n",lineString] attributes:@{(id)kCTKernAttributeName:(__bridge id)num}];
        CFRelease(num);
        [generateAttritubeString appendAttributedString:lineAttributedString];
        
        
        //获取中文 glyphs 的位置
        NSArray * runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
        for (id runObj in runObjArray) {
            CTRunRef run = (__bridge CTRunRef)runObj;
            CFDictionaryRef runAttrs = CTRunGetAttributes(run);
            CTFontRef runFont = CFDictionaryGetValue(runAttrs, kCTFontAttributeName);
            if (!runFont) return;
            NSUInteger glyphCount = CTRunGetGlyphCount(run);
            if (glyphCount <= 0) return;
            
            CGGlyph glyphs[glyphCount];
            CGPoint glyphPositions[glyphCount];
            CTRunGetGlyphs(run, CFRangeMake(0, 0), glyphs);
            CTRunGetPositions(run, CFRangeMake(0, 0), glyphPositions);
        
            NSLog(@"\n==%@",@(glyphCount));
            
            for(int i = 0; i < sizeof(glyphPositions) / sizeof(glyphPositions[0]); i ++){
                NSLog(@"😄 [%d] = %@", i, [NSValue valueWithCGPoint:glyphPositions[i]]);
            }
        }
    }
    
    CTFramesetterRef generateFramesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)generateAttritubeString);
    CTFrameRef generateFrameRef = CTFramesetterCreateFrame(generateFramesetter,
                                                   CFRangeMake(0, [generateAttritubeString length]), path, NULL);
    
    CTFrameDraw(generateFrameRef, context);
    CFRelease(frameRef);
    CFRelease(path);
    CFRelease(framesetter);
}

@end
