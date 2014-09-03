//
//  DrawLine.m
//  Mera Parivar
//
//  Created by Prajas on 4/28/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import "DrawLine.h"

@implementation DrawLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSLog(@"call this");
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor
                                               blueColor].CGColor);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 300, 400);
    CGContextStrokePath(context);
//    [self setNeedsDisplay];
}


@end
