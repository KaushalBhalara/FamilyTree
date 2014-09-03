//
//  LoginWithEmail.h
//  Mera Parivar
//
//  Created by Prajas on 7/21/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString *EMAIL_FORM_VIEW;
@interface LoginWithEmail : UIViewController<UITextFieldDelegate>
{
    NSString *check_Status;
    int movementDistance ;
    CGFloat animatedDistance;

}
@property (retain, nonatomic) IBOutlet UIButton *Back_button_Only;
@property (retain, nonatomic) IBOutlet UITextField *Email_Txt_Field;
- (IBAction)Login_Button:(id)sender;
- (IBAction)Back_button:(id)sender;

@end
