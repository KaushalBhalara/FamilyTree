//
//  MyidentityView.m
//  Mera Parivar
//
//  Created by Prajas on 4/18/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import "MyidentityView.h"
#import "UniversalUrl.h"
#import "UIDevice+Resolutions.h"
#import <QuartzCore/QuartzCore.h>
#import "SBJson.h"
#import "UniversalUrl.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"
#import "Sample.h"
#import "UIImage+Resize.h"
#import "LoginWithEmail.h"

#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define ORIGINAL_MAX_WIDTH 640.0f

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;




@interface MyidentityView ()<VPImageCropperDelegate>

@end

@implementation MyidentityView
@synthesize queue;

+ (NSString *)FacebookImage : (NSString *)Filename
{
    NSArray *path3 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentfolder3 = [path3 objectAtIndex:0];
    return [documentfolder3 stringByAppendingPathComponent:Filename];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
    
    if (![self queue]) {
        [self setQueue:[[[NSOperationQueue alloc] init] autorelease]];
    }
    if (BACK == YES)
    {
        //self.imageview_profile.image = myDisplay.profile_imageview.image;
    }
    else
    {
        NSString * tempgetdata = [[NSString alloc] initWithString:GetData];
        tempgetdata = [tempgetdata stringByReplacingOccurrencesOfString:@"AAA" withString:facebookID];
        NSLog(@"GetData = %@",tempgetdata);
        NSString * check =[[NSUserDefaults standardUserDefaults]
                           stringForKey:@"preferenceName"];
//        if ([check isEqualToString:@"FirstTime"])
//        {
//            [self.view makeToastActivity];
//            NSURL * myurl = [NSURL URLWithString:tempgetdata];
//            ASIHTTPRequest *requestbyuid = [ASIHTTPRequest requestWithURL:myurl];
//            [requestbyuid setDelegate:self];
//            [requestbyuid setDidFinishSelector:@selector(requestDoneuid1:)];
//            [[self queue] addOperation:requestbyuid];
////            [requestbyuid startAsynchronous];
//        }
//        else
//        {
            self.firstname_textfield.text = facebookFirst_name;
            self.lastname_textfield.text = facebookLast_name;
            [self.gender_button setTitle:facebookGender forState:UIControlStateNormal];
        if ([EMAIL_FORM_VIEW length]==0)
        {
            [NSThread detachNewThreadSelector:@selector(downloadAndLoadImage) toTarget:self withObject:nil];
        }
            
//        }
    }
    
}
/*
-(void)FIRST_ENTERY_MY_SELF_FUNCTION
{
     NSString * tempsavedata = [[NSString alloc] initWithString:SaveData];
    tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"AAA" withString:facebookID]retain];
    
    tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"BBB" withString:facebookID] retain];
    tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"CCC" withString:self.firstname_textfield.text] retain];
    tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"DDD" withString:self.lastname_textfield.text]retain];
    tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"EEE" withString:self.age_textfield.text]retain];
    tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"FFF" withString:self.gender_button.titleLabel.text]retain];
    tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"GGG" withString:self.father_textfield.text]retain];
    tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"HHH" withString:self.mother_textfield.text]retain];
    tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"III" withString:self.spouse_textfield.text]retain];
    tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"JJJ" withString:facebookID]retain];
     NSString *TreeName=[[NSString alloc]initWithFormat:@"%@ %@",facebookFirst_name,facebookLast_name];
    tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"KKK" withString:TreeName]retain];
    
    NSLog(@"SaveData === %@",tempsavedata);
    
   // NSURL * myurl = [NSURL URLWithString:tempsavedata];
    
//     NSLog(@"TreeName=%@",TreeName);
//    NSString * urlstring = [[NSString alloc] initWithFormat:@"%@age=%@&child=%@&devicetoken=%@&gender=%@&last=%@&name=%@&number=%@&parent=%@&profile_name=%@%@&siblings=%@&spouse=%@&myself=1&tree_name=%@",insert_URL,facebookAge,@"",facebookID,facebookGender,facebookLast_name,facebookFirst_name,@"1",@"",facebookFirst_name,facebookLast_name,@"",@"",TreeName];
    tempsavedata = [tempsavedata stringByReplacingOccurrencesOfString:@" "  withString:@"%20"];    NSLog(@" FIRST_ENTERY_MY_SELF_FUNCTION urlstring --%@",tempsavedata);
    
    NSURL * myurl = [NSURL URLWithString:tempsavedata];
    ASIHTTPRequest *requestbyuidinsert = [ASIHTTPRequest requestWithURL:myurl];
    [requestbyuidinsert setDelegate:self];
    [requestbyuidinsert setDidFinishSelector:@selector(RESPONE_INSERT_MYSELF:)];
    [requestbyuidinsert setDidFailSelector:@selector(requestFailed:)];
    [self.queue addOperation:requestbyuidinsert];
    //[requestbyuid startAsynchronous];
    
}
- (void)RESPONE_INSERT_MYSELF:(ASIHTTPRequest *)request
{
    
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"Taari Masino Piko Insert Value = %@",responsevalue);
}*/
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [self.view hideToastActivity];
	NSError *error = [request error];
   [self.view makeToast:@"Server is down please try again later" duration:3.0 position:@"center"];
	NSLog(@"requestFailed:%@",error);
}

- (void)requestDoneuid1:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"response Value = %@",responsevalue);
    NSArray * imgae = [responsevalue valueForKey:@"picture_url"];
    check_string = [imgae objectAtIndex:0];
    if ([check_string rangeOfString:@"PHOTO_"].location==NSNotFound)
    {
//        NSLog(@"Substring Not Found");
        facebookID = check_string;
        [facebookID retain];
        facebookBigImage = [facebookBigImage stringByReplacingOccurrencesOfString:@"ID" withString:facebookID];
        [facebookBigImage retain];
        NSArray * fname = [responsevalue valueForKey:@"name"];
        self.firstname_textfield.text = [fname objectAtIndex:0];
        NSArray * lname = [responsevalue valueForKey:@"surname"];
        self.lastname_textfield.text = [lname objectAtIndex:0];
        NSArray * agename = [responsevalue valueForKey:@"age"];
        self.age_textfield.text = [agename objectAtIndex:0];
        NSArray * gendername = [responsevalue valueForKey:@"gender"];
        [self.gender_button setTitle:[gendername objectAtIndex:0] forState:UIControlStateNormal];
        NSArray * fathername = [responsevalue valueForKey:@"father"];
        self.father_textfield.text = [fathername objectAtIndex:0];
        NSArray * mothername = [responsevalue valueForKey:@"mother"];
        self.mother_textfield.text = [mothername objectAtIndex:0];
        NSArray * sposename = [responsevalue valueForKey:@"spouse"];
        self.spouse_textfield.text = [sposename objectAtIndex:0];
       
        [NSThread detachNewThreadSelector:@selector(downloadAndLoadImage) toTarget:self withObject:nil];
        [self.view hideToastActivity];
    }
    else
    {
        SeverImageName = check_string;
        [SeverImageName retain];
        facebookBigImage = [facebookBigImage stringByReplacingOccurrencesOfString:@"ID" withString:facebookID];
        [facebookBigImage retain];
        NSArray * fname = [responsevalue valueForKey:@"name"];
        self.firstname_textfield.text = [fname objectAtIndex:0];
        NSArray * lname = [responsevalue valueForKey:@"surname"];
        self.lastname_textfield.text = [lname objectAtIndex:0];
        NSArray * agename = [responsevalue valueForKey:@"age"];
        self.age_textfield.text = [agename objectAtIndex:0];
        NSArray * gendername = [responsevalue valueForKey:@"gender"];
        [self.gender_button setTitle:[gendername objectAtIndex:0] forState:UIControlStateNormal];
        NSArray * fathername = [responsevalue valueForKey:@"father"];
        self.father_textfield.text = [fathername objectAtIndex:0];
        NSArray * mothername = [responsevalue valueForKey:@"mother"];
        self.mother_textfield.text = [mothername objectAtIndex:0];
        NSArray * sposename = [responsevalue valueForKey:@"spouse"];
        self.spouse_textfield.text = [sposename objectAtIndex:0];
        
       
        NSString * tempstring = [[NSString alloc] initWithFormat:@"%@%@",GetServerImage,SeverImageName];
        NSURL * myurl = [NSURL URLWithString:tempstring];
        NSLog(@"Give me my url of image = = = %@",myurl);
        NSData * mydata = [NSData dataWithContentsOfURL:myurl];
        self.imageview_profile.image = [UIImage imageWithData:mydata];
        
        /*
        ASIHTTPRequest *requestbyuid = [ASIHTTPRequest requestWithURL:myurl];
        [requestbyuid setDelegate:self];
        [requestbyuid setDidFinishSelector:@selector(requestDoneuid33:)];
        [requestbyuid startAsynchronous];
        //        [[self queue] addOperation:requestbyuid];
        
        */
        
        [self.view hideToastActivity];
        
//        NSLog(@"Substring Found Successfully");
    }
//    facebookID = [imgae objectAtIndex:0];
    
    
    
//     NSString * idfacebook = [responsevalue valueForKey:@"spouse"];
    
}

- (void)requestDoneuid33:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"response Value = %@",response);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    BACK = NO;
    genderarray = [[NSMutableArray alloc] initWithObjects:@"Male",@"Female",@"Other", nil];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [self setRoundedView:self.imageview_profile toDiameter:220];
    }
    else
    {
        if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
        {
            [self setRoundedView:self.imageview_profile toDiameter:125];
        }
        else
        {
            [self setRoundedView:self.imageview_profile toDiameter:110];
        }
    }
    
    self.imageview_profile.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view from its nib.
    
}

-(void)downloadAndLoadImage
{
    
    NSURL *url = [NSURL URLWithString:facebookBigImage];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    if([data length]==0)
    {
         self.imageview_profile.image = [UIImage imageNamed:@"sample_profile.png"];
    }
    else
    {
         self.imageview_profile.image = [UIImage imageWithData:data];
    }
    //    [self.imageview_profile.image:[UIImage imageWithData:data]];
   
}

-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

#pragma mark - Action Method
- (IBAction)change_profile:(id)sender
{

    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallary", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.alpha=0.90;
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
    [actionSheet release];
    
    /*
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        myDisplay = [[DisplayViewController alloc] initWithNibName:@"DisplayViewController_Ipad" bundle:nil];
        [self.navigationController pushViewController:myDisplay animated:YES];
        myDisplay.profile_imageview.image = self.imageview_profile.image ;
    }
    else
    {
        if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
        {
            myDisplay = [[DisplayViewController alloc] initWithNibName:@"DisplayViewController" bundle:nil];
            [self.navigationController pushViewController:myDisplay animated:YES];
            myDisplay.profile_imageview.image = self.imageview_profile.image ;
        }
        else
        {
            myDisplay = [[DisplayViewController alloc] initWithNibName:@"DisplayViewController_Iphone4" bundle:nil];
            [self.navigationController pushViewController:myDisplay animated:YES];
            myDisplay.profile_imageview.image = self.imageview_profile.image ;
        }
    }*/
}
#pragma mark - Actionsheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }

}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


#pragma mark - ImagePicker Delegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    //    UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
    //    self.profile_imageview.image = [UIImage imageWithData:[NSData ]]
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
    
    
    //    UIImage * myimage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
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

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    
    editedImage = [editedImage resizedImage:CGSizeMake(400, 400) interpolationQuality:kCGInterpolationHigh];
    self.imageview_profile.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage
{
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)genderButton:(id)sender
{
    CGFloat f;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        f = [genderarray count]*50;
    }
    else
    {
        f = [genderarray count]*20;
    }
     
    if(dropDown == nil)
    {
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :genderarray :nil :@"down"];
        dropDown.delegate = self;
    }
    else
    {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (IBAction)save_data:(id)sender
{
    NSLog(@"call this");
    [self.view makeToastActivity];
    facebookAge = [[[NSString alloc] initWithFormat:@"%@",self.age_textfield.text]retain];
    facebookGender = [[NSString alloc] initWithFormat:@"%@",self.gender_button.titleLabel.text];
    UIImage *small = [UIImage imageWithCGImage:self.imageview_profile.image.CGImage scale:0.25 orientation:self.imageview_profile.image.imageOrientation];
    
    //    UIImage *_image = [[[UIImage alloc] initWithData:imageData] scaleToSize:CGSizeMake(150.0,150.0)];
    NSString *profilename = [[NSString alloc] initWithFormat:@"%@%@",facebookFirst_name,facebookLast_name];
    NSData * myimagedata = UIImagePNGRepresentation(small);
    [myimagedata writeToFile:[MyidentityView FacebookImage:profilename] atomically:YES];
    
    [self insertuserdata];
    
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)insertuserdata
{
    if (self.firstname_textfield.text.length >= 1 && self.lastname_textfield.text.length >= 1 && self.age_textfield.text.length >= 1 && self.gender_button.titleLabel.text.length >= 1 && self.father_textfield.text.length >= 1 && self.mother_textfield.text.length >= 1 && self.spouse_textfield.text.length >= 1)
    {
        if([EMAIL_FORM_VIEW length]>0)
        {
            facebookID=[[NSString alloc]initWithString:EMAIL_FORM_VIEW];
            facebookGender=[[NSString alloc]initWithString:self.gender_button.titleLabel.text];
            facebookLast_name=[[NSString alloc]initWithString:self.lastname_textfield.text];
            facebookFirst_name=[[NSString alloc]initWithString:self.firstname_textfield.text];
            facebookFirst_name=[[NSString alloc]initWithString:self.firstname_textfield.text];
        }
        
        NSString * tempsavedata = [[NSString alloc] initWithString:SaveData];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"AAA" withString:facebookID]retain];
        
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"BBB" withString:facebookID] retain];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"CCC" withString:self.firstname_textfield.text] retain];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"DDD" withString:self.lastname_textfield.text]retain];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"EEE" withString:self.age_textfield.text]retain];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"FFF" withString:self.gender_button.titleLabel.text]retain];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"GGG" withString:self.father_textfield.text]retain];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"HHH" withString:self.mother_textfield.text]retain];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"III" withString:self.spouse_textfield.text]retain];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"JJJ" withString:facebookID]retain];
        NSString *TreeName=[[NSString alloc]initWithFormat:@"%@ %@",facebookFirst_name,facebookLast_name];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"KKK" withString:TreeName]retain];
        
        NSLog(@"SaveData === %@",tempsavedata);
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@" " withString:@"%20"]retain];
        NSURL * myurl = [NSURL URLWithString:tempsavedata];
        ASIHTTPRequest *requestbyuid = [ASIHTTPRequest requestWithURL:myurl];
        [requestbyuid setDelegate:self];
        [requestbyuid setDidFinishSelector:@selector(insertuserdata_ONLY_USER:)];
        [requestbyuid startAsynchronous];
    }
    else
    {
        
        UIAlertView * myalret = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Fill up all Details." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [myalret show];
        [self.view hideToastActivity];
    }
}
/*
- (void)requestDoneuid11:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"response Value = %@",responsevalue);
    NSArray * mycount = [responsevalue valueForKey:@"true"];
    NSLog(@"mycount display == %@",mycount);
    
    if (mycount.count > 0)
    {
        if (self.firstname_textfield.text.length >= 1 && self.lastname_textfield.text.length >= 1 && self.age_textfield.text.length >= 1 && self.gender_button.titleLabel.text.length >= 1 && self.father_textfield.text.length >= 1 && self.mother_textfield.text.length >= 1 && self.spouse_textfield.text.length >= 1)
        {
            NSString * tempupdatedata = [[NSString alloc] initWithString:UpdateData];
            
            tempupdatedata = [[tempupdatedata stringByReplacingOccurrencesOfString:@"AAA" withString:facebookID]retain];
            if ([check_string rangeOfString:@"PHOTO_"].location==NSNotFound)
            {
                tempupdatedata = [[tempupdatedata stringByReplacingOccurrencesOfString:@"BBB" withString:facebookID] retain];
            }
            else
            {
                tempupdatedata = [[tempupdatedata stringByReplacingOccurrencesOfString:@"BBB" withString:SeverImageName] retain];
            }
            
            tempupdatedata = [[tempupdatedata stringByReplacingOccurrencesOfString:@"CCC" withString:self.firstname_textfield.text] retain];
            tempupdatedata = [[tempupdatedata stringByReplacingOccurrencesOfString:@"DDD" withString:self.lastname_textfield.text]retain];
            tempupdatedata = [[tempupdatedata stringByReplacingOccurrencesOfString:@"EEE" withString:self.age_textfield.text]retain];
            tempupdatedata = [[tempupdatedata stringByReplacingOccurrencesOfString:@"FFF" withString:self.gender_button.titleLabel.text]retain];
            tempupdatedata = [[tempupdatedata stringByReplacingOccurrencesOfString:@"GGG" withString:self.father_textfield.text]retain];
            tempupdatedata = [[tempupdatedata stringByReplacingOccurrencesOfString:@"HHH" withString:self.mother_textfield.text]retain];
            tempupdatedata = [[tempupdatedata stringByReplacingOccurrencesOfString:@"III" withString:self.spouse_textfield.text]retain];
            tempupdatedata = [[tempupdatedata stringByReplacingOccurrencesOfString:@"JJJ" withString:facebookID]retain];
            NSString *TreeName=[[NSString alloc]initWithFormat:@"%@ %@",facebookFirst_name,facebookLast_name];
            tempupdatedata = [[tempupdatedata stringByReplacingOccurrencesOfString:@"KKK" withString:TreeName]retain];
            
            NSLog(@"SaveData === %@",tempupdatedata);
            tempupdatedata = [[tempupdatedata stringByReplacingOccurrencesOfString:@" " withString:@"%20"]retain];
            
            NSLog(@"UpdateData == %@",tempupdatedata);
            NSURL * myurl = [[NSURL alloc] initWithString:tempupdatedata];
            ASIHTTPRequest *requestbyuid = [ASIHTTPRequest requestWithURL:myurl];
            [requestbyuid setDelegate:self];
            [requestbyuid setDidFinishSelector:@selector(requestDoneuid22:)];
            [requestbyuid setDidFailSelector:@selector(fail:)];
            [[self queue] addOperation:requestbyuid];
        }
        else
        {
            UIAlertView * myalret = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Fill up all Details." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [myalret show];
            [self.view hideToastActivity];
        }
        
       
//        [requestbyuid startAsynchronous];
    }
    else
    {
        if (self.firstname_textfield.text.length >= 1 && self.lastname_textfield.text.length >= 1 && self.age_textfield.text.length >= 1 && self.gender_button.titleLabel.text.length >= 1 && self.father_textfield.text.length >= 1 && self.mother_textfield.text.length >= 1 && self.spouse_textfield.text.length >= 1)
        {
            
            NSString * tempsavedata = [[NSString alloc] initWithString:SaveData];
            tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"AAA" withString:facebookID]retain];
            
            tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"BBB" withString:facebookID] retain];
            tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"CCC" withString:self.firstname_textfield.text] retain];
            tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"DDD" withString:self.lastname_textfield.text]retain];
            tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"EEE" withString:self.age_textfield.text]retain];
            tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"FFF" withString:self.gender_button.titleLabel.text]retain];
            tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"GGG" withString:self.father_textfield.text]retain];
            tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"HHH" withString:self.mother_textfield.text]retain];
            tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"III" withString:self.spouse_textfield.text]retain];
            tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"JJJ" withString:facebookID]retain];
            NSString *TreeName=[[NSString alloc]initWithFormat:@"%@ %@",facebookFirst_name,facebookLast_name];
            tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"KKK" withString:TreeName]retain];
            
            NSLog(@"SaveData === %@",tempsavedata);
            tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@" " withString:@"%20"]retain];
            NSURL * myurl = [NSURL URLWithString:tempsavedata];
            ASIHTTPRequest *requestbyuid = [ASIHTTPRequest requestWithURL:myurl];
            [requestbyuid setDelegate:self];
            [requestbyuid setDidFinishSelector:@selector(requestDoneuid:)];
            [[self queue] addOperation:requestbyuid];
//            [requestbyuid startAsynchronous];
        }
        else
        {
            
            UIAlertView * myalret = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Fill up all Details." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [myalret show];
            [self.view hideToastActivity];
        }
    }
}*/

- (void)fail:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"error = %@",error);
    [self.view hideToastActivity];
}
/*
- (void)requestDoneuid22:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"response Value update = %@",responsevalue);
    NSString * success = [responsevalue objectForKey:@"message"];
    if ([success isEqualToString:@"Operation success!"])
    {
        [[NSUserDefaults standardUserDefaults]
         setObject:@"FirstTime" forKey:@"preferenceName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"Sotre User data Value in my side == %@",[[NSUserDefaults standardUserDefaults]                                                  stringForKey:@"preferenceName"]);
        if (BACK == YES)
        {
            
//            UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
            NSLog(@"UPload Image size === ");
            uploadImage = [uploadImage resizedImage:CGSizeMake(200, 200) interpolationQuality:kCGInterpolationHigh];
            
            NSData *imagedata = UIImageJPEGRepresentation(uploadImage, 1.0);
            NSURL * myurl = [NSURL URLWithString:UploadImage];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
            [request setPostValue:facebookID forKey:@"userid"];
            [request setData:imagedata withFileName:facebookID andContentType:@"image/jpeg" forKey:@"userfile"];
            [request setDelegate:self];
            [request setDidFinishSelector:@selector(uploadRequestFinished:)];
            [request setDidFailSelector:@selector(uploadRequestFailed:)];
            [request startAsynchronous];
        }
        else
        {
            NSLog(@"------------------------");
            [self.view hideToastActivity];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}*/
/*
- (void)uploadRequestFinished:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"response image  uploadRequestFinished = %@",responsevalue);
    NSArray * familyarray = [responsevalue valueForKey:@"familytree"];
    if (familyarray.count > 0)
    
    {
        NSString *status = [familyarray valueForKey:@"status"];
        if ([status isEqualToString:@"success"])
        {
            NSLog(@"Upload");
           
        }
    }
    [self.view hideToastActivity];
//    [self.navigationController popViewControllerAnimated:YES];
}*/
- (void)insertuserdata_ONLY_USER:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"response Value = %@",responsevalue);
    NSString * success = [responsevalue objectForKey:@"message"];
    NSLog(@"Done");
    if ([success isEqualToString:@"Operation success!"])
    {
        if([EMAIL_FORM_VIEW length]>0)
        {
            facebookID=[[NSString alloc]initWithString:EMAIL_FORM_VIEW];
             facebookGender=[[NSString alloc]initWithString:self.gender_button.titleLabel.text];
            facebookLast_name=[[NSString alloc]initWithString:self.lastname_textfield.text];
            facebookFirst_name=[[NSString alloc]initWithString:self.firstname_textfield.text];
            facebookFirst_name=[[NSString alloc]initWithString:self.firstname_textfield.text];
        }
        
        [self insert_data];
        NSLog(@"Done");
        [[NSUserDefaults standardUserDefaults]
         setObject:@"FirstTime" forKey:@"preferenceName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        [self insert];
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.view hideToastActivity];
    
}
-(void)insert_data
{
   // NSString * urlstring = [[NSString alloc] initWithFormat:@"%@age=%@&child=%@&devicetoken=%@&gender=%@&last=%@&name=%@&number=%@&parent=%@&profile_name=%@%@&siblings=%@&spouse=%@&myself=1",insert_URL,ageSTORE,@"",facebookID,facebookGender,facebookLast_name,facebookFirst_name,@"1",@"",facebookFirst_name,facebookLast_name,@"",@""];
   // NSLog(@"Insert data Of the Family Tree My VIEW --%@",urlstring);
    
    uploadImage = [self.imageview_profile.image resizedImage:CGSizeMake(200, 200) interpolationQuality:kCGInterpolationHigh];
      NSData *imagedata = UIImageJPEGRepresentation(uploadImage, 1.0);
   // NSLog(@"imagedata=%@",imagedata);
    NSString *ProfName=[[NSString alloc]initWithFormat:@"%@%@",facebookFirst_name,facebookLast_name];
    NSURL * myurl = [NSURL URLWithString:insert_URL];
    NSLog(@"insert_URL = =%@",insert_URL);
    
    ASIFormDataRequest *request1 = [ASIFormDataRequest requestWithURL:myurl];
    [request1 setPostValue:ageSTORE forKey:@"age"];
    [request1 setPostValue:@"" forKey:@"child"];
    [request1 setPostValue:facebookID forKey:@"fb_id"];
    [request1 setPostValue:facebookGender forKey:@"gender"];
    [request1 setPostValue:facebookLast_name forKey:@"surname"];
    [request1 setPostValue:facebookFirst_name forKey:@"name"];
    [request1 setPostValue:@"1" forKey:@"number"];
    [request1 setPostValue:@"" forKey:@"parent"];
    [request1 setPostValue:ProfName forKey:@"profile_name"];
    [request1 setPostValue:@"" forKey:@"siblings"];
    [request1 setPostValue:@"" forKey:@"spouse"];
    [request1 setPostValue:@"1" forKey:@"myself"];
    [request1 setData:imagedata withFileName:facebookID andContentType:@"image/jpeg" forKey:@"userfile"];
    [request1 setDelegate:self];
    [request1 setDidFinishSelector:@selector(InserUserData:)];
    [request1 setDidFailSelector:@selector(requestFailed:)];
    //[self.queue addOperation:requestbyuidinsert];
    [request1 startAsynchronous];;
    
    /*
    NSURL * myurl = [NSURL URLWithString:urlstring];
    ASIHTTPRequest *requestbyuidinsert = [ASIHTTPRequest requestWithURL:myurl];
    [requestbyuidinsert setDelegate:self];
    [requestbyuidinsert setDidFinishSelector:@selector(requestDoneuid:)];
    [requestbyuidinsert setDidFailSelector:@selector(InserUserData:)];
    //[self.queue addOperation:requestbyuidinsert];
    [requestbyuidinsert startAsynchronous];*/
    
}

- (void)InserUserData:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    // [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"Taari Masino Piko Insert Value = %@",responsevalue);
    
    //    uploadImage = [self.imageview_profile.image resizedImage:CGSizeMake(200, 200) interpolationQuality:kCGInterpolationHigh];
    //
    //    NSData *imagedata = UIImageJPEGRepresentation(uploadImage, 1.0);
    //    NSURL * myurl = [NSURL URLWithString:UploadImage];
    //    ASIFormDataRequest *request1 = [ASIFormDataRequest requestWithURL:myurl];
    //    [request1 setPostValue:facebookID forKey:@"userid"];
    //    [request1 setData:imagedata withFileName:facebookID andContentType:@"image/jpeg" forKey:@"userfile"];
    //    [request1 setDelegate:self];
    //    [request1 setDidFinishSelector:@selector(uploadRequestFinished:)];
    //    [request1 setDidFailSelector:@selector(uploadRequestFailed:)];
    //    [request1 startAsynchronous];
}
-(void)insert
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    Sample *s = [NSEntityDescription insertNewObjectForEntityForName:@"Sample" inManagedObjectContext:context];
    
    s.name = facebookFirst_name;
    s.ids = @"1";
    s.parent = @"";
    s.child = @"";
    s.sibling = @"";
    s.number = [NSNumber numberWithInt:1];
    s.profile_name = [NSString stringWithFormat:@"%@%@",facebookFirst_name,facebookLast_name];
    
    NSError *error;
    
    if (![context save:&error])
    {
        NSLog(@"Ohhhhh You are fool because no memory you have");
    }
}

#pragma mark - Dropdown delegate

- (void) niDropDownDelegateMethod: (NIDropDown *) sender
{
    [self rel];
}

-(void)rel
{
    dropDown = nil;
}

#pragma mark - TextField Method

-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField
{
    UIToolbar * keyboardToolBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)]autorelease];
    keyboardToolBar.barStyle = UIBarStyleBlackTranslucent;
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"PRE", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(previousTextField)],
                                [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"NEXT", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(nextTextField)],
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"DONE", nil) style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)],
                                nil]];
    textField.inputAccessoryView = keyboardToolBar;
     
    return YES;
}

- (void)nextTextField
{
    
    if ([self.firstname_textfield isFirstResponder])
    {
        [self.firstname_textfield resignFirstResponder];
        [self.lastname_textfield becomeFirstResponder];
    }
    else if ([self.lastname_textfield isFirstResponder])
    {
        [self.lastname_textfield resignFirstResponder];
        [self.age_textfield becomeFirstResponder];
    }
    else if ([self.age_textfield isFirstResponder])
    {
        [self.age_textfield resignFirstResponder];
        [self.father_textfield becomeFirstResponder];
    }
    else if ([self.father_textfield isFirstResponder])
    {
        [self.father_textfield resignFirstResponder];
        [self.mother_textfield becomeFirstResponder];
    }
    else if ([self.mother_textfield isFirstResponder])
    {
        [self.mother_textfield resignFirstResponder];
        [self.spouse_textfield becomeFirstResponder];
    }
    else if ([self.spouse_textfield isFirstResponder])
    {
        [self.spouse_textfield resignFirstResponder];
        [self.firstname_textfield becomeFirstResponder];
    }
}

-(void)previousTextField
{
    
    if ([self.firstname_textfield isFirstResponder])
    {
        [self.firstname_textfield resignFirstResponder];
        [self.spouse_textfield becomeFirstResponder];
    }
    else if ([self.lastname_textfield isFirstResponder])
    {
        [self.lastname_textfield resignFirstResponder];
        [self.firstname_textfield becomeFirstResponder];
    }
    else if ([self.age_textfield isFirstResponder])
    {
        [self.age_textfield resignFirstResponder];
        [self.lastname_textfield becomeFirstResponder];
    }
    else if ([self.father_textfield isFirstResponder])
    {
        [self.father_textfield resignFirstResponder];
        [self.age_textfield becomeFirstResponder];
    }
    else if ([self.mother_textfield isFirstResponder])
    {
        [self.mother_textfield resignFirstResponder];
        [self.father_textfield becomeFirstResponder];
    }
    else if ([self.spouse_textfield isFirstResponder])
    {
        [self.spouse_textfield resignFirstResponder];
        [self.mother_textfield becomeFirstResponder];
    }
    
}

-(void)resignKeyboard
{
    [self.firstname_textfield resignFirstResponder];
    [self.lastname_textfield resignFirstResponder];
    [self.age_textfield resignFirstResponder];
    [self.father_textfield resignFirstResponder];
    [self.mother_textfield resignFirstResponder];
    [self.spouse_textfield resignFirstResponder];
}
 
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    if(textField == self.age_textfield)
    {
        ageSTORE=[[[NSString alloc]initWithFormat:@"%@",self.age_textfield.text]retain];
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.firstname_textfield resignFirstResponder];
    [self.father_textfield resignFirstResponder];
    [self.mother_textfield resignFirstResponder];
    [self.age_textfield resignFirstResponder];
    [self.spouse_textfield resignFirstResponder];
    [self.lastname_textfield resignFirstResponder];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_profile_image release];
    [_firstname_textfield release];
    [_lastname_textfield release];
    [_age_textfield release];
    [_father_textfield release];
    [_mother_textfield release];
    [_spouse_textfield release];
    [_imageview_profile release];
    [_gender_button release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setProfile_image:nil];
    [self setFirstname_textfield:nil];
    [self setLastname_textfield:nil];
    [self setAge_textfield:nil];
    [self setFather_textfield:nil];
    [self setMother_textfield:nil];
    [self setSpouse_textfield:nil];
    [self setImageview_profile:nil];
    [self setGender_button:nil];
    [super viewDidUnload];
}
@end
