//
//  MyView.m
//  Mera Parivar
//
//  Created by Prajas on 4/18/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import "MyView.h"
#import "UIDevice+Resolutions.h"
#import <QuartzCore/QuartzCore.h>
#import "UniversalUrl.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "LoginWithEmail.h"
#import "UIView+Toast.h"
#import <FacebookSDK/FacebookSDK.h>

@interface MyView ()

@end

@implementation MyView
@synthesize queue;
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
    
    storedata = [[NSMutableArray alloc] init];
    NSLog(@"EMAIL_FORM_VIEW==%@",EMAIL_FORM_VIEW);
    
    if([EMAIL_FORM_VIEW length]==0||EMAIL_FORM_VIEW==nil)
    {
        NSLog(@"facebookID=%@",facebookID);
         [self CHECK_USER_VALIDATION:facebookID];
    }
    else
    {
         [self CHECK_USER_VALIDATION:EMAIL_FORM_VIEW];
    }
}
-(void)CHECK_USER_VALIDATION:(NSString *)USER
{
    [self.view makeToastActivity];
    NSString * urlstring = [[NSString alloc] initWithString:CheckUserValidation_url];
    urlstring = [urlstring stringByReplacingOccurrencesOfString:@"USER" withString:USER];
     NSLog(@"urlstring==%@",urlstring);
    NSURL * myurl = [NSURL URLWithString:urlstring];
    ASIHTTPRequest *requestbyuidgetdata = [ASIHTTPRequest requestWithURL:myurl];
    [requestbyuidgetdata setDelegate:self];
    [requestbyuidgetdata setDidFinishSelector:@selector(RespodsValue_check:)];
    [requestbyuidgetdata setDidFailSelector:@selector(failrequest:)];
    [requestbyuidgetdata setDelegate:self];
    //[requestbyuidgetdata startSynchronous];
     [self.queue addOperation:requestbyuidgetdata];
}
- (void)RespodsValue_check:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    if(responsevalue.count!=0)
    {
        NSMutableArray *checkArr=[responsevalue valueForKey:@"check"];
        check_Status=[[NSString alloc]init];
        check_Status=[checkArr objectAtIndex:0];
        NSLog(@"responsevalue==%@",responsevalue);
        NSLog(@"check=%@",check_Status);
        
        if ([check_Status integerValue] > 0)
        {
            // [storedata addObject:@"My Tree"];
            [self.mytableview reloadData];
            NSString *EMAIL_FB_ID;
            if([EMAIL_FORM_VIEW length]==0||EMAIL_FORM_VIEW==nil)
            {
                NSLog(@"facebookID=%@",facebookID);
                EMAIL_FB_ID=facebookID;
            }
            else
            {
                EMAIL_FB_ID=EMAIL_FORM_VIEW;
            }
            NSString * mystr = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/PHP-Data-Services-master/services/data/family_tree/family_tree_service/check_flag/check_relative_flag?secret=prajas&fb_id=%@",EMAIL_FB_ID];
            NSURL * myurl = [NSURL URLWithString:mystr];
            NSLog(@"myurl = =%@",myurl);
            ASIHTTPRequest *requestTocheck = [ASIHTTPRequest requestWithURL:myurl];
            [requestTocheck setDelegate:self];
            [requestTocheck setDidFinishSelector:@selector(FirstTimeDeleteData:)];
            [requestTocheck setDidFailSelector:@selector(failrequest:)];
            [requestTocheck setDelegate:self];
            //[requestTocheck startSynchronous];
            [self.queue addOperation:requestTocheck];
            
        }
        else
        {
            //        self.mytree_label.text = @"Create Tree";
            [storedata addObject:@"Create Tree"];
            [self.mytableview reloadData];
            [self.view hideToastActivity];
        }
    }
    else
    {
        
    }
}
-(void)FirstTimeDeleteData:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
     NSLog(@"responsevalue==%@",responsevalue);
    
    if([responsevalue count]!=0)
    {
        NSMutableArray *checkArr=[responsevalue valueForKey:@"relative_flag"];
        NSString *status=[[NSString alloc]init];
        status=[checkArr objectAtIndex:0];
        NSLog(@"status==%@",status);
        if ([status isEqualToString:@"0"])
        {
            [[NSUserDefaults standardUserDefaults]
             setObject:@"NO" forKey:@"preferenceName1"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]
             setObject:@"YES" forKey:@"preferenceName1"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    NSString *EMAIL_FB_ID;
    if([EMAIL_FORM_VIEW length]==0||EMAIL_FORM_VIEW==nil)
    {
        NSLog(@"facebookID=%@",facebookID);
        EMAIL_FB_ID=facebookID;
    }
    else
    {
        EMAIL_FB_ID=EMAIL_FORM_VIEW;
    }
    
    NSString * mystr = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/get_share_name.php?fb_id=%@",EMAIL_FB_ID];
    NSURL * myurl = [NSURL URLWithString:mystr];
    ASIHTTPRequest *requestTocheck_SHARE_service = [ASIHTTPRequest requestWithURL:myurl];
    [requestTocheck_SHARE_service setDelegate:self];
    [requestTocheck_SHARE_service setDidFinishSelector:@selector(Check_WHO_SHARE_SERVICE:)];
    [requestTocheck_SHARE_service setDidFailSelector:@selector(failrequest:)];

    [requestTocheck_SHARE_service setDelegate:self];
    //[requestTocheck startSynchronous];
    [self.queue addOperation:requestTocheck_SHARE_service];

    
}
-(void)Check_WHO_SHARE_SERVICE:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    if([response length]>0)
    {
        NSDictionary *responsevalue = [response JSONValue];
        NSLog(@"responsevalue==%@",responsevalue);
        NSString *checkArr=[responsevalue valueForKey:@"family_tree"];
        NSMutableArray *tree=[checkArr valueForKey:@"tree"];
        
        user_id=[[NSMutableArray alloc]init];
        user_id=[[tree valueForKey:@"user_id"]retain];
        
        editable=[[NSMutableArray alloc]init];
        editable=[[tree valueForKey:@"editable"]retain];
        
        tree_name=[[NSMutableArray alloc]init];
        tree_name=[[tree valueForKey:@"tree_name"]retain];
        [self.mytableview reloadData];
    }
    [self.view hideToastActivity];

    
}

- (void)failrequest:(ASIHTTPRequest *)request
{
    NSLog(@"failrequest=%@",request);
     [self.mytableview reloadData];
    [self.view hideToastActivity];
    [self.view makeToast:@"Server is down please try again later" duration:3.0 position:@"center"];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mytree_label.shadowColor = [UIColor blackColor];
    self.mytree_label.shadowOffset = CGSizeMake(0,-1);
    self.mytree_label.layer.shadowOpacity = 0.1;
    self.mytree_label.layer.shadowRadius = 5.0;
    self.mytree_label.layer.masksToBounds = NO;
}

#pragma mark - Action Method
- (IBAction)myVIew:(id)sender
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(storedata.count==0)
    {
        return [editable count];
    }
    else
    {
        return [storedata count];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return 64;
    }
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    else
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    tableView.backgroundColor = [UIColor clearColor];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        UIView * backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 548, 54)];
        backgroundview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_unselected"]];
        
        UIImageView * myimage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 42, 42)];
        
        if(storedata.count==0)
        {
            if([[editable objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                myimage.image = [UIImage imageNamed:@"768_1024_eye.png"];
            }
            else
            {
                myimage.image = [UIImage imageNamed:@"768_1024_list.PNG"];
            }
        }
        else
        {
            myimage.image = [UIImage imageNamed:@"768_1024_list.PNG"];
        }
        [backgroundview addSubview:myimage];
        
        UILabel * titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(89, 8, 336, 38)];
        
        
        if(storedata.count==0)
        {
            titlelabel.text =[tree_name objectAtIndex:indexPath.row];
        }
        else
        {
            titlelabel.text =[storedata objectAtIndex:indexPath.row];
        }
        titlelabel.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
        titlelabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f];
        titlelabel.backgroundColor = [UIColor clearColor];
        titlelabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        titlelabel.layer.shadowOffset = CGSizeMake(0, -1);
        titlelabel.layer.shadowOpacity = 1.0;
        titlelabel.layer.shadowRadius = 1.0;
        titlelabel.layer.masksToBounds = YES;
        [backgroundview addSubview:titlelabel];
        [cell.contentView addSubview:backgroundview];
        
        UIView *bgColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 548, 54)];
        bgColorView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_selected"]];
        [cell setSelectedBackgroundView:bgColorView];
    }else
    {
        if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
        {
            UIView * backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 248, 30)];
            backgroundview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone5_unselected"]];
             UIImageView * myimage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 25, 24)];
            
            if(storedata.count==0)
            {
                if([[editable objectAtIndex:indexPath.row] isEqualToString:@"0"])
                {
                    myimage.image = [UIImage imageNamed:@"320_568_eye.png"];
                }
                else
                {
                    myimage.image = [UIImage imageNamed:@"tree_icon_Iphone.PNG"];
                }
            }
            else
            {
                myimage.image = [UIImage imageNamed:@"tree_icon_Iphone.PNG"];
            }
            [backgroundview addSubview:myimage];
            
            UILabel * titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 4, 190, 21)];
            if(storedata.count==0)
            {
                 titlelabel.text =[tree_name objectAtIndex:indexPath.row];
            }
            else
            {
                 titlelabel.text =[storedata objectAtIndex:indexPath.row];
            }
           
            titlelabel.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
            titlelabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
            titlelabel.backgroundColor = [UIColor clearColor];
            titlelabel.layer.shadowColor = [[UIColor blackColor] CGColor];
            titlelabel.layer.shadowOffset = CGSizeMake(0, -1);
            titlelabel.layer.shadowOpacity = 1.0;
            titlelabel.layer.shadowRadius = 1.0;
            titlelabel.layer.masksToBounds = YES;
            [backgroundview addSubview:titlelabel];
            [cell.contentView addSubview:backgroundview];
            UIView *bgColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 248, 29)];
            bgColorView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone5_selected"]];
            [cell setSelectedBackgroundView:bgColorView];
        }
        else
        {
            UIView * backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 205, 30)];
            backgroundview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone_unselected"]];
            UIImageView * myimage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 18, 18)];
            
            if(storedata.count==0)
            {
                if([[editable objectAtIndex:indexPath.row] isEqualToString:@"0"])
                {
                    myimage.image = [UIImage imageNamed:@"320_480_eye.PNG"];
                }
                else
                {
                    myimage.image = [UIImage imageNamed:@"tree_icon_Iphone4.PNG"];
                    
                }
            }
            else
            {
                myimage.image = [UIImage imageNamed:@"tree_icon_Iphone4.PNG"];
            }
            
            
            
            [backgroundview addSubview:myimage];
            UILabel * titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 3, 153, 20)];
            
            if(storedata.count==0)
            {
                titlelabel.text =[tree_name objectAtIndex:indexPath.row];
            }
            else
            {
                titlelabel.text =[storedata objectAtIndex:indexPath.row];
            }
           // titlelabel.text =[tree_name objectAtIndex:indexPath.row];
            titlelabel.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
            titlelabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
            titlelabel.backgroundColor = [UIColor clearColor];
            titlelabel.layer.shadowColor = [[UIColor blackColor] CGColor];
            titlelabel.layer.shadowOffset = CGSizeMake(0, -1);
            titlelabel.layer.shadowOpacity = 1.0;
            titlelabel.layer.shadowRadius = 1.0;
            titlelabel.layer.masksToBounds = YES;
            [backgroundview addSubview:titlelabel];
//            [mainBackgorund addSubview:backgroundview];
            [cell.contentView addSubview:backgroundview];
//            UIView * backgroundslected  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 205, 40)];
//            backgroundslected.backgroundColor =[UIColor clearColor];
            UIView *bgColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 205, 40)];
            bgColorView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone_selected"]];
//            [backgroundslected addSubview:bgColorView];
            [cell setSelectedBackgroundView:bgColorView];
        }
    }
    
    // Configure the cell...
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        Ckeck_For_Share_Button=YES;
    }
    else
    {
        Ckeck_For_Share_Button=NO;
    }
    CLICKTREEBOOL=YES;
    if ([check_Status integerValue]!=0)
    {
        NSLog(@"Condition True");
        //Change the Bool if Editable or not From here
        if([[editable objectAtIndex:indexPath.row] isEqualToString:@"0"])
        {
            EDIT_OR_VIEW_BOOL=NO;
        }
        else
        {
            EDIT_OR_VIEW_BOOL=YES;
        }
        
         Pass_User_ID=[[NSString alloc]initWithFormat:@"%@",[user_id objectAtIndex:indexPath.row]];
        Tree_title_String=[[NSString alloc]initWithFormat:@"%@",[tree_name objectAtIndex:indexPath.row]];
       // facebookID=Pass_User_ID;
        [self.view makeToastActivity];
        // initialize the viewcontroller with a little delay, so that the UI displays the changes made above
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                mytreeView = [[TreeViewContoller
                               alloc] initWithNibName:@"TreeViewController_Ipad" bundle:nil];
                [self.navigationController pushViewController:mytreeView animated:YES];
            }
            else
            {
                NSLog(@"Iphone");
                if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
                {
                    NSLog(@"Iphone 5");
                    mytreeView = [[TreeViewContoller
                                   alloc] initWithNibName:@"TreeViewContoller" bundle:nil];
                    [self.navigationController pushViewController:mytreeView animated:YES];
                }
                else
                {
                    NSLog(@"Iphone 4");
                    mytreeView = [[TreeViewContoller
                                   alloc] initWithNibName:@"TreeViewController_Iphone4" bundle:nil];
                    [self.navigationController pushViewController:mytreeView animated:YES];
                }
            }
            [self.view hideToastActivity];
        });

        
        
    }
    else
    {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            myidentity = [[MyidentityView
                           alloc] initWithNibName:@"MyidentityView_Ipad" bundle:nil];
            [self.navigationController pushViewController:myidentity animated:YES];
        }
        else
        {
            if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
            {
                myidentity = [[MyidentityView
                               alloc] initWithNibName:@"MyidentityView" bundle:nil];
                [self.navigationController pushViewController:myidentity animated:YES];
            }
            else
            {
                myidentity = [[MyidentityView
                               alloc] initWithNibName:@"MyidentityView_Iphone4" bundle:nil];
                [self.navigationController pushViewController:myidentity animated:YES];
            }
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [_mytree_label release];
    [_title_label release];
    [_mytableview release];
    [super dealloc];
}
- (void)viewDidUnload {
    
    [self setMytree_label:nil];
    [self setTitle_label:nil];
    [self setMytableview:nil];
    [super viewDidUnload];
}

- (IBAction)LogOut_Button_Press:(id)sender
{
    NSLog(@"Logged out Facebook Or Email both From here");
    
    //************Clear Email Login Also************************************
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Email_save"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //***********************************************************************
    
    FBSession* session = [FBSession activeSession];
    [session closeAndClearTokenInformation];
    [session close];
    [FBSession setActiveSession:nil];
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    /*
    FBSession* session = [FBSession activeSession];
    [session closeAndClearTokenInformation];
    [session close];
    [FBSession setActiveSession:nil];
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* facebookCookies = [cookies cookiesForURL:[NSURL URLWithString:@"https://facebook.com/"]];
    
    for (NSHTTPCookie* cookie in facebookCookies)
    {
        [cookies deleteCookie:cookie];
    }*/
    //[self authorizeWithFBAppAuth:NO safariAuth:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
