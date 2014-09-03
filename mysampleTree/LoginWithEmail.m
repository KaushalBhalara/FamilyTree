//
//  LoginWithEmail.m
//  Mera Parivar
//
//  Created by Prajas on 7/21/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import "LoginWithEmail.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "UIDevice+Resolutions.h"
#import "UIView+Toast.h"
#import "MyView.h"
#import "Reachability.h"
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;

@interface LoginWithEmail ()

@end

@implementation LoginWithEmail

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
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *email = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"Email_save"];
    if([email length]==0)
    {
        [self.Back_button_Only setHidden:NO];
    } 
    else
    {
        [self.Back_button_Only setHidden:YES];
         self.Email_Txt_Field.text=email;
    }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.Email_Txt_Field resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_Email_Txt_Field release];
    [_Back_button_Only release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setEmail_Txt_Field:nil];
    [self setBack_button_Only:nil];
    [super viewDidUnload];
}
- (BOOL)isValidEmail {
    BOOL stricterFilter = YES; 
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (IBAction)Login_Button:(id)sender
{
    EMAIL_FORM_VIEW=[[[NSString alloc]initWithFormat:@"%@",self.Email_Txt_Field.text]retain];
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus   remoteHostStatus = [reachability currentReachabilityStatus];
    
    if (remoteHostStatus == NotReachable)
    {
        //if no internet connection available
        NSLog(@"No Internet connection");
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet!" message:@"No Working Inernet Connection is found.\n\n If WiFi is enabled, try diabling WiFi or try another WiFi hotspot." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [self.view hideToastActivity];
    }
    else
    {
        if(self.Email_Txt_Field.text.length==0)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert...!" message:@"Please enter the vaild Email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"logged_in_with_Email"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.Email_Txt_Field.text forKey:@"Email_save"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.view makeToastActivity];
            // initialize the viewcontroller with a little delay, so that the UI displays the changes made above
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    MyView  *myview = [[MyView alloc] initWithNibName:@"MyView_Ipad" bundle:nil];
                    [self.navigationController pushViewController:myview animated:YES];
                }
                else
                {
                    if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
                    {
                        MyView  *myview = [[MyView alloc] initWithNibName:@"MyView" bundle:nil];
                        [self.navigationController pushViewController:myview animated:YES];
                    }
                    else
                    {
                        MyView  *myview = [[MyView alloc] initWithNibName:@"MyView_Iphone4" bundle:nil];
                        [self.navigationController pushViewController:myview animated:YES];
                    }
                }
                
                [self.view hideToastActivity];
            });
            
        }
    }
    NSLog(@"EMAIL_FORM_VIEW=%@",EMAIL_FORM_VIEW);
}
/*
-(void)CHECK_USER_EMAIL_VALIDATION
{
    NSString * urlstring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/PHP-Data-Services-master/services/data/family_tree/family_tree_service/checklogin/checklogin?secret=prajas&fb_id=%@",self.Email_Txt_Field.text];
    NSLog(@"urlstring==%@",urlstring);
    NSURL * myurl = [NSURL URLWithString:urlstring];
    ASIHTTPRequest *requestbyuidgetdata = [ASIHTTPRequest requestWithURL:myurl];
    [requestbyuidgetdata setDelegate:self];
    [requestbyuidgetdata setDidFinishSelector:@selector(RespodsValue_check:)];
    [requestbyuidgetdata setDidFailSelector:@selector(failrequest:)];
    [requestbyuidgetdata setDelegate:self];
    [requestbyuidgetdata startSynchronous];
}
- (void)RespodsValue_check:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSMutableArray *checkArr=[responsevalue valueForKey:@"check"];
    check_Status=[[NSString alloc]init];
    check_Status=[checkArr objectAtIndex:0];
    NSLog(@"responsevalue==%@",responsevalue);
    NSLog(@"check=%@",check_Status);
    
    if ([check_Status isEqualToString:@"1"])
    {
    }
    else
    {
    }
    [self.view hideToastActivity];
    
}
- (void)failrequest:(ASIHTTPRequest *)request
{
    [self.view hideToastActivity];
    NSLog(@"failrequest=%@",request);
}
*/
- (IBAction)Back_button:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
