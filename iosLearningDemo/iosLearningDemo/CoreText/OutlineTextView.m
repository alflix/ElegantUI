//
//  OutlineTextView.m
//  iosLearningDemo
//
//  Created by jieyuan on 2017/6/24.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "OutlineTextView.h"
#import <CoreText/CoreText.h>

@implementation OutlineTextView

- (void) commonInit {
    self.backgroundColor = [UIColor blackColor];
    self.opaque = YES;
    self.font = [UIFont boldSystemFontOfSize:44.0];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)setFont:(UIFont *)font {
    if (font == _font) return;
    _font = font;
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    if (text == _text) return;
    _text = [text copy];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGRect bounds = self.bounds;
    
    NSUInteger length = self.text.length;
    unichar chars[length];
    CGGlyph glyphs[length];
    CGPoint positions[length];
    CGSize advances[length];
    
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(bounds.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect textRect = CGRectMake(floor((bounds.size.width - size.width)/2.0),
                                 44.0,
                                 size.width,
                                 size.height);
    
    [self.text getCharacters:chars range:NSMakeRange(0, length)];
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    
    CTFontGetGlyphsForCharacters(font, chars, glyphs, length);
    CTFontGetAdvancesForGlyphs(font, kCTFontDefaultOrientation, glyphs, advances, length);
    
    CGPoint position = textRect.origin;
    for (NSUInteger i=0; i<length; i++) {
        positions[i] = CGPointMake(position.x, position.y);
        CGSize advance = advances[i];
        position.x += advance.width;
        position.y += advance.height;
    }
    
    CGContextSaveGState(context);
    
    CGRect boundingBox = CTFontGetBoundingRectsForGlyphs(font, kCTFontDefaultOrientation, glyphs, NULL, length);
    CGContextTranslateCTM(context, 0.0, textRect.origin.y);
    CGContextTranslateCTM(context, 0.0, boundingBox.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -textRect.origin.y);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 10.0);
    
    for (NSUInteger i=0; i<length; i++) {
        CGPoint position = positions[i];
        CGAffineTransform tt = CGAffineTransformMakeTranslation(position.x, position.y);
        CGPathRef path = CTFontCreatePathForGlyph(font, glyphs[i], &tt);
        CGContextAddPath(context, path);
        CGPathRelease(path);
    }
    
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CTFontDrawGlyphs(font, glyphs, positions, length, context);
    
    CGContextRestoreGState(context);
    
    CFRelease(font);
    
    CGContextRestoreGState(context);
}


@end
