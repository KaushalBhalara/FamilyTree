//
//  CameraCaptureViewController.h
//  Custom Camera Tutorial
//
//  Created by Bruno Tortato Furtado on 29/09/13.
//  Copyright (c) 2013 Bruno Tortato Furtado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "DisplayViewController.h"
UIImage *image1;
@interface CameraCaptureViewController : UIViewController
<
    UINavigationControllerDelegate, UIImagePickerControllerDelegate
>
@property (nonatomic, copy) NSArray *chosenImages;
- (IBAction)cancelBtnClcick:(id)sender;

- (IBAction)snapImage;
- (IBAction)switchCamera;
- (IBAction)switchFlash;
- (IBAction)showPhotoAlbum;
- (IBAction)gallry:(id)sender;

@end