//
//  CBViewController.m
//  CGBitmapContextTest
//
//  Created by ly on 14-2-1.
//  Copyright (c) 2014年 ly. All rights reserved.
//

#import "CBViewController.h"
@import CoreText;

@interface CBViewController ()

@end

@implementation CBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self drawBitmap];
}

- (void)drawBitmap
{
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    size_t bitsPerComponent = 8;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width, height,
                                                 bitsPerComponent, 0,
                                                 colorSpace,
                                                 kCGImageAlphaNoneSkipLast|kCGBitmapByteOrder32Big);
    
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, width, height));
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, width/2.0, height/2.0);
    
    CGContextMoveToPoint(context, -width/2.0, 0);
    CGContextAddLineToPoint(context, width/2.0, 0);
    CGContextMoveToPoint(context, 0, -height/2.0);
    CGContextAddLineToPoint(context, 0, height/2.0);
    CGContextStrokePath(context);
    
    // Draw opaque rect
    CGFloat components1[4] = {0.0f, 1.0f, 0.0f, 1.0f};
    CGContextSetFillColor(context, components1);
    CGContextFillRect(context, CGRectMake(10, 10, 10, 10));
    
    CGFloat components2[4] = {0.0f, 0.0f, 1.0f, 1.0f};
    CGContextSetFillColor(context, components2);
    CGContextFillRect(context, CGRectMake(20, 20, 10, 10));
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    
    // Draw normal text
    UIFont *font = [UIFont systemFontOfSize:30.0];
    CGContextSetTextPosition(context, 50, 0);
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"line 1"
                                                               attributes:@{NSFontAttributeName:font}];
    CTLineRef line1 = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)str1);
    CGRect line1Bounds = CTLineGetImageBounds(line1, context);
    CGFloat components3[4] = {0.0f, 1.0f, 0.0f, 1.0f};
    CGContextSetFillColor(context, components3);
    CGContextFillRect(context, line1Bounds);
    CTLineDraw(line1, context);
    
    CGContextSetTextPosition(context, 50.0+line1Bounds.size.width+5.0, 0.0);       // move text position
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"line 2"
                                                               attributes:@{NSFontAttributeName:font}];
    CTLineRef line2 = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)str2);
    CGRect line2Bounds = CTLineGetImageBounds(line2, context);
    CGFloat components4[4] = {0.0f, 0.0f, 1.0f, 1.0f};
    CGContextSetFillColor(context, components4);
    CGContextFillRect(context, line2Bounds);
    CTLineDraw(line2, context);
    
    NSLog(@"%@", [NSValue valueWithCGRect:line1Bounds]);
    NSLog(@"%@", [NSValue valueWithCGRect:line2Bounds]);
    
    CFRelease(line1);
    CFRelease(line2);
    CGContextRestoreGState(context);
    
    
    CGImageRef cgimage = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:cgimage];
    self.imageView.image = image;       // Not thread safe
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(cgimage);
}

@end
