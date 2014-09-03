//
//  NewAdddata.m
//  treeeeeeeee
//
//  Created by Prajas on 4/30/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import "NewAdddata.h"
#import "Sample.h"
#import "AppDelegate.h"
#import "UIImage+Resize.h"
#import "SBJson.h"
#import "UIView+Toast.h"

#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define ORIGINAL_MAX_WIDTH 640.0f

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;


CGFloat compression = 0.7f;
CGFloat maxCompression = 0.1f;
int maxFileSize = 250*1024;

@interface NewAdddata ()<VPImageCropperDelegate>

@end

@implementation NewAdddata
@synthesize popover,queue;

+ (NSString *)PathOfBGImages : (NSString *)Filename
{
    NSArray *path3 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentfolder3 = [path3 objectAtIndex:0];
    return [documentfolder3 stringByAppendingPathComponent:Filename];
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
#pragma mark - Dropdown delegate

- (void) niDropDownDelegateMethod: (NIDropDown *) sender
{
    [self rel];
}

-(void)rel
{
    dropDown = nil;
}
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
    if (![self queue]) {
        [self setQueue:[[[NSOperationQueue alloc] init] autorelease]];
    }
    [self.gender_button setTitle:@"Male"forState:UIControlStateNormal];
    genderarray = [[NSMutableArray alloc] initWithObjects:@"Male",@"Female",@"Other",nil];
    NSLog(@"Lastdata --> %d",LASTID);
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        self.profile_image.clipsToBounds = YES;
        self.profile_image.layer.cornerRadius = 112.5;
        [self.profile_image.layer setMasksToBounds:YES];
        [self.profile_image setContentMode:UIViewContentModeScaleAspectFill];
        
    }
    else
    {
        self.profile_image.clipsToBounds = YES;
        self.profile_image.layer.cornerRadius = 55.0;
        [self.profile_image.layer setMasksToBounds:YES];
        [self.profile_image setContentMode:UIViewContentModeScaleAspectFill];
    }    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.name_textfield resignFirstResponder];
    [self.last_textfield resignFirstResponder];
    [self.Age_textfield resignFirstResponder];
}
- (void)dealloc {
    [_name_textfield release];
    [_profile_image release];
    [_last_name release];
    [_last_textfield release];
    [_Age_textfield release];
    [_gender_button release];
    [super dealloc];
}


- (IBAction)savedata:(id)sender
{
    [self.view makeToastActivity];
    if([self.name_textfield.text isEqualToString:@""]||[self.last_textfield.text isEqualToString:@""] || [self.Age_textfield.text isEqualToString:@""])
    {
        [self.view hideToastActivity];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert..." message:@"Please fill Up Value" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        NSString * temp = [[NSString alloc] initWithFormat:@"%@",ADDWHICH];
        NSLog(@"counter Final == %d",LASTID);
        NSLog(@"temp == %@",temp);
        
        if ([temp isEqualToString:@"Parent"])
        {
            NSData *imageData = UIImageJPEGRepresentation(self.profile_image.image, 1);
            [imageData writeToFile:[NewAdddata PathOfBGImages:[NSString stringWithFormat:@"%@%@",self.name_textfield.text,self.last_textfield.text]] atomically:YES];
            //[self parent];
            [self parent_data_add];
        }
        else if ([temp isEqualToString:@"Child"])
        {
            NSData *imageData = UIImageJPEGRepresentation(self.profile_image.image, 1);
            [imageData writeToFile:[NewAdddata PathOfBGImages:[NSString stringWithFormat:@"%@%@",self.name_textfield.text,self.last_textfield.text]] atomically:YES];
            //[self child];
            [self child_data_add];
        }
        else if ([temp isEqualToString:@"Sybiling"])
        {
            NSData *imageData = UIImageJPEGRepresentation(self.profile_image.image, 1);
            [imageData writeToFile:[NewAdddata PathOfBGImages:[NSString stringWithFormat:@"%@%@",self.name_textfield.text,self.last_textfield.text]] atomically:YES];
//            [self sybiling];
            [self sibling_data_add];
        }
       
        
        else if ([temp isEqualToString:@"Wife"])
        {
            NSLog(@"WIFE CALL");
            NSData *imageData = UIImageJPEGRepresentation(self.profile_image.image, 1);
            [imageData writeToFile:[NewAdddata PathOfBGImages:[NSString stringWithFormat:@"%@%@",self.name_textfield.text,self.last_textfield.text]] atomically:YES];
            //[self spouse:WifeId];
            [self spousData:WifeId];
        }
    }
    EDITFAMILYBOOL=YES;
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addImage:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallary", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.alpha=0.90;
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
    [actionSheet release];
    
}
#pragma mark Http Request 
-(void)sibling_data_add
{
   // NSString * urlstring = [[NSString alloc] initWithFormat:@"%@name=%@&surname=%@&age=%@&gender=%@&profile_name=%@%@&fb_id=%@",sibling_URL,self.name_textfield.text,self.last_textfield.text,self.Age_textfield.text,self.gender_button.titleLabel.text,self.name_textfield.text,self.last_textfield.text,facebookID];
    
    UIImage  *uploadImage = [self.profile_image.image resizedImage:CGSizeMake(400, 400) interpolationQuality:kCGInterpolationHigh];
    NSData *imagedata = UIImageJPEGRepresentation(uploadImage, 1.0);
    NSString *ProfName=[[NSString alloc]initWithFormat:@"%@%@",self.name_textfield.text,self.last_textfield.text];
    NSURL * myurl = [NSURL URLWithString:sibling_URL];
    NSLog(@"insert_URL = =%@",insert_URL);
    
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
    NSLog(@"EXCHAGE = =%@",EXCHAGE);
    
    ASIFormDataRequest *requestbyuidsibling = [ASIFormDataRequest requestWithURL:myurl];
    [requestbyuidsibling setPostValue:EXCHAGE forKey:@"fb_id"];
    [requestbyuidsibling setPostValue:self.gender_button.titleLabel.text forKey:@"gender"];
    [requestbyuidsibling setPostValue:self.last_textfield.text forKey:@"surname"];
    [requestbyuidsibling setPostValue:self.name_textfield.text forKey:@"name"];
    [requestbyuidsibling setPostValue:self.Age_textfield.text forKey:@"age"];
    [requestbyuidsibling setPostValue:ProfName forKey:@"profile_name"];
    [requestbyuidsibling setData:imagedata withFileName:EXCHAGE andContentType:@"image/jpeg" forKey:@"userfile"];
    [requestbyuidsibling setDelegate:self];
    [requestbyuidsibling setDidFinishSelector:@selector(requestDoneSiblingAdd:)];
    [requestbyuidsibling setDidFailSelector:@selector(requestFailed:)];
    [self.queue addOperation:requestbyuidsibling];
    
    /*
    urlstring = [urlstring stringByReplacingOccurrencesOfString:@" "  withString:@"%20"];
    NSLog(@"urlstring == %@",urlstring);
    NSURL * myurl = [NSURL URLWithString:urlstring];
    ASIHTTPRequest *requestbyuidsibling = [ASIHTTPRequest requestWithURL:myurl];
    [requestbyuidsibling setDelegate:self];
    [requestbyuidsibling setDidFinishSelector:@selector(requestDoneSiblingAdd:)];
    [self.queue addOperation:requestbyuidsibling];*/
}

- (void)requestDoneSiblingAdd:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"Insert Value requestDoneSiblingAdd = %@",responsevalue);
    [self.navigationController popViewControllerAnimated:YES];
      [self.view hideToastActivity];
}

-(void)child_data_add
{
    //NSString * urlstring = [[NSString alloc] initWithFormat:@"%@name=%@&surname=%@&age=%@&gender=%@&profile_name=%@%@&fb_id=%@",child_URL,self.name_textfield.text,self.last_textfield.text,self.Age_textfield.text,self.gender_button.titleLabel.text,self.name_textfield.text,self.last_textfield.text,facebookID];
    
    UIImage  *uploadImage = [self.profile_image.image resizedImage:CGSizeMake(400, 400) interpolationQuality:kCGInterpolationHigh];
    NSData *imagedata = UIImageJPEGRepresentation(uploadImage, 1.0);
    NSString *ProfName=[[NSString alloc]initWithFormat:@"%@%@",self.name_textfield.text,self.last_textfield.text];
    NSURL * myurl = [NSURL URLWithString:child_URL];
    NSLog(@"insert_URL = =%@",insert_URL);
    
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
    ASIFormDataRequest *requestbyuidchild = [ASIFormDataRequest requestWithURL:myurl];
    [requestbyuidchild setPostValue:EXCHAGE forKey:@"fb_id"];
    [requestbyuidchild setPostValue:self.gender_button.titleLabel.text forKey:@"gender"];
    [requestbyuidchild setPostValue:self.last_textfield.text forKey:@"surname"];
    [requestbyuidchild setPostValue:self.name_textfield.text forKey:@"name"];
    [requestbyuidchild setPostValue:self.Age_textfield.text forKey:@"age"];
    [requestbyuidchild setPostValue:ProfName forKey:@"profile_name"];
    [requestbyuidchild setData:imagedata withFileName:EXCHAGE andContentType:@"image/jpeg" forKey:@"userfile"];
    [requestbyuidchild setDelegate:self];
    [requestbyuidchild setDidFinishSelector:@selector(requestDoneChildAdd:)];
    [requestbyuidchild setDidFailSelector:@selector(requestFailed:)];
    [self.queue addOperation:requestbyuidchild];
    
    /*
    urlstring = [urlstring stringByReplacingOccurrencesOfString:@" "  withString:@"%20"];
    NSLog(@"urlstring == %@",urlstring);
    NSURL * myurl = [NSURL URLWithString:urlstring];
    ASIHTTPRequest *requestbyuidchild = [ASIHTTPRequest requestWithURL:myurl];
    [requestbyuidchild setDelegate:self];
    [requestbyuidchild setDidFinishSelector:@selector(requestDoneChildAdd:)];
    [self.queue addOperation:requestbyuidchild];*/
}

- (void)requestDoneChildAdd:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"Insert Value requestDoneSiblingAdd = %@",responsevalue);
    [self.navigationController popViewControllerAnimated:YES];
      [self.view hideToastActivity];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
      [self.view hideToastActivity];
    [self.view makeToast:@"Server is down please try again later" duration:3.0 position:@"center"];

}
-(void)parent_data_add
{
    // NSString * urlstring = [[NSString alloc] initWithFormat:@"%@name=%@&surname=%@&age=%@&gender=%@&profile_name=%@%@&fb_id=%@",parent_URL,self.name_textfield.text,self.last_textfield.text,self.Age_textfield.text,self.gender_button.titleLabel.text,self.name_textfield.text,self.last_textfield.text,facebookID];
    
    UIImage  *uploadImage = [self.profile_image.image resizedImage:CGSizeMake(400, 400) interpolationQuality:kCGInterpolationHigh];
    NSData *imagedata = UIImageJPEGRepresentation(uploadImage, 1.0);
    NSString *ProfName=[[NSString alloc]initWithFormat:@"%@%@",self.name_textfield.text,self.last_textfield.text];
    NSURL * myurl = [NSURL URLWithString:parent_URL];
    NSLog(@"insert_URL = =%@",insert_URL);
    
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
    ASIFormDataRequest *requestbyuidpapa = [ASIFormDataRequest requestWithURL:myurl];
    [requestbyuidpapa setPostValue:EXCHAGE forKey:@"fb_id"];
    [requestbyuidpapa setPostValue:self.gender_button.titleLabel.text forKey:@"gender"];
    [requestbyuidpapa setPostValue:self.last_textfield.text forKey:@"surname"];
    [requestbyuidpapa setPostValue:self.name_textfield.text forKey:@"name"];
    [requestbyuidpapa setPostValue:self.Age_textfield.text forKey:@"age"];
    [requestbyuidpapa setPostValue:ProfName forKey:@"profile_name"];
    [requestbyuidpapa setData:imagedata withFileName:EXCHAGE andContentType:@"image/jpeg" forKey:@"userfile"];
    [requestbyuidpapa setDelegate:self];
    [requestbyuidpapa setDidFinishSelector:@selector(requestDoneParentAdd:)];
    [requestbyuidpapa setDidFailSelector:@selector(requestFailed:)];
    [self.queue addOperation:requestbyuidpapa];
    
}

- (void)requestDoneParentAdd:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    [self.navigationController popViewControllerAnimated:YES];
  [self.view hideToastActivity];
    NSLog(@"Insert Value requestDoneParentAdd = %@",responsevalue );
}
-(void)spousData :(NSString *)idsWife
{
    UIImage  *uploadImage = [self.profile_image.image resizedImage:CGSizeMake(400, 400) interpolationQuality:kCGInterpolationHigh];
    NSData *imagedata = UIImageJPEGRepresentation(uploadImage, 1.0);
    NSString *ProfName=[[NSString alloc]initWithFormat:@"%@%@",self.name_textfield.text,self.last_textfield.text];
    
    NSURL * myurl = [NSURL URLWithString:SpouseAdd_URL];
    NSLog(@"SpouseAdd_URL =%@",SpouseAdd_URL);
    
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
   // http://prajas.com/familytree/add_spouse.php?name=sdkskd&surname=dks&age=1&gender=ksk&profile_name=dfkjdk&fb_id=dsld&ids=dfd
    ASIFormDataRequest *requestbyuidspouse = [ASIFormDataRequest requestWithURL:myurl];
    [requestbyuidspouse setPostValue:idsWife forKey:@"ids"];
    [requestbyuidspouse setPostValue:EXCHAGE forKey:@"fb_id"];
    [requestbyuidspouse setPostValue:self.gender_button.titleLabel.text forKey:@"gender"];
    [requestbyuidspouse setPostValue:self.last_textfield.text forKey:@"surname"];
    [requestbyuidspouse setPostValue:self.name_textfield.text forKey:@"name"];
    [requestbyuidspouse setPostValue:self.Age_textfield.text forKey:@"age"];
    [requestbyuidspouse setPostValue:ProfName forKey:@"profile_name"];
    [requestbyuidspouse setData:imagedata withFileName:EXCHAGE andContentType:@"image/jpeg" forKey:@"userfile"];
    [requestbyuidspouse setDelegate:self];
    [requestbyuidspouse setDidFinishSelector:@selector(requestDoneSpousAdd:)];
    [requestbyuidspouse setDidFailSelector:@selector(requestFailed:)];

    [self.queue addOperation:requestbyuidspouse];
    
}

- (void)requestDoneSpousAdd:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    [self.navigationController popViewControllerAnimated:YES];
      [self.view hideToastActivity];
    NSLog(@"Insert Value requestDoneParentAdd = %@",responsevalue );
}
#pragma mark - Object Method

-(void)spouse :(NSString *)UpdateId
{
    NSLog(@"Update Id = %@",UpdateId);
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    Sample *s = [NSEntityDescription insertNewObjectForEntityForName:@"Sample" inManagedObjectContext:context];
    
    s.name = self.name_textfield.text;
    s.ids = [NSString stringWithFormat:@"%d",LASTID];
    s.parent =@"";
    s.child = @"";
    s.sibling = @"";
    s.number = 0;
    s.last = self.last_textfield.text;
    s.age = [NSNumber numberWithInt:[self.Age_textfield.text intValue]];
    s.gender = self.gender_button.titleLabel.text;
    s.profile_name = [NSString stringWithFormat:@"%@%@",self.name_textfield.text,self.last_textfield.text];
    s.spouse = @"NO";
    
    
    
    NSError *error;
    
    if (![context save:&error])
    {
        NSLog(@"Ohhhhh You are fool because no memory you have");
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ids == %@", UpdateId];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray * define_array = [context executeFetchRequest:request error:&error];
    NSLog(@"define array == %@",[define_array objectAtIndex:0]);
    if (define_array.count > 0)
    {
        Sample * s = [define_array objectAtIndex:0];
        s.spouse = [NSString stringWithFormat:@"%d",LASTID];
    }
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)parent
{
   
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]                           stringForKey:@"preferenceName10"];
    NSLog(@"savedata === %@",savedValue);
    if (savedValue == nil)
    {
        NSLog(@"callll this ---->");
        PARENTCOUNTER = 2;

        [[NSUserDefaults standardUserDefaults]
         setObject:@"2" forKey:@"preferenceName10"];
        [[NSUserDefaults standardUserDefaults] synchronize];       
    }
    else
    {
        NSLog(@"callll this ----> %d",PARENTCOUNTER);
        PARENTCOUNTER = [savedValue integerValue];
        PARENTCOUNTER = 1 + PARENTCOUNTER;
        [[NSUserDefaults standardUserDefaults]
         setObject:[NSString stringWithFormat:@"%d",PARENTCOUNTER] forKey:@"preferenceName10"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    Sample *s = [NSEntityDescription insertNewObjectForEntityForName:@"Sample" inManagedObjectContext:context];
    
    s.name = self.name_textfield.text;
    s.ids = [NSString stringWithFormat:@"%d",LASTID];
    s.parent =@"";
    s.child = [NSString stringWithFormat:@"%@,",IDS];
    s.sibling = @"";
    s.number = [NSNumber numberWithInt:PARENTCOUNTER];
    s.last = self.last_textfield.text;
    s.age = [NSNumber numberWithInt:[self.Age_textfield.text intValue]];
    s.gender = self.gender_button.titleLabel.text;
    s.profile_name = [NSString stringWithFormat:@"%@%@",self.name_textfield.text,self.last_textfield.text];
    s.spouse = @"";
    
    
    
    NSError *error;
    
    if (![context save:&error])
    {
        NSLog(@"Ohhhhh You are fool because no memory you have");
    }
    
    
    NSManagedObject * device = [mynewarray objectAtIndex:0];
    [device setValue:NAME forKey:@"name"];
    [device setValue:IDS forKey:@"ids"];
    if ([PARENT isEqualToString:@"<null>"] || PARENT == nil)
    {
        [device setValue:[NSString stringWithFormat:@"%d,",LASTID] forKey:@"parent"];
    }
    else
    {
        [device setValue:[NSString stringWithFormat:@"%@%d,",PARENT,LASTID] forKey:@"parent"];
    }
    
    [device setValue:CHILD forKey:@"child"];
    [device setValue:SYBILING forKey:@"sibling"];
    
    NSError *error1;
    
    if (![context save:&error1])
    {
        NSLog(@"Ohhhhh You are fool because no memory you have");
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)child
{
    if ([CHILD isEqualToString:@"<null>"] || CHILD.length >0)
    {
//        CHILD = @"0,";
    }
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    
    Sample *s = [NSEntityDescription insertNewObjectForEntityForName:@"Sample" inManagedObjectContext:context];
    

    s.name = self.name_textfield.text;
    s.ids = [NSString stringWithFormat:@"%d",LASTID];
    s.parent =[NSString stringWithFormat:@"%@,",IDS];
    s.child = @"";
    s.sibling = @"";
    s.number = [NSNumber numberWithInt:0];
    s.last = self.last_textfield.text;
    s.age = [NSNumber numberWithInt:[self.Age_textfield.text intValue]];
    s.gender = self.gender_button.titleLabel.text;
    s.profile_name = [NSString stringWithFormat:@"%@%@",self.name_textfield.text,self.last_textfield.text];
    s.spouse = @"";
    
    NSError *error;
    
    if (![context save:&error])
    {
        NSLog(@"Ohhhhh You are fool because no memory you have");
    }
     
    
    NSManagedObject * device = [mynewarray objectAtIndex:0];
    
    [device setValue:NAME forKey:@"name"];
    [device setValue:IDS forKey:@"ids"];
    [device setValue:PARENT forKey:@"parent"];
    if ([CHILD isEqualToString:@"<null>"] || CHILD == nil)
    {
        [device setValue:[NSString stringWithFormat:@"%d,",LASTID] forKey:@"child"];
    }
    else
    {
        [device setValue:[NSString stringWithFormat:@"%@%d,",CHILD,LASTID] forKey:@"child"];
    }
    
    [device setValue:SYBILING forKey:@"sibling"];
     
    NSError *error1;
    
    if (![context save:&error1])
    {
        NSLog(@"Ohhhhh You are fool because no memory you have");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sybiling
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    Sample *s = [NSEntityDescription insertNewObjectForEntityForName:@"Sample" inManagedObjectContext:context];
    
    s.name = self.name_textfield.text;
    s.ids = [NSString stringWithFormat:@"%d",LASTID];
    s.number = [NSNumber numberWithInt:1];
    s.parent =@"";
    s.child = @"";
    s.sibling = [NSString stringWithFormat:@"%@,",IDS];
    s.last = self.last_textfield.text;
    s.age = [NSNumber numberWithInt:[self.Age_textfield.text intValue]];
    s.gender = self.gender_button.titleLabel.text;
    s.profile_name = [NSString stringWithFormat:@"%@%@",self.name_textfield.text,self.last_textfield.text];
    s.spouse = @"";
    
    
    NSError *error;
    
    if (![context save:&error])
    {
        NSLog(@"Ohhhhh You are fool because no memory you have");
    }
    
    NSManagedObject * device = [mynewarray objectAtIndex:0];
    [device setValue:NAME forKey:@"name"];
    [device setValue:IDS forKey:@"ids"];
    [device setValue:PARENT forKey:@"parent"];
    [device setValue:CHILD forKey:@"child"];
    [device setValue:[NSNumber numberWithInt:1] forKey:@"number"];
    NSLog(@"SYBILING == %@ , LastID == %d",SYBILING ,LASTID);
    if ([SYBILING isEqualToString:@"<null>"] || SYBILING == nil || SYBILING.length == 0)
    {
        [device setValue:[NSString stringWithFormat:@"%d,",LASTID] forKey:@"sibling"];
    }
    else
    {
        NSLog(@"string is define that == %@",[NSString stringWithFormat:@"%@%d,",SYBILING,LASTID] );
        [device setValue:[NSString stringWithFormat:@"%@%d,",SYBILING,LASTID] forKey:@"sibling"];
    }
    
    NSError *error1;
    
    if (![context save:&error1])
    {
        NSLog(@"Ohhhhh You are fool because no memory you have");
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Actionsheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /*
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
     */
    
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
    /*
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    image = [image resizedImage:CGSizeMake(400, 400) interpolationQuality:kCGInterpolationHigh];
    

    self.profile_image.image = image;
    */
    

    
    
    
    
   
    //[picker dismissModalViewControllerAnimated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    
    editedImage = [editedImage resizedImage:CGSizeMake(400, 400) interpolationQuality:kCGInterpolationHigh];
    self.profile_image.image = editedImage;
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

- (void)viewDidUnload {
    [self setProfile_image:nil];
    [self setLast_name:nil];
    [self setLast_textfield:nil];
    [self setAge_textfield:nil];
    [self setGender_button:nil];
    [super viewDidUnload];
}
@end
