//
//  NavigationController.m
//  Custom Camera Tutorial
//
//  Created by Bruno Furtado on 01/10/13.
//  Copyright (c) 2013 Bruno Tortato Furtado. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end



@implementation NavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"]
                             forBarMetrics:UIBarMetricsDefault];
}

@end