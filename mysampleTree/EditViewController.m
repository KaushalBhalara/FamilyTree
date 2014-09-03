//
//  EditViewController.m
//  Mera Parivar
//
//  Created by Prajas on 7/11/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import "EditViewController.h"
#import "AppDelegate.h"
#import "Sample.h"
#import "UIImage+Resize.h"
#import "NewAdddata.h"
#import "ListFamily.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "FTWCache.h"
#import "NSString+MD5.h"
#import "UIView+Toast.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;

@interface EditViewController ()

@end

@implementation EditViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSArray *)GetUserData :(NSString *)idsvalue
{
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ids == %@", idsvalue];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray * define_array = [context executeFetchRequest:request error:&error];
//    NSLog(@"define_array == %@",define_array);
    if (define_array.count > 0) {
        //        Sample *s =[define_array objectAtIndex:0];
        //        NSLog(@"s name is  == %@",s.profile_name);
        return define_array;
    }
    else{
        return NULL;
    }
}

-(void)update_record :(NSString *)idValues :(NSString *)imageName
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ids == %@", idValues];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSError *error;
    
    NSArray * define_array = [context executeFetchRequest:request error:&error];
    NSLog(@"define array == %@",[define_array objectAtIndex:0]);
    if (define_array.count > 0)
    {
        Sample * s = [define_array objectAtIndex:0];
        s.name = [NSString stringWithFormat:@"%@",self.first_name.text];
        s.last = [NSString stringWithFormat:@"%@",self.last_name.text];
        s.age = [NSNumber numberWithInt:[self.age.text integerValue]];
        s.gender = [NSString stringWithFormat:@"%@",self.gender_button.titleLabel.text];
        s.profile_name = [NSString stringWithFormat:@"%@",imageName];
    }
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    

}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.sample_profile.clipsToBounds = YES;
    self.sample_profile.layer.cornerRadius = 54.0f;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"SelectRecord = %d",SelectRecord);
   // NSArray * myarray = [[NSArray alloc] initWithArray:[self GetUserData:Select_Name]];
    //Sample * s = [myarray objectAtIndex:0];
    
    
    self.first_name.text =[NameOfArr objectAtIndex:SelectRecord]; //s.name;
    self.last_name.text =[lastArr objectAtIndex:SelectRecord]; //s.last;
    self.age.text =[ageArr objectAtIndex:SelectRecord]; //[s.age stringValue];
    [self.gender_button setTitle:[genderArr objectAtIndex:SelectRecord] forState:UIControlStateNormal];
    NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",[profile_nameArr objectAtIndex:SelectRecord]];
    NSURL *imageURL = [NSURL URLWithString:imagestring];
    NSString *key = [imagestring MD5Hash];
    NSData *data = [FTWCache objectForKey:key];
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        self.sample_profile.image=image;
    } else {
        
        dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue1, ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            [FTWCache setObject:data forKey:key];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.sample_profile.image=image;

            });
        });
    }
    genderarray = [[NSMutableArray alloc] initWithObjects:@"Male",@"Female",@"Other",nil];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)DropDownButton:(id)sender {
    
    NSLog(@"button click");
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
                
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
                {
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.delegate = self;
                    imagePicker.allowsEditing = YES;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    UIPopoverController *popover1 = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
                    [popover1 presentPopoverFromRect:CGRectMake(-120, 390, 1000, 500) inView:self.view permittedArrowDirections:nil animated:YES];
                    
                    //                    [popover1 presentPopoverFromRect:self.profile_image.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
                    self.popover = popover1;
                    //                    [self presentViewController:imagePicker animated:YES completion:nil];
                }
                else
                {
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.delegate = self;
                    imagePicker.allowsEditing = YES;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }
                //                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                //                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //                picker.delegate = self;
                //                [self presentModalViewController:picker animated:YES];
                //                [picker release];
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
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    image = [image resizedImage:CGSizeMake(200, 200) interpolationQuality:kCGInterpolationHigh];
    NSLog(@"image == %@",image);
    
    self.sample_profile.image = image;
    
    
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

#pragma mark - Dropdown delegate

- (void) niDropDownDelegateMethod: (NIDropDown *) sender
{
    [self rel];
}

-(void)rel
{
    dropDown = nil;
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
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.first_name resignFirstResponder];
    [self.last_name resignFirstResponder];
    [self.age resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_first_name release];
    [_last_name release];
    [_age release];
    [_gender_button release];
    [_sample_profile release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setFirst_name:nil];
    [self setLast_name:nil];
    [self setAge:nil];
    [self setGender_button:nil];
    [self setSample_profile:nil];
    [super viewDidUnload];
}
- (IBAction)change_Image:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallary", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.alpha=0.90;
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
    [actionSheet release];
}
- (IBAction)update_data:(id)sender
{
    [self EditRecordFun];
   // NSString * tempImageName = [[NSString alloc] initWithFormat:@"%@%@",self.first_name.text,self.last_name.text];
   // [self update_record:Select_Name : tempImageName];
    NSData *imageData = UIImageJPEGRepresentation(self.sample_profile.image, 1);
    [imageData writeToFile:[NewAdddata PathOfBGImages:[profile_nameArr objectAtIndex:SelectRecord]] atomically:YES];
    [self.view makeToastActivity];
    // initialize the viewcontroller with a little delay, so that the UI displays the changes made above
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self.navigationController popViewControllerAnimated:YES];
        [self.view hideToastActivity];
    });
}
-(void)EditRecordFun
{
   // http://prajas.com/familytree/edit_data.php?name=&surname=&age=&gender=&profile_name=&fb_id=&ids=
    UIImage *uploadImage = [self.sample_profile.image resizedImage:CGSizeMake(200, 200) interpolationQuality:kCGInterpolationHigh];
    NSData *imagedata = UIImageJPEGRepresentation(uploadImage, 1.0);
   
    NSLog(@"self.first_name.text=%@",self.first_name.text);
    NSString *email = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"Email_save"];
    NSString *EXCHAGE;
    if([email length]==0)
    {
        EXCHAGE=userdeviceToken;
    }
    else
    {
        EXCHAGE=userdeviceToken;
    }
    
    
    
    NSURL *url = [NSURL URLWithString:@"http://prajas.com/familytree/edit_data.php"];
    ASIFormDataRequest *requestbyuid1 = [ASIFormDataRequest requestWithURL:url];
    [requestbyuid1 setRequestMethod:@"POST"];
    [requestbyuid1 setPostValue:self.first_name.text forKey:@"name"];
    [requestbyuid1 setPostValue:self.last_name.text forKey:@"surname"];
    [requestbyuid1 setPostValue:self.age.text forKey:@"age"];
    [requestbyuid1 setPostValue:self.gender_button.titleLabel.text forKey:@"gender"];
     [requestbyuid1 setPostValue:[profile_nameArr objectAtIndex:SelectRecord] forKey:@"profile_name"];
    [requestbyuid1 setPostValue:EXCHAGE forKey:@"fb_id"];
    [requestbyuid1 setPostValue:[IdsArr objectAtIndex:SelectRecord] forKey:@"ids"];
    [requestbyuid1 setData:imagedata withFileName:EXCHAGE andContentType:@"image/jpeg" forKey:@"userfile"];
    [requestbyuid1 setDidFinishSelector:@selector(Respods:)];
    [requestbyuid1 setDidFailSelector:@selector(failrequest:)];
    [requestbyuid1 setDelegate:self];
    [requestbyuid1 startSynchronous];
}
- (void)Respods:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"responsevalue For Edit=%@",responsevalue);
    EDIT_IS_DONE_BOOL=YES;
    
}
- (void)failrequest:(ASIHTTPRequest *)request
{
    NSLog(@"failrequest=%@",request);
    [self.view makeToast:@"Server is down please try again later" duration:3.0 position:@"center"];
}
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
