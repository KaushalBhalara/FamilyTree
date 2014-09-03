//
//  Line_View.h
//  line_drawing
//
//  Created by amorales on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Line_View : UIView {
  // This array (lines) will contain the lines that are drawn
  // we keep a handle of the lines so that we can build on this
  // later on we can select them, delete them, change their color, etc.
  NSMutableArray *lines;
}

// we will add elements to this array from outside this class, so
// we need a getter to get to this lines array
@property (strong, nonatomic) NSMutableArray *lines;

@end
