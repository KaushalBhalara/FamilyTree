//
//  MyidentityView.h
//  Mera Parivar
//
//  Created by Prajas on 4/18/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"
#import "NIDropDown.h"
#import "ASIHTTPRequest.h"
#import "DisplayViewController.h"
#import "ASIFormDataRequest.h"
#import "NewAdddata.h"

BOOL BACK;
@class LoginView;
@class DisplayViewController;
UIImage * uploadImage;
@interface MyidentityView : UIViewController <UITextFieldDelegate,NIDropDownDelegate,ASIHTTPRequestDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    int movementDistance ;
    CGFloat animatedDistance;
    NSString * check_string;
    DisplayViewController * myDisplay;
    NIDropDown *dropDown;
    NSMutableArray * genderarray;
    NSOperationQueue * queue;
    NSString *ageSTORE;
}
@property (retain, nonatomic) NSOperationQueue * queue;
@property (retain, nonatomic) IBOutlet UITextField *firstname_textfield;
@property (retain, nonatomic) IBOutlet UITextField *lastname_textfield;
@property (retain, nonatomic) IBOutlet UITextField *age_textfield;
@property (retain, nonatomic) IBOutlet UIButton *profile_image;
@property (retain, nonatomic) IBOutlet UITextField *father_textfield;
@property (retain, nonatomic) IBOutlet UITextField *mother_textfield;
@property (retain, nonatomic) IBOutlet UITextField *spouse_textfield;
@property (retain, nonatomic) IBOutlet UIImageView *imageview_profile;
@property (retain, nonatomic) IBOutlet UIButton *gender_button;
@property (strong, nonatomic) UIPopoverController *popover;
- (IBAction)change_profile:(id)sender;
- (IBAction)genderButton:(id)sender;
- (IBAction)save_data:(id)sender;
- (IBAction)back:(id)sender;

+ (NSString *)FacebookImage : (NSString *)Filename;

@end
