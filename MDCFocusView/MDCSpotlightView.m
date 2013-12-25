//  MDCSpotlightView.m
//
//  Copyright (c) 2013 modocache
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import "MDCSpotlightView.h"

@interface MDCSpotlightView(){
    CGRect focusFrame;
    CGFloat margin;
}

@end

@implementation MDCSpotlightView


#pragma mark - MDCFocalPointView Overrides

- (id)initWithFocalView:(UIView *)focalView {
    self = [super initWithFocalView:focalView];
    if (self) {
        CGRect focalRect = focalView.frame;

        margin = MAX(focalRect.size.width, focalRect.size.height);
        
        focusFrame = CGRectMake(focalRect.origin.x - margin/2,
                                focalRect.origin.y - margin/2,
                                focalRect.size.width + margin,
                                focalRect.size.height + margin);
        
        self.frame = CGRectMake(focalRect.origin.x - margin/2,
                                focalRect.origin.y - margin/2,
                                focalRect.size.width + margin,
                                focalRect.size.height + margin);
    }
    return self;
}

- (id)initWithFocalView:(UIView *)focalView withLineHight:(int)lineHiehgt{
    self = [super initWithFocalView:focalView];
    if (self) {
        self.lineHeigth = lineHiehgt;
        
        CGRect focalRect = focalView.frame;
        
        margin = MAX(focalRect.size.width, focalRect.size.height);
        
        focusFrame = CGRectMake(focalRect.origin.x - margin/2,
                                focalRect.origin.y - margin/2,
                                focalRect.size.width + margin,
                                focalRect.size.height + margin);
        
        self.frame = CGRectMake(focalRect.origin.x - margin/2,
                                focalRect.origin.y - margin/2,
                                focalRect.size.width + margin,
                                focalRect.size.height + margin + lineHiehgt);
    }
    return self;
}

#pragma mark - UIView Overrides

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGFloat locations[3] = { 0.0f, 0.5f, 1.0f };
    CFArrayRef colors = (__bridge CFArrayRef)@[
        (__bridge id)[UIColor clearColor].CGColor,
        (__bridge id)[UIColor clearColor].CGColor,
        (__bridge id)self.superview.backgroundColor.CGColor
    ];

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
    
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect)+focusFrame.size.height/2);
    CGFloat radius = MIN(focusFrame.size.width/3, focusFrame.size.height/3);
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    // line
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 0.5f);
    CGFloat startY = (focusFrame.size.height/4) *3;
    CGContextMoveToPoint(context, self.frame.size.width/2, startY);
    CGContextAddLineToPoint(context, self.frame.size.width/2, self.frame.size.height-10);
    CGContextStrokePath(context);
    
    // circle
    CGContextSetRGBFillColor(context, 255, 255, 255, 1);
    CGContextFillEllipseInRect(context, CGRectMake((self.frame.size.width/2)-2.5f, self.frame.size.height-10, 5, 5));
}

@end
