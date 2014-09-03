//
//  Line_View.m
//  line_drawing
//
//  Created by amorales on 5/7/12.
//

#import "Line_View.h"

@implementation Line_View

@synthesize lines = _lines;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// This method will draw each line in the array
// called when the app starts 
// also call it from the controller with the setNeedsDisplay method
- (void)drawRect:(CGRect)rect
{
  
  // initialize the _lines array if not already
  if(!_lines){
    _lines = [[NSMutableArray alloc] init];
  }
  
  // iterate through the array and draw the lines
  for(id line in _lines){
    // nice of ObjectiveC to let me send the message without having to worry
    // that this class does not know anything about the line object
    [line performSelector:@selector(draw)];
  }
}


@end
