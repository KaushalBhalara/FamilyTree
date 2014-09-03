//
//  Line_Line.h
//  line_drawing
//
//  Created by amorales on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line_Line : NSObject {
  CGPoint _from_point;
  CGPoint _to_point;
  CGColorRef _color;
}

@property CGPoint from_point;
@property CGPoint to_point;
@property CGColorRef color;

-(void) draw;

@end
