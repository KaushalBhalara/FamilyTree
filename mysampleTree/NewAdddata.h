//
//  NewAdddata.h
//  treeeeeeeee
//
//  Created by Prajas on 4/30/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListFamily.h"
#import "TreeViewContoller.h"
#import "NIDropDown.h"
#import "ASIHTTPRequest.h"
BOOL EDITFAMILYBOOL;
@interface NewAdddata : UIViewController <UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NIDropDownDelegate,ASIHTTPRequestDelegate>
{
    int PARENTCOUNTER ;
    int movementDistance ;
    CGFloat animatedDistance;
    NIDropDown *dropDown;
    NSMutableArray *genderarray;
}
@property (retain, nonatomic) NSOperationQueue * queue;
@property (retain, nonatomic) IBOutlet UIImageView *profile_image;
@property (retain, nonatomic) IBOutlet UITextField *name_textfield;
@property (retain, nonatomic) IBOutlet UITextField *Age_textfield;
@property (retain, nonatomic) IBOutlet UILabel *last_name;
@property (retain, nonatomic) IBOutlet UITextField *last_textfield;
@property (retain, nonatomic) IBOutlet UIButton *gender_button;
@property (strong, nonatomic) UIPopoverController *popover;
- (IBAction)savedata:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)addImage:(id)sender;
+ (NSString *)PathOfBGImages : (NSString *)Filename;
- (IBAction)DropDownButton:(id)sender;

@end
