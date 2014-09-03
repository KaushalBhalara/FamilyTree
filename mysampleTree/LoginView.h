//
//  LoginView.h
//  mysampleTree
//
//  Created by Prajas on 4/10/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyView.h"
#import "UniversalUrl.h"
#import "LoginWithEmail.h"

@class MyView;


@interface LoginView : UIViewController
{
    MyView * myview;
    int counter;
    LoginWithEmail *email;
}
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImage;
- (IBAction)facebook_login:(id)sender;
+ (NSString *)FacebookImageDirect : (NSString *)Filename;
- (IBAction)Create_New_User_Button:(id)sender;

@end
