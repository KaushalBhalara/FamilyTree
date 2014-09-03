//
//  NewIdentityView.h
//  Mera Parivar
//
//  Created by Prajas on 4/22/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "ASIHTTPRequest.h"

@interface NewIdentityView : UIViewController<NIDropDownDelegate,ASIHTTPRequestDelegate>
{
    int movementDistance ;
    CGFloat animatedDistance;
    NIDropDown *dropDown;
    NSMutableArray * genderarray;
}
@property (retain, nonatomic) IBOutlet UIImageView *profile_image;
@property (retain, nonatomic) IBOutlet UITextField *first_textfield;
@property (retain, nonatomic) IBOutlet UITextField *age_textfield;
@property (retain, nonatomic) IBOutlet UITextField *father_textfield;
@property (retain, nonatomic) IBOutlet UITextField *mother_textfield;
@property (retain, nonatomic) IBOutlet UITextField *surname_textfield;
@property (retain, nonatomic) IBOutlet UIButton *gender_button;
@property (retain, nonatomic) IBOutlet UITextField *spouse_textfield;
- (IBAction)back:(id)sender;
- (IBAction)change_image:(id)sender;
- (IBAction)savedata:(id)sender;
- (IBAction)gender:(id)sender;

@end
