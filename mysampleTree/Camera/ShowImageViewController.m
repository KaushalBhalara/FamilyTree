//
//  ShowImageViewController.m
//  Custom Camera Tutorial
//
//  Created by Bruno Tortato Furtado on 30/09/13.
//  Copyright (c) 2013 Bruno Tortato Furtado. All rights reserved.
//

#import "ShowImageViewController.h"

@interface ShowImageViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (void)back;

@end



@implementation ShowImageViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar-logo"]]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBounds:CGRectMake(0, 0, 48, 24)];
    [button setImage:[UIImage imageNamed:@"navbar-btn-back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.imageView.image = self.picture;
    NSLog(@"picture: %@", NSStringFromCGSize(self.picture.size));
}

#pragma mark - Private methods

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end