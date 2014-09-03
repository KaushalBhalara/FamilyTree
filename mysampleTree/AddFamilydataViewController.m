//
//  AddFamilydataViewController.m
//  treeeeeeeee
//
//  Created by Prajas on 4/30/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import "AddFamilydataViewController.h"
#import "UIDevice+Resolutions.h"
#import "AppDelegate.h"
#import "Sample.h"
#import "SBJson.h"
#import "UIView+Toast.h"
#import "FTWCache.h"
#import "NSString+MD5.h"

@interface AddFamilydataViewController ()

@end

@implementation AddFamilydataViewController
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
   // [self getdata];
}
-(NSArray *)GetUserData :(NSString *)profilename
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"profile_name == %@", profilename];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray * define_array = [context executeFetchRequest:request error:&error];
    NSLog(@"define_array == %@",define_array);
    if (define_array.count > 0) {
//        Sample *s =[define_array objectAtIndex:0];
//        NSLog(@"s name is  == %@",s.profile_name);
        return define_array;
    }
    else{
        return NULL;
    }
}

#pragma mark Http Request 

-(void)getpersonal_data :(NSString *) IDPass :(NSString *)token
{
    NSString * tempstring = [[NSString alloc] initWithString:get_persnoal_URL];
    tempstring = [tempstring stringByReplacingOccurrencesOfString:@"FBID" withString:token];
    tempstring = [tempstring stringByReplacingOccurrencesOfString:@"AAA" withString:IDPass];
    NSURL * myurl =[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",tempstring]];
    NSLog(@"myurl = %@",myurl);
    ASIHTTPRequest *requestbyuidgetdata = [ASIHTTPRequest requestWithURL:myurl];
    [requestbyuidgetdata setDelegate:self];
    [requestbyuidgetdata setDidFinishSelector:@selector(requestDonegetdata:)];
    [requestbyuidgetdata setDidFailSelector:@selector(requestFailed:)];
    [self.queue addOperation:requestbyuidgetdata];
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [self.view hideToastActivity];
	NSError *error = [request error];
  [self.view makeToast:@"Server is down please try again later" duration:3.0 position:@"center"];
	NSLog(@"requestFailed:%@",error);
}
- (void)requestDonegetdata:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSArray *responsevalue = [response JSONValue];
    if(response==nil)
    {
         [self.view hideToastActivity];
    }
    else
    {
        NSLog(@"responsevalue = %@",responsevalue );
         NSString *family_tree =[responsevalue valueForKey:@"family_tree"];
        NSArray * temp =[family_tree valueForKey:@"tree"];
        NSArray *tree=[temp objectAtIndex:0];
        NSLog(@"tree = %@",tree );
        NSString * name = [tree valueForKey:@"name"];
        NSLog(@"name = %@",name );
        self.display_name.text = name;
        NSString * last = [tree valueForKey:@"last"];
        self.last_name.text = last;
        NSString * age = [tree valueForKey:@"age"];
        self.age.text = age;
        NSString * gender = [tree valueForKey:@"gender"];
        self.gender.text = gender;
        NSString * realtion = [tree valueForKey:@"relation"];
        self.Relation_label.text = realtion;
        
        NSString * profilePicture = [tree valueForKey:@"profile_name"];
        NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",profilePicture];
        NSURL *imageURL = [NSURL URLWithString:imagestring];
        NSString *key = [imagestring MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if([data length]==0)
        {
            self.profile_image.image=[UIImage imageNamed:@"sample_profile.png"];
        }
        else
        {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                self.profile_image.image=image;
            } else {
                
                dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue1, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        self.profile_image.image=image;
                    });
                });
            }
        }
        
        [self.view hideToastActivity];
    }
   
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![self queue]) {
        [self setQueue:[[[NSOperationQueue alloc] init] autorelease]];
    }
    [self.view makeToastActivity];
    [self getpersonal_data:SelectedId:userdeviceToken];
    
    self.display_name.text = myname;
   // NSLog(@"Profle tag == %@",myprofilename);
    //self.profile_image.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[NewAdddata PathOfBGImages:myprofilename]]];
   // NSArray * getuserdata = [[NSArray alloc] initWithArray:[self GetUserData:myprofilename]];
    //Sample * s =[getuserdata objectAtIndex:0];
//    self.display_name.text = s.name;
//    self.last_name.text = s.last;
//    self.age.text = [NSString stringWithFormat:@"%@",s.age];
//    self.gender.text = s.gender;
    /*
    if ([s.number intValue] == 1 || [s.number intValue] == 0)
    {
        if ([s.ids isEqualToString:@"1"])
        {
            self.add_button.hidden = NO;
        }
        else
        {
            self.add_button.hidden = YES;
        }
    }*/
    
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
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void )getdata
{
    myarray = [[NSArray alloc] init];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    myarray =[context executeFetchRequest:request error:&error];
    
    [myarray retain];
    
    Sample *s = [myarray lastObject];
    int temp = [s.ids integerValue];
    NSLog(@"temp == %@",s.name);
    LASTID = 1 + temp;
//    [self.mytable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_display_name release];
    [_last_name release];
    [_profile_image release];
    [_age release];
    [_gender release];
    [_add_button release];
    [_Relation_label release];
    [super dealloc];
}

- (IBAction)addFamily:(id)sender
{
    //************** Ckeck The Bool If editable or not For user***********************
    if(EDIT_OR_VIEW_BOOL==YES)
    {
        UIActionSheet *actionSheet = nil;
        if (LOCK >= 2)
        {
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Relation ..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Parent", nil];
        }
        else if(LOCK == 1)
        {
            NSLog(@"calling this FirstADDParent");
            
            if (FIRSTADDPARENT == YES)
            {
                NSLog(@"calling this FirstADDParent true");
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Relation ..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Parent", @"Child",@"Sibling", nil];
            }
            else
            {
                NSLog(@"calling this FirstADDParent No");
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Relation ..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Child",@"Sibling", nil];
                ChangeActionTagValue=1;
            }
        }
        else if (LOCK < 1 )
        {
            //actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Parent", @"Child",@"Sybiling", nil];
        }
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        actionSheet.alpha=0.90;
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];
        [actionSheet release];
    }
    else
    {
        [self.view makeToast:@"You Don't Have permission to Add data. You just view Data" duration:2.0 position:@"center"];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(LOCK<2)
    {
        switch (actionSheet.tag)
        {
            case 1:
                switch (buttonIndex)
            {
                case 0:
                {
                    //                [self parent:self];
                    NSLog(@"switch case 0");
                    FIRSTADDPARENT = NO;
                    
                    if(ChangeActionTagValue==1)
                    {
                        ADDWHICH = [[NSString alloc] initWithString:@"Child"];
                        
                    }else
                    {
                        ADDWHICH = [[NSString alloc] initWithString:@"Parent"];
                    }
                    
                    
                   // ADDWHICH = [[NSString alloc] initWithString:@"Parent"];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        myadddata = [[NewAdddata alloc] initWithNibName:@"NewAdddata_Ipad" bundle:nil];
                        [self.navigationController pushViewController:myadddata animated:YES];
                    }
                    else
                    {
                        if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
                        {
                            myadddata = [[NewAdddata alloc] initWithNibName:@"NewAdddata" bundle:nil];
                            [self.navigationController pushViewController:myadddata animated:YES];
                        }
                        else
                        {
                            myadddata = [[NewAdddata alloc] initWithNibName:@"NewAdddata_Iphone4" bundle:nil];
                            [self.navigationController pushViewController:myadddata animated:YES];
                        }
                        
                    }
                    
                    
                    
                }
                    break;
                case 1:
                {
                    //                [self child:self];
                    //
                    //                [self childDraw];
                    NSLog(@"switch case 1");
                    if (FIRSTADDPARENT == YES)
                    {
                        UIAlertView * myalert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Please Enter First Parent" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [myalert show];
                    }
                    else
                    {
                        FIRSTADDPARENT = NO;
                        
                        if(ChangeActionTagValue==1)
                        {
                            ADDWHICH = [[NSString alloc] initWithString:@"Sybiling"];

                        }else
                        {
                            ADDWHICH = [[NSString alloc] initWithString:@"Child"];
                        }
                       // ADDWHICH = [[NSString alloc] initWithString:@"Child"];
                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                        {
                            myadddata = [[NewAdddata alloc] initWithNibName:@"NewAdddata_Ipad" bundle:nil];
                            [self.navigationController pushViewController:myadddata animated:YES];
                        }
                        else
                        {
                            if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
                            {
                                myadddata = [[NewAdddata alloc] initWithNibName:@"NewAdddata" bundle:nil];
                                [self.navigationController pushViewController:myadddata animated:YES];
                            }
                            else
                            {
                                myadddata = [[NewAdddata alloc] initWithNibName:@"NewAdddata_Iphone4" bundle:nil];
                                [self.navigationController pushViewController:myadddata animated:YES];
                            }
                            
                        }
                    }
                    
                }
                    break;
                case 2:
                {
                    //                [self symbiling:self];
                    
                    if (FIRSTADDPARENT == YES)
                    {
                        UIAlertView * myalert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Please Enter First Parent" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [myalert show];
                    }
                    else
                    {
                        if(ChangeActionTagValue==1)
                        {
                            
                            
                        }else
                        {
                            FIRSTADDPARENT = NO;
                            ADDWHICH = [[NSString alloc] initWithString:@"Sybiling"];
                            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                            {
                                myadddata = [[NewAdddata alloc] initWithNibName:@"NewAdddata_Ipad" bundle:nil];
                                [self.navigationController pushViewController:myadddata animated:YES];
                            }
                            else
                            {
                                if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
                                {
                                    myadddata = [[NewAdddata alloc] initWithNibName:@"NewAdddata" bundle:nil];
                                    [self.navigationController pushViewController:myadddata animated:YES];
                                }
                                else
                                {
                                    myadddata = [[NewAdddata alloc] initWithNibName:@"NewAdddata_Iphone4" bundle:nil];
                                    [self.navigationController pushViewController:myadddata animated:YES];
                                }
                                
                            }
                        }
                        
                        
                    }
                    
                }
                    break;
            }
                break;
                
            default:
                break;
        }
    }else{
        switch (actionSheet.tag)
        {
            case 1:
                switch (buttonIndex)
            {
                case 0:
                {
                    //                [self parent:self];
                    ADDWHICH = [[NSString alloc] initWithString:@"Parent"];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        myadddata = [[NewAdddata alloc] initWithNibName:@"NewAdddata_Ipad" bundle:nil];
                        [self.navigationController pushViewController:myadddata animated:YES];
                    }
                    else
                    {
                        if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
                        {
                            myadddata = [[NewAdddata alloc] initWithNibName:@"NewAdddata" bundle:nil];
                            [self.navigationController pushViewController:myadddata animated:YES];
                        }
                        else
                        {
                            myadddata = [[NewAdddata alloc] initWithNibName:@"NewAdddata_Iphone4" bundle:nil];
                            [self.navigationController pushViewController:myadddata animated:YES];
                        }
                        
                    }
                }
                    break;
            }}
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setLast_name:nil];
    [self setProfile_image:nil];
    [self setAge:nil];
    [self setGender:nil];
    [self setAdd_button:nil];
    [self setRelation_label:nil];
    [super viewDidUnload];
}
@end
