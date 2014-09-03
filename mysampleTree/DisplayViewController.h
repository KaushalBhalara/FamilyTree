//
//  DisplayViewController.h
//  Mera Parivar
//
//  Created by Prajas on 4/21/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyidentityView.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "YCameraViewController.h"

@interface DisplayViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,ASIHTTPRequestDelegate,YCameraViewControllerDelegate>
{
    
}
@property (retain, nonatomic) IBOutlet UIView *roundview;
@property (retain, nonatomic) IBOutlet UIImageView *profile_imageview;
- (IBAction)change_photo:(id)sender;
- (IBAction)back:(id)sender;

@end
