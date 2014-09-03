//
//  FacebookFriend.m
//  Mera Parivar
//
//  Created by Prajas on 7/21/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import "FacebookFriend.h"
#import "UniversalUrl.h"
#import <QuartzCore/QuartzCore.h>
#import "FTWCache.h"
#import "NSString+MD5.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;

@interface FacebookFriend ()

@end

@implementation FacebookFriend
@synthesize delegate;
@synthesize requestConnection;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)closePopup:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Search_USER_Freiend_ID_Arr=[[NSMutableArray alloc]initWithArray:User_Friend_Id];
    Search_USER_Freiend_Arr=[[NSMutableArray alloc]initWithArray:User_Friend_Name];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        self.MyserachBar.frame = CGRectMake(0.0, 119.0, 634.0, 30.0);
    }
    else
    {
        self.MyserachBar.frame = CGRectMake(5.0, 56.0, 276.0, 30.0);
    }
      
    self.MyserachBar.layer.cornerRadius=5.0f;
    self.MyserachBar.layer.masksToBounds = YES;
    //self.mysearch.layer.borderColor=[UIColor grayColor];
    self.MyserachBar.backgroundImage=[UIImage imageNamed:@"searbar.png"];
    [self.MyserachBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searbar.png"] forState:UIControlStateNormal];
   // NSLog(@"User_Friend_Name==%@",User_Friend_Name);
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - Searchbar  Method
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // only show the status bar's cancel button while in edit mode
    
    self.MyserachBar.showsCancelButton = NO;
    self.MyserachBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    CGRect textFieldRect =
    [self.view.window convertRect:searchBar.bounds fromView:searchBar];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0 * textFieldRect.size.height;
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
    
    // flush the previous search content
    //    [tableData removeAllObjects];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.MyserachBar.showsCancelButton = NO;
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // NSLog(@"Search button Click");
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length]==0)
    {
        Search_USER_Freiend_ID_Arr=[[NSMutableArray alloc]initWithArray:User_Friend_Id];
        Search_USER_Freiend_Arr=[[NSMutableArray alloc]initWithArray:User_Friend_Name];
        [self.share_table reloadData];
    }
    else
    {
        Search_USER_Freiend_ID_Arr=[[NSMutableArray alloc]init];
        Search_USER_Freiend_Arr=[[NSMutableArray alloc]init];
        //NSMutableArray *fbid=[[NSMutableArray alloc]init];
        
        int indexCount = 0; //keeps track of which index you are at.
        for (NSString *sTemp in User_Friend_Name)
        {
            NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResultsRange.length > 0)
            {
                [Search_USER_Freiend_Arr addObject:sTemp]; //this is your name result
                [Search_USER_Freiend_ID_Arr addObject:[User_Friend_Id objectAtIndex:indexCount]];
            }
            indexCount++;
        }
        [self.share_table reloadData];
    }
   // NSLog(@"Search_USER_Freiend_Arr =%d",Search_USER_Freiend_Arr.count);
   // NSLog(@"Search_USER_Freiend_ID_Arr =%@",Search_USER_Freiend_ID_Arr);
   
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.MyserachBar resignFirstResponder];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return Search_USER_Freiend_Arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return 65;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        UILabel *NameOFList=[[UILabel alloc]initWithFrame:CGRectMake(150, 7, 550, 50)];
        NameOFList.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
        NameOFList.text = [NSString stringWithFormat:@"%@",[Search_USER_Freiend_Arr objectAtIndex:indexPath.row]];
        NameOFList.backgroundColor=[UIColor clearColor];
        NameOFList.font = [UIFont fontWithName:@"Helvetica Neue" size:30.0f];
        [cell.contentView addSubview:NameOFList];
        
        //cell.textLabel.text = s.name;
        //cell.textLabel.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
        
        UIImageView *PhotoImage=[[UIImageView alloc]initWithFrame:CGRectMake(50, 7, 50, 50)];
        // PhotoImage.image=[UIImage imageNamed:@"sample_profile.png"];
       
        NSString * imagestring = [[NSString alloc] initWithFormat:@"http://graph.facebook.com/%@/picture?type=normal",[Search_USER_Freiend_ID_Arr objectAtIndex:indexPath.row]];
        
        NSURL *imageURL = [NSURL URLWithString:imagestring];
        NSString *key = [imagestring MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data)
        {
            UIImage *image = [UIImage imageWithData:data];
            PhotoImage.image = image;
        }
        else
        {
            //		imageView.image = [UIImage imageNamed:@"img_def"];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    PhotoImage.image = image;
                });
            });
        }
        PhotoImage.clipsToBounds = YES;
        PhotoImage.layer.cornerRadius = 25;
        [cell.contentView addSubview:PhotoImage];
    }
    else
    {
        UILabel *NameOFList=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 220, 20)];
        NameOFList.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
        NameOFList.text = [NSString stringWithFormat:@"%@",[Search_USER_Freiend_Arr objectAtIndex:indexPath.row]];
        NameOFList.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:NameOFList];
        
        //cell.textLabel.text = s.name;
        //cell.textLabel.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
        
        UIImageView *PhotoImage=[[UIImageView alloc]initWithFrame:CGRectMake(3, 5, 35, 35)];
        NSString * imagestring = [[NSString alloc] initWithFormat:@"http://graph.facebook.com/%@/picture?type=normal",[Search_USER_Freiend_ID_Arr objectAtIndex:indexPath.row]];
        NSURL *imageURL = [NSURL URLWithString:imagestring];
        NSString *key = [imagestring MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data)
        {
            UIImage *image = [UIImage imageWithData:data];
            PhotoImage.image = image;
        }
        else
        {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    PhotoImage.image = image;
                });
            });
        }
        PhotoImage.clipsToBounds = YES;
        PhotoImage.layer.cornerRadius = 17.5;
        [cell.contentView addSubview:PhotoImage];
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.MyserachBar resignFirstResponder];
    indexno=indexPath.row;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Share from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"View & Edit", @"Only View", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.alpha=0.90;
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
    [actionSheet release];
   
    /*
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
    */
    
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
                NSLog(@"indexno=%d",indexno);
                NSLog(@"user_freind_id=%@",[Search_USER_Freiend_ID_Arr objectAtIndex:indexno]);
                NSLog(@"user FBID=%@",facebookID);
                NSLog(@"Editable");
                [self sharedata:facebookID :[Search_USER_Freiend_ID_Arr objectAtIndex:indexno] :@"1" ];
            }
                break;
            case 1:
            {
                NSLog(@"indexno=%d",indexno);
                NSLog(@"user_freind_id=%@",[Search_USER_Freiend_ID_Arr objectAtIndex:indexno]);
                NSLog(@"user FBID=%@",facebookID);
                NSLog(@"VIEW ONLY");
                [self sharedata:facebookID :[Search_USER_Freiend_ID_Arr objectAtIndex:indexno] :@"0" ];
                
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
    ASIHTTPRequest *share_tree_service = [ASIHTTPRequest requestWithURL:myurl];
    [share_tree_service setDelegate:self];
    [share_tree_service setDidFinishSelector:@selector(Share_Tree_URL:)];
    [share_tree_service setDidFailSelector:@selector(requestFailed:)];
    [share_tree_service setDelegate:self];
    [share_tree_service startSynchronous];
    NSLog(@"ShareId= =%@",ShareId);

}

- (void)Share_Tree_URL:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"response Value update = %@",responsevalue);
    NSString * success = [responsevalue objectForKey:@"message"];
    if ([success isEqualToString:@"Operation success!"])
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
            [self.delegate cancelButtonClicked:self];
        }
        
        [self Post_On_Friend_wall];
        
        [self.view makeToast:@"Your Family tree is share successfully" duration:2.0 position:@"center"];
    }
    else
    {
        [self.view makeToast:@"Server is down please try again later" duration:3.0 position:@"center"];
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
    [self.view makeToast:@"Server is down please try again later" duration:3.0 position:@"center"];
}

#pragma - mark Post_On_Freinds_wall
-(void)Post_On_Friend_wall
{
    //*************************** Post On Friends Wall on faceBook******************************
    
    NSString* appID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
   // NSLog(@"appID==%@",appID);
    NSString *ShareId=[Search_USER_Freiend_ID_Arr objectAtIndex:indexno];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   appID, @"api_key",
                                   @"Please join me On \"My Family Tree\"", @"message",
                                   @"www.myfamilytree.com", @"link",
                                   @"My Family Tree", @"name",
                                   @"Hi Friends", @"description",
                                   ShareId, @"to",
                                   @"feed",@"method",
                                   nil];
    
    [FBWebDialogs presentFeedDialogModallyWithSession:FBSession.activeSession
                                           parameters:params
                                              handler:
    // ^(FBWebDialogResult result, NSURL *resultURL, NSError *error){
    // }];
    ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
        if (error)
        {
            NSLog(@"Error publishing story.");
        } else
        {
            if (result == FBWebDialogResultDialogNotCompleted)
            {
                 [self.view makeToast:@"You doesn't post on the wall. But it share successfully" duration:2.0 position:@"center"];
            } else
            {
                 
                NSLog(@"Handle the publish feed callback");
                [self performSelector:@selector(Myalert) withObject:nil afterDelay:2.0];
            }
        }
    }];
    
    //*************************** Post On Friends Wall on faceBook******************************
}
-(void)Myalert
{
    NSLog(@"call THis");
    [[[UIAlertView alloc] initWithTitle:@"Sucessful." message:@"Your Tree Share Successfully." delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil] show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_share_table release];
    [_MyserachBar release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setShare_table:nil];
    [self setMyserachBar:nil];
    [super viewDidUnload];
}
@end
