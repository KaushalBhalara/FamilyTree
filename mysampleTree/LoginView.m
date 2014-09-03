//
//  LoginView.m
//  mysampleTree
//
//  Created by Prajas on 4/10/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import "LoginView.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIView+Toast.h"
#import "UIDevice+Resolutions.h"
#import "AppDelegate.h"
#import "Sample.h"
#import "MyidentityView.h"
#import "Reachability.h"
@interface LoginView ()

@end

@implementation LoginView

+ (NSString *)FacebookImageDirect : (NSString *)Filename
{
    NSArray *path3 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentfolder3 = [path3 objectAtIndex:0];
    return [documentfolder3 stringByAppendingPathComponent:Filename];
}

- (IBAction)Create_New_User_Button:(id)sender
{
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
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            
            email = [[LoginWithEmail alloc] initWithNibName:@"LoginWithEmail_Ipad" bundle:nil];
            [self.navigationController pushViewController:email animated:YES];
            
        }
        else
        {
            if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
            {
                
                
                email = [[LoginWithEmail alloc] initWithNibName:@"LoginWithEmail" bundle:nil];
                [self.navigationController pushViewController:email animated:YES];
            }
            else
            {
                
                email = [[LoginWithEmail alloc] initWithNibName:@"LoginWithEmailiPhone4" bundle:nil];
                [self.navigationController pushViewController:email animated:YES];        }
        }
    }
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
    self.navigationController.navigationBarHidden = YES;
    counter = 0;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"logged_in_with_Email"])
        {
            NSLog(@"Not login With Email");
        }
        else
        {
            NSLog(@"Already login with Email");
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                
                email = [[LoginWithEmail alloc] initWithNibName:@"LoginWithEmail" bundle:nil];
                [self.navigationController pushViewController:email animated:YES];
                
            }
            else
            {
                if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
                {
                    
                    
                    email = [[LoginWithEmail alloc] initWithNibName:@"LoginWithEmail" bundle:nil];
                    [self.navigationController pushViewController:email animated:YES];
                }
                else
                {
                    
                    email = [[LoginWithEmail alloc] initWithNibName:@"LoginWithEmailiPhone4" bundle:nil];
                    [self.navigationController pushViewController:email animated:YES];        }
            }
        }
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"logged_in"])
        {
            NSLog(@"Facebook Login");
            //        [self displayLogin];
        } else
        {
            //        [self displayMainScreen];
            NSLog(@"Already login");
            [self.view makeToastActivity];
            [self openSession];
            
        }
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

#pragma mark - Action Method

- (IBAction)facebook_login:(id)sender
{
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
        [self openSession];

    }

}

#pragma mark - Facebook Method
- (void)openSession
{
        
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email",@"user_relationships",@"user_relationship_details",@"user_friends",@"public_profile",@"read_friendlists", nil];
    [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session1, FBSessionState state, NSError *error){
        
        [self sessionStateChanged:session1 state:state error:error];
        
    }];
    permissions = nil;
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
        {
            [self.view makeToastActivity];
            [self getpersonalInfo];
            [self performSelector:@selector(getUserInfo)
                       withObject:nil
                       afterDelay:2.0];
            
//            [self getUserInfo];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
        {
            if(error)
            {
                NSLog(@"error==%@",error);
                [self.view hideToastActivity];
                 [self.view makeToast:@"Server is down please try again later" duration:2.0 position:@"center"];
            }
        }
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    if (error)
    {
//        AlertView *alert = [[AlertView alloc] initWithTitle:@"Error!" message:error.localizedDescription];
//        [alert show];
//        alert = nil;
    }
}
-(void)getpersonalInfo
{
   
    if (FBSession.activeSession.isOpen)
    {
        [FBRequestConnection startWithGraphPath:@"/me" parameters:[NSDictionary dictionaryWithObject:@"picture,id,birthday,email,name,gender,first_name,last_name,friends" forKey:@"fields"] HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
         {
            // NSLog(@"result === %@",result);
             NSDictionary * imageurl = [result objectForKey:@"picture"];
             NSLog(@"imageurl === %@",imageurl);
             if(imageurl.count!=0)
             {
                 NSString * fname = [result objectForKey:@"first_name"];
                 facebookFirst_name = fname;
                 [facebookFirst_name retain];
                 //             [fname release];
                 NSString * lname = [result objectForKey:@"last_name"];
                 facebookLast_name = lname;
                 [facebookLast_name retain];
                 //             [lname release];
                 NSString * gender = [result objectForKey:@"gender"];
                 if ([gender isEqualToString:@"male"])
                 {
                     facebookGender = @"Male";
                 }
                 else if ([gender isEqualToString:@"female"])
                 {
                     facebookGender = @"Female";
                 }
                 else
                 {
                     facebookGender = gender;
                 }
                 
                 [facebookGender retain];
                 //             [gender release];
                 NSString * IDValue = [result objectForKey:@"id"];
                 facebookID = IDValue;
                 [facebookID retain];
                 facebookBigImage = [facebookBigImage stringByReplacingOccurrencesOfString:@"ID" withString:facebookID];
                 [facebookBigImage retain];
                 //             [IDValue release];
                 
                 NSArray * friendList = [result objectForKey:@"friends"];
                 NSArray * friendData = [friendList valueForKey:@"data"];
                 NSArray * friendname = [friendData valueForKey:@"name"];
                 
                 User_Friend_Name = [[NSMutableArray alloc] initWithArray:friendname];
                 
                 //  NSLog(@"User_Friend_Name = %@",User_Friend_Name);
                 NSArray * friendid = [friendData valueForKey:@"id"];
                 User_Friend_Id = [[NSMutableArray alloc] initWithArray:friendid];
                  NSLog(@"User_Friend_Id = %@",User_Friend_Id);
                 
                 NSArray * myurl = [imageurl objectForKey:@"data"];
                 NSString * imageUrl = [myurl valueForKey:@"url"];
                 NSURL * myimageurl = [[NSURL alloc] initWithString:imageUrl];
                 
                 //             imagedata = [[NSData alloc] initWithContentsOfURL:myimageurl];
                 //             //             NSLog(@"imagedata = %@",imagedata);
                 //             fbimagemyurl = [[NSString alloc] initWithString:imageUrl] ;
                 //             [[NSUserDefaults standardUserDefaults]
                 //              setObject:fbimagemyurl forKey:@"preferenceName"];
                 
                 imageUrl = nil;
                 myurl = nil;
                 imageUrl = nil;
                 myimageurl = nil;
             }
             else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet!" message:@"No Working Inernet Connection is found.\n\n If WiFi is enabled, try diabling WiFi or try another WiFi hotspot." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                //[alert show];
                //[alert release];
                [self.view hideToastActivity];
            }
            
         }];
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary <FBGraphUser> *user,
           NSError *error) {
             if (!error)
             {
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"logged_in"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
//                 [self.view hideToastActivity];
                 /*
                 if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                 {
                     
                     myview = [[MyView alloc] initWithNibName:@"MyView_Ipad" bundle:nil];
                     [self.navigationController pushViewController:myview animated:YES];
                     
                 }
                 else
                 {
                     if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
                     {
                         
                         
                         myview = [[MyView alloc] initWithNibName:@"MyView" bundle:nil];
                         [self.navigationController pushViewController:myview animated:YES];
                     }
                     else
                     {
                         
                         myview = [[MyView alloc] initWithNibName:@"MyView_Iphone4" bundle:nil];
                         [self.navigationController pushViewController:myview animated:YES];
                     }
                 }
                 */
             }
         }];
        
        
    }
   
}
- (void)getUserInfo
{
    if (FBSession.activeSession.isOpen)
    {
        
        [FBRequestConnection startWithGraphPath:@"/me/taggable_friends"
                                     parameters:nil
                                     HTTPMethod:@"GET"
                              completionHandler:^(
                                                  FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error
                                                  ) {
                                  /* handle the result */
                                  NSLog(@"result == %@",result);
                              }];
        /*
        [FBRequestConnection startWithGraphPath:@"/me/family"
                                     parameters:[NSDictionary dictionaryWithObject:@"picture.type(normal),relationship,name,first_name,last_name" forKey:@"fields"]
                                     HTTPMethod:@"GET"
                              completionHandler:^(
                                                  FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error
                                                  ) {
                                 
//                                  NSLog(@"result === %@",result);
                                  NSDictionary * getdata = [result objectForKey:@"data"];
//                                  NSLog(@"getrelationship == %@",getdata);
                                  NSArray * getrelationship = [getdata valueForKey:@"relationship"];
                                  User_Relation = [[NSMutableArray alloc] initWithArray:getrelationship];
                                  NSLog(@"My realtionShip == %@",User_Relation);
                                  NSArray * firstname = [getdata valueForKey:@"first_name"];
                                  First_Name = [[NSMutableArray alloc] initWithArray:firstname];
                                  
                                  NSLog(@"Firstname == %@",First_Name);
                                  NSArray * lastname = [getdata valueForKey:@"last_name"];
                                  Last_Name = [[NSMutableArray alloc] initWithArray:lastname];
                                  NSLog(@"lastname == %@",Last_Name);
                                  NSArray * getPicturedata = [getdata valueForKey:@"picture"];
                                 // NSLog(@"get Picaturedata == %@",getPicturedata);
                                  NSArray * getdata1 = [getPicturedata valueForKey:@"data"];
//                                  NSLog(@"getdata == %@",getdata1);
                                  NSArray *relativeImage = [getdata1 valueForKey:@"url"];
                                  Image_Url = [[NSMutableArray alloc] initWithArray:relativeImage];
                                  NSLog(@"realtiveImage === %@",Image_Url);
                                  
                              }];
    
        */
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary <FBGraphUser> *user,
           NSError *error) {
             if (!error)
             {
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"logged_in"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
//                 [self.view hideToastActivity];
                 
                 if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                 {
                     /*
                     myfirstview= [[FirstView alloc] initWithNibName:@"FirstViewiPad" bundle:nil];
                     [self.navigationController pushViewController:myfirstview animated:YES];
                      */
                     myview = [[MyView alloc] initWithNibName:@"MyView_Ipad" bundle:nil];
                     [self.navigationController pushViewController:myview animated:YES];

                 }
                 else
                 {
                     if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
                     {
                         /*
                         myfirstview= [[FirstView alloc] initWithNibName:@"FirstView" bundle:nil];
                         [self.navigationController pushViewController:myfirstview animated:YES];
                          */
                         
                        myview = [[MyView alloc] initWithNibName:@"MyView" bundle:nil];
                        [self.navigationController pushViewController:myview animated:YES];
                     }
                     else
                     {
                         /*
                         myfirstview= [[FirstView alloc] initWithNibName:@"FirstView_Iphone4" bundle:nil];
                         [self.navigationController pushViewController:myfirstview animated:YES];
                          */
                         myview = [[MyView alloc] initWithNibName:@"MyView_Iphone4" bundle:nil];
                         [self.navigationController pushViewController:myview animated:YES];
                     }
                 }
             }
             [self.view hideToastActivity];
         }];
    }
}


-(void)insert
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    
    Sample *s = [NSEntityDescription insertNewObjectForEntityForName:@"Sample" inManagedObjectContext:context];
    
    s.name = facebookFirst_name;
    s.last = facebookLast_name;
    s.gender = facebookGender;
    s.age = [NSNumber numberWithInt:[facebookAge intValue]];
    s.ids = @"1";
    s.parent = @"";
    s.child = @"";
    s.sibling = @"";
    s.number = [NSNumber numberWithInt:1];
    s.profile_name = [NSString stringWithFormat:@"%@%@",facebookFirst_name,facebookLast_name];
    s.spouse = @"";
    
    
    NSError *error;
    
    if (![context save:&error])
    {
        NSLog(@"Ohhhhh You are fool because no memory you have");
    }
    
    NSURL *url = [NSURL URLWithString:facebookBigImage];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    [data writeToFile:[LoginView FacebookImageDirect:s.profile_name] atomically:YES];
}

-(void)sybiling : (NSString *)firstname : (NSString *)lastname : (NSString *)gender
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    Sample *s = [NSEntityDescription insertNewObjectForEntityForName:@"Sample" inManagedObjectContext:context];
    
    s.name = firstname;
    s.ids = [NSString stringWithFormat:@"%d",counter];
    s.number = [NSNumber numberWithInt:1];
    s.parent =@"";
    s.child = @"";
    s.sibling = [NSString stringWithFormat:@"%@,",@"1"];
    s.last = lastname;
    s.age = [NSNumber numberWithInt:0];
    s.gender = gender;
    s.profile_name = [NSString stringWithFormat:@"%@%@",firstname,lastname];
    s.spouse = @"";
    
    
    NSError *error;
    
    if (![context save:&error])
    {
        NSLog(@"Ohhhhh You are fool because no memory you have");
    }
    
    NSManagedObject * device = [mynewarray objectAtIndex:0];
    [device setValue:NAME forKey:@"name"];
    [device setValue:@"1" forKey:@"ids"];
    [device setValue:PARENT forKey:@"parent"];
    [device setValue:CHILD forKey:@"child"];
    [device setValue:[NSNumber numberWithInt:1] forKey:@"number"];
    NSLog(@"SYBILING == %@ , LastID == %d",SYBILING ,LASTID);
    if ([SYBILING isEqualToString:@"<null>"] || SYBILING == nil || SYBILING.length == 0)
    {
        [device setValue:[NSString stringWithFormat:@"%d,",counter] forKey:@"sibling"];
    }
    else
    {
        NSLog(@"string is define that == %@",[NSString stringWithFormat:@"%@%d,",SYBILING,LASTID] );
        [device setValue:[NSString stringWithFormat:@"%@%d,",SYBILING,counter] forKey:@"sibling"];
    }
    
    NSError *error1;
    
    if (![context save:&error1])
    {
        NSLog(@"Ohhhhh You are fool because no memory you have");
    }
//    [self.navigationController popViewControllerAnimated:YES];
}

-(void)child : (NSString *)firstname : (NSString *)lastname : (NSString *)gender
{
    if ([CHILD isEqualToString:@"<null>"] || CHILD.length >0)
    {
//        CHILD = @"0,";
    }
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    
    Sample *s = [NSEntityDescription insertNewObjectForEntityForName:@"Sample" inManagedObjectContext:context];
    
    
    s.name = firstname;
    s.ids = [NSString stringWithFormat:@"%d",counter];
    s.parent =[NSString stringWithFormat:@"%@,",@"1"];
    s.child = @"";
    s.sibling = @"";
    s.number = [NSNumber numberWithInt:0];
    s.last = lastname;
    s.age = [NSNumber numberWithInt:0];
    s.gender = gender;
    s.profile_name = [NSString stringWithFormat:@"%@%@",firstname,lastname];
    s.spouse = @"";
    
    NSError *error;
    
    if (![context save:&error])
    {
        NSLog(@"Ohhhhh You are fool because no memory you have");
    }
    
    
    NSManagedObject * device = [mynewarray objectAtIndex:0];
    
    [device setValue:NAME forKey:@"name"];
    [device setValue:@"1" forKey:@"ids"];
    [device setValue:PARENT forKey:@"parent"];
    if ([CHILD isEqualToString:@"<null>"] || CHILD == nil)
    {
        [device setValue:[NSString stringWithFormat:@"%d,",counter] forKey:@"child"];
    }
    else
    {
        [device setValue:[NSString stringWithFormat:@"%@%d,",CHILD,counter] forKey:@"child"];
    }
    
    [device setValue:SYBILING forKey:@"sibling"];
    
    NSError *error1;
    
    if (![context save:&error1])
    {
        NSLog(@"Ohhhhh You are fool because no memory you have");
    }
    
//    [self.navigationController popViewControllerAnimated:YES];
}



- (void)dealloc {
    [_backgroundImage release];
    [super dealloc];
}
@end
