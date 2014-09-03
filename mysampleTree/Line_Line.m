//
//  Line_Line.m
//  line_drawing
//
//  Created by amorales on 5/7/12.
//
//  This is the actual class that knows how to draw a line

#import "Line_Line.h"

@implementation Line_Line 

@synthesize from_point = _from_point;
@synthesize to_point = _to_point;
@synthesize color = _color;

- (id) init {
  self = [super init];

  _from_point = CGPointMake(0.0, 0.0);
  _to_point = CGPointMake(0.0, 0.0);
  _color = [UIColor grayColor].CGColor; // default color
  
  return self;
  
}

// draw yourself
-(void) draw {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(context, 3.0);
  CGContextSetStrokeColorWithColor(context, _color);
  CGContextMoveToPoint(context, _from_point.x, _from_point.y);
  CGContextAddLineToPoint(context, _to_point.x, _to_point.y);
  CGContextStrokePath(context);
}
@end
