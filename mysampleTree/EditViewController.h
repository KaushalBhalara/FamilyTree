//
//  EditViewController.h
//  Mera Parivar
//
//  Created by Prajas on 7/11/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
BOOL EDIT_IS_DONE_BOOL;
@interface EditViewController : UIViewController<NIDropDownDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    NIDropDown *dropDown;
    NSMutableArray *genderarray;
    
    int movementDistance ;
    CGFloat animatedDistance;
}
@property (retain, nonatomic) IBOutlet UITextField *last_name;
@property (retain, nonatomic) IBOutlet UITextField *age;
- (IBAction)update_data:(id)sender;

- (IBAction)back:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *gender_button;
- (IBAction)change_Image:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *sample_profile;
@property (retain, nonatomic) IBOutlet UITextField *first_name;
@property (strong, nonatomic) UIPopoverController *popover;
@end
