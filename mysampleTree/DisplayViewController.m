//
//  DisplayViewController.m
//  Mera Parivar
//
//  Created by Prajas on 4/21/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import "DisplayViewController.h"
#import "NSDataAdditions.h"
#import "NSStringAdditions.h"
#import "SBJson.h"
#import "CameraCaptureViewController.h"
#import "UIDevice+Resolutions.h"

#include <math.h>
@interface DisplayViewController ()

@end

@implementation DisplayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(camerimageMethod) name:@"cameraImageNofification"object:nil];
    
    /*
    
    if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
    {
        CameraCaptureViewController *cmp=[[CameraCaptureViewController alloc]initWithNibName:@"CameraCaptureViewControlleriPhone5" bundle:nil];
        [self.navigationController presentViewController:cmp animated:YES completion:nil];
    }
    else
    {
        CameraCaptureViewController *cmp=[[CameraCaptureViewController alloc]initWithNibName:@"CameraCaptureViewController" bundle:nil];
        [self.navigationController presentViewController:cmp animated:YES completion:nil];
    }
     
    
    */
    
    if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
    {
        YCameraViewController *camController = [[YCameraViewController alloc] initWithNibName:@"YCameraViewController" bundle:nil];
        camController.delegate=self;
        [self presentViewController:camController animated:YES completion:^{
            // completion code
        }];
    }
    else
    {
        YCameraViewController *camController = [[YCameraViewController alloc] initWithNibName:@"YCameraViewController_iPhone4" bundle:nil];
        camController.delegate=self;
        [self presentViewController:camController animated:YES completion:^{
            // completion code
        }];
    }
    
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - YCameraViewController Delegate
- (void)didFinishPickingImage:(UIImage *)image
{
    [_profile_imageview setImage:image];
    self.roundview =[[UIView alloc] initWithFrame:CGRectMake(80, 122, 160, 160)];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        
    }
    else
    {
        if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
        {
            [self setRoundedView:self.roundview toDiameter:125];
        }
        else
        {
            [self setRoundedView:self.roundview toDiameter:140];
        }
    }
    
    self.roundview.layer.borderWidth = 1.0;
    self.roundview.layer.borderColor = [[UIColor orangeColor] CGColor];
    [_profile_imageview addSubview:self.roundview];
}

- (void)yCameraControllerdidSkipped{
    [_profile_imageview setImage:nil];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint pointMoved = [touch locationInView:self.view];

    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        
    }
    else
    {
        if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
        {
            self.roundview.frame = CGRectMake(pointMoved.x - 65, pointMoved.y - 65, 125, 125);
        }
        else
        {
            self.roundview.frame = CGRectMake(pointMoved.x - 75, pointMoved.y - 75, 150, 150);
        }
    }
    
}

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

-(void)camerimageMethod
{
   
    
   
    
    
    _profile_imageview.image = image1;
    

//    [avatar setNewImage:image1];
//    imageData = UIImageJPEGRepresentation(image1, 1);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Method

- (IBAction)change_photo:(id)sender
{
    /*
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallary", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.alpha=0.90;
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
    [actionSheet release];*/
    
//    _profile_imageview.image = [self circularScaleNCrop:image1 :self.roundview.frame];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        
    }
    else
    {
        if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
        {
            self.roundview.frame = CGRectMake(self.roundview.frame.origin.x + 65, self.roundview.frame.origin.y + 65 , self.roundview.frame.size.width, self.roundview.frame.size.height);
        }
        else
        {
            self.roundview.frame = CGRectMake(self.roundview.frame.origin.x + 190 , self.roundview.frame.origin.y + 60, self.roundview.frame.size.width, self.roundview.frame.size.height);
        }
    }
    
    _profile_imageview.image= [self croppedImage:self.roundview.frame];
    
}

/*
-(UIImage*)captureFullScreen:(UIView*) targetView
{
    UIGraphicsBeginImageContext(targetView.frame.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *fullScreenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(fullScreenshot, nil, nil, nil);
    return fullScreenshot;
}
 */
- (UIImage *)croppedImage:(CGRect)bounds
{
    NSLog(@"Bound View = = x= %f , y = %f , width = %f , height = %f",bounds.origin.x, bounds.origin.y,bounds.size.height,bounds.size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([_profile_imageview.image CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (IBAction)back:(id)sender
{
    BACK = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Actionsheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag)
    {
        case 1:
            switch (buttonIndex)
        {
            case 0:
            {
#if TARGET_IPHONE_SIMULATOR
                
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Saw Them" message:@"Camera not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
#elif TARGET_OS_IPHONE
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
                //picker.allowsEditing = YES;
                [self presentModalViewController:picker animated:YES];
                [picker release];
                
#endif
            }
                break;
            case 1:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                [self presentModalViewController:picker animated:YES];
                [picker release];
            }
                break;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - ImagePicker Delegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
//    UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
//    self.profile_imageview.image = [UIImage imageWithData:[NSData ]]
    
    self.profile_imageview.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    
    UIImage * myimage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    uploadImage = [self imageWithImage:myimage scaledToSize:CGSizeMake(100, 100)];
    [uploadImage retain];
    
//   NSString* b64str   = [NSString base64StringFromData:imgData length:[imgData length]];
    
    
    

    /*
    dataImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],1);
    imgPicture.image = [[UIImage alloc] initWithData:dataImage];
     */
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)dealloc
{
    [_profile_imageview release];
    [_roundview release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [self setProfile_imageview:nil];
    [self setRoundview:nil];
    [super viewDidUnload];
}

@end
