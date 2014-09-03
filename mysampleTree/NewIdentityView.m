//
//  NewIdentityView.m
//  Mera Parivar
//
//  Created by Prajas on 4/22/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import "NewIdentityView.h"
#import "SBJson.h"
#import "UniversalUrl.h"
#import "UIView+Toast.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;

@interface NewIdentityView ()

@end

@implementation NewIdentityView

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
    genderarray = [[NSMutableArray alloc] initWithObjects:@"Male",@"Female",@"Other", nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Action Method

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)change_image:(id)sender
{
    
}

- (IBAction)savedata:(id)sender
{
    if (self.first_textfield.text.length >= 1 && self.surname_textfield.text.length >= 1 && self.age_textfield.text.length >= 1 && self.gender_button.titleLabel.text.length >= 1 && self.father_textfield.text.length >= 1 && self.mother_textfield.text.length >= 1 && self.spouse_textfield.text.length >= 1)
    {
        
        NSString * tempsavedata = [[NSString alloc] initWithString:SaveData];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"AAA" withString:facebookID]retain];
        
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"BBB" withString:facebookID] retain];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"CCC" withString:self.first_textfield.text] retain];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"DDD" withString:self.surname_textfield.text]retain];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"EEE" withString:self.age_textfield.text]retain];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"FFF" withString:self.gender_button.titleLabel.text]retain];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"GGG" withString:self.father_textfield.text]retain];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"HHH" withString:self.mother_textfield.text]retain];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"III" withString:self.spouse_textfield.text]retain];
        tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"JJJ" withString:facebookID]retain];
        
        NSLog(@"SaveData === %@",tempsavedata);
        
        NSURL * myurl = [NSURL URLWithString:tempsavedata];
        ASIHTTPRequest *requestbyuid = [ASIHTTPRequest requestWithURL:myurl];
        [requestbyuid setDelegate:self];
        [requestbyuid setDidFinishSelector:@selector(SaveDataEntry:)];
//        [[self queue] addOperation:requestbyuid];
        [requestbyuid startAsynchronous];
        
    }

}

- (void)SaveDataEntry:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"response Value = %@",responsevalue);
    NSString * success = [responsevalue objectForKey:@"message"];
    NSLog(@"Done");
    if ([success isEqualToString:@"Operation success!"])
    {
        NSLog(@"Done");
        [[NSUserDefaults standardUserDefaults]
         setObject:@"FirstTime" forKey:@"preferenceName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
//    [self.view hideToastActivity];
    
}

- (IBAction)gender:(id)sender
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
    
    if ([self.first_textfield isFirstResponder])
    {
        [self.first_textfield resignFirstResponder];
        [self.surname_textfield becomeFirstResponder];
    }
    else if ([self.surname_textfield isFirstResponder])
    {
        [self.surname_textfield resignFirstResponder];
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
        [self.first_textfield becomeFirstResponder];
    }
}

-(void)previousTextField
{
    
    if ([self.first_textfield isFirstResponder])
    {
        [self.first_textfield resignFirstResponder];
        [self.spouse_textfield becomeFirstResponder];
    }
    else if ([self.surname_textfield isFirstResponder])
    {
        [self.surname_textfield resignFirstResponder];
        [self.first_textfield becomeFirstResponder];
    }
    else if ([self.age_textfield isFirstResponder])
    {
        [self.age_textfield resignFirstResponder];
        [self.surname_textfield becomeFirstResponder];
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
    [self.first_textfield resignFirstResponder];
    [self.surname_textfield resignFirstResponder];
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
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.first_textfield resignFirstResponder];
    [self.father_textfield resignFirstResponder];
    [self.mother_textfield resignFirstResponder];
    [self.age_textfield resignFirstResponder];
    [self.spouse_textfield resignFirstResponder];
    [self.surname_textfield resignFirstResponder];
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


- (void)dealloc {
    [_first_textfield release];
    [_gender_button release];
    [_surname_textfield release];
    [_first_textfield release];
    [_age_textfield release];
    [_father_textfield release];
    [_mother_textfield release];
    [_spouse_textfield release];
    [_profile_image release];
    [_gender_button release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setFirst_textfield:nil];
    [self setGender_button:nil];
    [self setSurname_textfield:nil];
    [self setFirst_textfield:nil];
    [self setAge_textfield:nil];
    [self setFather_textfield:nil];
    [self setMother_textfield:nil];
    [self setSpouse_textfield:nil];
    [self setProfile_image:nil];
    [self setGender_button:nil];
    [super viewDidUnload];
}

@end
