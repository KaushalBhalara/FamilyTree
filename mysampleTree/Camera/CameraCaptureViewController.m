//
//  CameraCaptureViewController.m
//  Custom Camera Tutorial
//
//  Created by Bruno Tortato Furtado on 29/09/13.
//  Copyright (c) 2013 Bruno Tortato Furtado. All rights reserved.
//

#import "CameraCaptureViewController.h"
//#import "MBProgressHUD.h"
#import "RBVolumeButtons.h"
#import "ShowImageViewController.h"
//#import "ProfileViewController.h"
//#import "AvatarView.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

static int const kFacebookMinSize = 320;
static int const kSwitchButtonOriginY4inch = 4;
static int const kImagePreviewOriginY4inch = 62;


@interface CameraCaptureViewController ()

@property (nonatomic, strong) IBOutlet UIView *imagePreview;
@property (nonatomic, strong) IBOutlet UIButton *flashButton;
@property (nonatomic, strong) IBOutlet UIButton *snapButton;
@property (nonatomic, strong) IBOutlet UIButton *albumButton;
@property (strong, nonatomic) IBOutlet UIButton *switchButton;

@property (nonatomic) BOOL frontCameraEnabled;
@property (nonatomic, strong) ShowImageViewController *showImageController;
@property (nonatomic, strong) RBVolumeButtons *stealerButton;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *frontCamera;
@property (nonatomic, strong) AVCaptureDevice *backCamera;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) UIImagePickerController *albumPicker;

- (void)captureImage;
- (void)deviceOrientationDidChangeNotification;
- (void)initializeCamera;
- (void)processImage:(UIImage *)image;
- (void)showCameraPreviewFromDevice:(AVCaptureDevice *)device;

@end



@implementation CameraCaptureViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    _imagePreview.transform=CGAffineTransformMakeRotation(M_PI/2 );
    /*
    if ([[UIScreen mainScreen] bounds].size.height == 480)
    {
        CGRect frame;
        frame = self.imagePreview.frame;
        frame.origin.y = kImagePreviewOriginY4inch;
        self.imagePreview.frame = frame;
        
        frame = self.switchButton.frame;
        frame.origin.y = kSwitchButtonOriginY4inch;
        self.switchButton.frame = frame;
    } else {
        [self.switchButton setImage:[UIImage imageNamed:@"switch_camera_button_white"] forState:UIControlStateNormal];
    }*/
    [self.switchButton setImage:[UIImage imageNamed:@"switch_camera_button"] forState:UIControlStateNormal];

    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    self.flashButton.hidden = ![device hasFlash];
    
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar-logo"]]];
    
    self.imagePreview.layer.masksToBounds = YES;
    self.imagePreview.layer.cornerRadius = 5.f;
    
    self.showImageController = [self.storyboard instantiateViewControllerWithIdentifier:
                                NSStringFromClass([ShowImageViewController class])];
    
    self.frontCameraEnabled = NO;
    
    self.albumPicker = [[UIImagePickerController alloc] init];
    self.albumPicker.delegate = self;
    self.albumPicker.allowsEditing = YES;
    self.albumPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    self.stealerButton = [[RBVolumeButtons alloc] init];
    
    __weak typeof (self) weakSelf = self;
    
    _stealerButton.upBlock = ^{
        NSLog(@"up");
        [weakSelf snapImage];
    };
    
    _stealerButton.downBlock = ^{
        NSLog(@"down");
        [weakSelf snapImage];
    };
    
    [self initializeCamera];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.stealerButton startStealingVolumeButtonEvents];
    
    [self deviceOrientationDidChangeNotification];
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChangeNotification)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];*/
    
    if (self.frontCameraEnabled) {
        [self showCameraPreviewFromDevice:self.frontCamera];
    } else {
        [self showCameraPreviewFromDevice:self.backCamera];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
   // [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.stealerButton stopStealingVolumeButtonEvents];
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    self.frontCameraEnabled = NO;
    
    self.frontCamera = nil;
    self.backCamera = nil;
    
    
    self.stillImageOutput = nil;
    self.session = nil;
    
    self.showImageController = nil;
    
    [self setFlashButton:nil];
    [self setSnapButton:nil];
    [self setAlbumButton:nil];
    
    [self setFlashButton:nil];
    [self setSwitchButton:nil];
    [super viewDidUnload];
}/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait |toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
}
*/

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    [self.showImageController setPicture:chosenImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.navigationController pushViewController:self.showImageController animated:YES];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - Actions

- (IBAction)cancelBtnClcick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)snapImage
{
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.showImageController setPicture:nil];
    [self captureImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)switchCamera
{
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        CATransition *transition = [CATransition animation];
        //transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.duration = .6f;
        transition.type =  @"alignedFlip";
        
        [self.switchButton.layer addAnimation:transition forKey:@"button-rippleEffect"];
    }) ;

    
    AVCaptureDevice *device = self.backCamera;
            
    self.frontCameraEnabled = !self.frontCameraEnabled;
    
    if (self.frontCameraEnabled)
        device = self.frontCamera;

    self.flashButton.hidden = ![device hasFlash];
    
    [self showCameraPreviewFromDevice:device];
}

- (void)switchFlash
{
    AVCaptureDevice *device = self.backCamera;
    NSString *imageName = nil;
    
    if (self.frontCameraEnabled)
        device = self.frontCamera;
    
    if ([device hasFlash]) {
        [device lockForConfiguration:nil];
        
        switch ([device flashMode]) {
            case AVCaptureFlashModeAuto:
                imageName = @"button-flash-on";
                device.flashMode = AVCaptureFlashModeOn;
                break;
                
            case AVCaptureFlashModeOn:
                imageName = @"button-flash-off";
                device.flashMode = AVCaptureFlashModeOff;
                break;
                
            case AVCaptureFlashModeOff:
                imageName = @"button-flash-auto";
                device.flashMode = AVCaptureFlashModeAuto;
                break;
        }
        
        [self.flashButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [device unlockForConfiguration];
    }
}

- (IBAction)showPhotoAlbum
{
    [self presentViewController:self.albumPicker animated:YES completion:nil];
}

- (IBAction)gallry:(id)sender {
}

#pragma mark - Private methods

- (void)captureImage
{    
    AVCaptureConnection *videoConnection = nil;
    
    for (AVCaptureConnection *connection in self.stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo])
            {
                videoConnection = connection;
            }
        }
        
        if (videoConnection)
            break;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
    completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
     {
        if (imageDataSampleBuffer != NULL)
        {
            [self.session stopRunning];
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            [self processImage:[UIImage imageWithData:imageData]];
        }
    }];
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

- (void)initializeCamera
{
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    captureVideoPreviewLayer.frame = self.imagePreview.bounds;
    [self.imagePreview.layer addSublayer:captureVideoPreviewLayer];
    
    UIView *view = [self imagePreview];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [view bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    
    for (AVCaptureDevice *device in [AVCaptureDevice devices]) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionBack) {
                self.backCamera = device;
            } else {
                self.frontCamera = device;
            }
        }
    }
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    [self.session addOutput:self.stillImageOutput];
}

- (void)processImage:(UIImage *)image
{
    
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGRect cropRect = CGRectMake(0, 0, 0, 0);
    int sideSize = kFacebookMinSize;
    
    if (imageCopy.size.height > kFacebookMinSize && imageCopy.size.width > kFacebookMinSize) {
        sideSize = imageCopy.size.width;
        
        if (imageCopy.size.height < imageCopy.size.width)
            sideSize = imageCopy.size.height;
    }
    
    cropRect.size.height = cropRect.size.width = sideSize;
    image1=[[UIImage alloc]init];
    
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageCopy CGImage], cropRect);

    UIImage *cropImage = nil;
   UIImageOrientation imageOrientation;
    
    
    
    switch ([[UIDevice currentDevice] orientation])
    {
        case UIDeviceOrientationLandscapeLeft:
            imageOrientation = UIImageOrientationLeft;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            imageOrientation = UIImageOrientationRight;
            break;

        case UIDeviceOrientationPortraitUpsideDown:
            imageOrientation = UIImageOrientationDown;
            break;
            
        case UIDeviceOrientationPortrait:
        default:
            imageOrientation = UIImageOrientationUp;
            break;
    }   
    cropImage = [[UIImage alloc] initWithCGImage:imageRef scale:1.f orientation:imageOrientation];
    CGImageRelease(imageRef);
    image1=cropImage;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cameraImageNofification"
                                                       object:self];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

   
    //[self.showImageController setPicture:cropImage];
    
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    
    //[self presentViewController:self.showImageController animated:YES completion:nil];
    //[self.navigationController pushViewController:self.showImageController animated:YES];
}
- (void)showCameraPreviewFromDevice:(AVCaptureDevice *)device
{
    if (self.input) {
        if ([self.session isRunning])
            [self.session stopRunning];
        
        [self.session removeInput:self.input];
    }
    
    NSError *error = nil;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (self.input)
    {
        [self.session addInput:self.input];
        [self.session startRunning];
    } else
    {
        NSLog(@"Error: trying to open camera: %@", error);
    }
}

#pragma mark - Notifications

- (void)deviceOrientationDidChangeNotification
{    
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    CGAffineTransform transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
        /*
    switch (orientation) {
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationUnknown:
            transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
            break;

        case UIDeviceOrientationLandscapeLeft:
            transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
            break;
            
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationPortraitUpsideDown:
            transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
            break;
            
        case UIDeviceOrientationLandscapeRight:
            transform = CGAffineTransformMakeRotation(DegreesToRadians(270));
            break;
    }
    */
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
//    [UIView animateWithDuration:.5f animations:^{        
//        self.flashButton.transform = transform;
//        self.snapButton.transform = transform;
//        self.switchButton.transform = transform;
//        self.albumButton.transform = transform;
//        
//    }];
}

@end