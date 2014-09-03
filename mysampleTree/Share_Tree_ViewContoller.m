//
//  Share_Tree_ViewContoller.m
//  Mera Parivar
//
//  Created by Prajas on 7/21/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import "Share_Tree_ViewContoller.h"
#import "UniversalUrl.h"
#import <QuartzCore/QuartzCore.h>
#import "FacebookFriend.h"
#import "UIView+Toast.h"

@interface Share_Tree_ViewContoller ()

@end

@implementation Share_Tree_ViewContoller

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
    [self.share_table reloadData];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_share_table release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setShare_table:nil];
    [super viewDidUnload];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)facebook_share:(id)sender
{
    NSString *email = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"Email_save"];
    if([email length]==0)
    {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            FacebookFriend *myfriends = [[FacebookFriend alloc] initWithNibName:@"FacebookFriend_Ipad" bundle:nil];
            myfriends.delegate = self;
            [self presentPopupViewController:myfriends animationType:MJPopupViewAnimationSlideBottomBottom];
        }
        else
        {
            FacebookFriend *myfriends = [[FacebookFriend alloc] initWithNibName:@"FacebookFriend_Iphone4" bundle:nil];
            myfriends.delegate = self;
            [self presentPopupViewController:myfriends animationType:MJPopupViewAnimationSlideBottomBottom];
        }
        
    }
    else
    {
        [self.view makeToast:@"you don't get your facebook friends list because you login with email" duration:3.0 position:@"center"];
    }
    
    
}
- (void)cancelButtonClicked:(FacebookFriend *)aSecondDetailViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
}
- (IBAction)mail_share:(id)sender
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Enter Email Address"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Share", nil];
    
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [message show];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    inputText = [[[alertView textFieldAtIndex:0] text]retain];
    
    if( [inputText length] >= 1 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch(buttonIndex) {
        case 0:
            NSLog(@"Cancle");
            break;
        case 1:
            NSLog(@"Done");
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Share from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"View & Edit", @"Only View", nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            actionSheet.alpha=0.90;
            actionSheet.tag = 1;
            [actionSheet showInView:self.view];
            [actionSheet release];
            break;
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
                NSLog(@"inputText edit=%@",inputText);
                NSString *email = [[NSUserDefaults standardUserDefaults]
                                   stringForKey:@"Email_save"];
                if([email length]==0)
                {
                     [self sharedata:facebookID :inputText :@"1" ];
                }
                else
                {
                    [self sharedata:email :inputText :@"1" ];
                }
                
                
            }
                break;
            case 1:
            {
                NSLog(@"inputText view=%@",inputText);
                NSString *email = [[NSUserDefaults standardUserDefaults]
                                   stringForKey:@"Email_save"];
                if([email length]==0)
                {
                    [self sharedata:facebookID :inputText :@"0" ];
                }
                else
                {
                    [self sharedata:email :inputText :@"0"];
                }
            }
                break;
            case 2:
            {
                [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
        
            }
                break;
        }
            break;
            
        default:
            break;
    }
}
-(void)sharedata :(NSString *)UserId :(NSString *)ShareId :(NSString *)edit
{
    
    NSString * tempsavedata = [[NSString alloc] initWithString:Share_URL];
    tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"EDIT" withString:edit]retain];
    tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"FROM" withString:UserId]retain];
    tempsavedata = [[tempsavedata stringByReplacingOccurrencesOfString:@"TO" withString:ShareId]retain];
    
    NSURL * myurl = [NSURL URLWithString:tempsavedata];
    NSLog(@"myurl = =%@",myurl);
    
    ASIHTTPRequest *requestTocheck = [ASIHTTPRequest requestWithURL:myurl];
    [requestTocheck setDelegate:self];
    [requestTocheck setDidFinishSelector:@selector(Share_Tree_URL:)];
    [requestTocheck setDidFailSelector:@selector(requestFailed:)];

    [requestTocheck setDelegate:self];
    [requestTocheck startSynchronous];
}
- (void)Share_Tree_URL:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"response Value update = %@",responsevalue);
    NSString * success = [responsevalue objectForKey:@"message"];
    if ([success isEqualToString:@"Operation success!"])
    {
         [self.view makeToast:@"Your Family tree is share successfully" duration:3.0 position:@"center"];
    }
    else
    {
        [self.view makeToast:@"Server is down please try again later" duration:3.0 position:@"center"];
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
     [self.view makeToast:@"Server is down please try again later" duration:3.0 position:@"center"];
}

@end
