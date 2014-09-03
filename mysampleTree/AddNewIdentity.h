//
//  AddNewIdentity.h
//  Mera Parivar
//
//  Created by Prajas on 7/14/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
BOOL ADD_NEW_ENTITY_BOOL;
@interface AddNewIdentity : UIViewController<UIImagePickerControllerDelegate,NIDropDownDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    int movementDistance ;
    CGFloat animatedDistance;
    int PARENTCOUNTER ;
    
    NSArray *relationarray;
    NSArray * genderarray;
    NIDropDown *dropDowngender;
    NIDropDown *dropDownrelation;
    
    NSArray * myarray;

}
@property (retain, nonatomic) NSOperationQueue * queue;
@property (retain, nonatomic) IBOutlet UITextField *firstname_textfield;
@property (retain, nonatomic) IBOutlet UITextField *lastname_textfield;
@property (retain, nonatomic) IBOutlet UITextField *age_textfield;
@property (retain, nonatomic) IBOutlet UIButton *gender_button;
@property (retain, nonatomic) IBOutlet UIButton *realtion_button;
@property (retain, nonatomic) IBOutlet UIImageView *profile_view;
- (IBAction)back:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)gender:(id)sender;
- (IBAction)relation:(id)sender;
- (IBAction)addimage:(id)sender;

@end
