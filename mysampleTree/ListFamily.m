//
//  ListFamily.m
//  treeeeeeeee
//
//  Created by Prajas on 4/30/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import "ListFamily.h"
#import "AppDelegate.h"
#import "Sample.h"
#import "UIView+Toast.h"
#import "SBJson.h"
#import "FTWCache.h"
#import "NSString+MD5.h"
@interface ListFamily ()

@end

@implementation ListFamily
@synthesize queue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Web service Function
-(void)getdata:(NSString *)facebookId
{
    NSString * urlstring = [[NSString alloc] initWithFormat:@"%@%@",getdata_URL,facebookID];
    
    NSURL * myurl = [NSURL URLWithString:urlstring];
    ASIHTTPRequest *requestbyuidgetdata = [ASIHTTPRequest requestWithURL:myurl];
    [requestbyuidgetdata setDelegate:self];
    [requestbyuidgetdata setDidFinishSelector:@selector(requestDonegetdata:)];
    [requestbyuidgetdata setDidFailSelector:@selector(requestFailed:)];

    [self.queue addOperation:requestbyuidgetdata];
    //[requestbyuid startAsynchronous];
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
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"Insert Value = %@",responsevalue );
    
   // NSArray *tempname = [responsevalue valueForKey:@"name"];
    
    

}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if(EDIT_IS_DONE_BOOL==YES)
    {
        NSLog(@"I M EDIT Dear");
        [self CallMethodAfterEdit ];
       // EDIT_IS_DONE_BOOL=NO;
    }
    
    EDITFLAG = NO;
    if (EDITFLAG == NO) {
        self.edit_button.hidden = NO;
    }
    else
    {
        self.edit_button.hidden = YES;
    }
    [self getdata];
}
-(void)CallMethodAfterEdit
{
    
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
    NSString * urlstring = [[NSString alloc] initWithFormat:@"%@%@",getdata_URL,EXCHAGE];
    NSLog(@"List View==%@",urlstring);
    NSURL * myurl = [NSURL URLWithString:urlstring];
    ASIHTTPRequest *requestbyuidgetdata = [ASIHTTPRequest requestWithURL:myurl];
    [requestbyuidgetdata setDelegate:self];
    [requestbyuidgetdata setDidFinishSelector:@selector(MethodCALL:)];
    [requestbyuidgetdata setDidFailSelector:@selector(requestFailed:)];
    [requestbyuidgetdata setDelegate:self];
    [requestbyuidgetdata startSynchronous];
}
- (void)MethodCALL:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
   // NSLog(@"response==%@",response);
    NSDictionary *responsevalue = [response JSONValue];
   // NSLog(@"List View tree gat data = %@",responsevalue );
    
    IdsArr=[[NSMutableArray alloc]init];
    IdsArr=[[responsevalue valueForKey:@"ids"]retain];
    // NSLog(@"IdsArr= %@",IdsArr );
    NameOfArr=[[NSMutableArray alloc]init];
    NameOfArr=[[responsevalue valueForKey:@"name"]retain];
    // NSLog(@"NameOfArr= %@",NameOfArr );
    profile_nameArr=[[NSMutableArray alloc]init];
    profile_nameArr=[[responsevalue valueForKey:@"profile_name"]retain];
    //  NSLog(@"profile_nameArr= %@",profile_nameArr );
    numberArr=[[NSMutableArray alloc]init];
    numberArr=[[responsevalue valueForKey:@"number"]retain];
    
    spouseArr=[[NSMutableArray alloc]init];
    spouseArr=[[responsevalue valueForKey:@"spouse"]retain];
    //*ageArr,*lastArr,*genderArr
    ageArr=[[NSMutableArray alloc]init];
    ageArr=[[responsevalue valueForKey:@"age"]retain];
    lastArr=[[NSMutableArray alloc]init];
    lastArr=[[responsevalue valueForKey:@"last"]retain];
    genderArr=[[NSMutableArray alloc]init];
    genderArr=[[responsevalue valueForKey:@"gender"]retain];
     [self.mytable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self find_value_child];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//    int temp = [s.ids integerValue];
    NSLog(@"temp == %@",s.name);
//    LASTID = 1 + temp;
    NSLog(@"my array is  = %@",myarray);
    [self.mytable reloadData];
}

-(void)Delete:(int)deleteID
{
    NSNumber *soughtPid=[NSNumber numberWithInt:deleteID];

    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ids == %@", soughtPid];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray * define_array = [context executeFetchRequest:request error:&error];
    for (NSManagedObject *product in define_array)
    {
        [context deleteObject:product];
    }
    [context save:&error];
//    NSEntityDescription *productEntity=[NSEntityDescription entityForName:@"Product" inManagedObjectContext:context];
//    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
//    [fetch setEntity:productEntity];
//    NSPredicate *p=[NSPredicate predicateWithFormat:@"pid == %@", soughtPid];
//    [fetch setPredicate:p];
//    //... add sorts if you want them
//    NSError *fetchError;
//    NSArray *fetchedProducts=[self.moc executeFetchRequest:fetch error:&fetchError];
    
}

-(void)find_value_child
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Sample"];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    
    // Required! Unless you set the resultType to NSDictionaryResultType, distinct can't work.
    // All objects in the backing store are implicitly distinct, but two dictionaries can be duplicates.
    // Since you only want distinct names, only ask for the 'name' property.
    fetchRequest.resultType = NSDictionaryResultType;
    fetchRequest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"sibling"]];
    fetchRequest.returnsDistinctResults = YES;
    
    // Now it should yield an NSArray of distinct values in dictionaries.
    NSArray *dictionaries = [context executeFetchRequest:fetchRequest error:nil];
    NSLog (@"names: %@",dictionaries);
}

-(NSString *)finddeleteid :(NSString *)name
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    [request setPredicate:predicate];
    [request setEntity:entity];
   
    NSArray * define_array = [context executeFetchRequest:request error:&error];
    //    NSLog(@"define_array == %@",define_array);
    if(define_array.count > 0){
        Sample *s =[define_array objectAtIndex:0];
        NSLog(@"s name is  == %@",s.name);
        return s.ids;
    }
    else{
        return nil;
    }
}
-(NSNumber *)getnumbervalue :(NSString *)idvalue
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ids == %@", idvalue];
    [request setPredicate:predicate];
    [request setEntity:entity];
    NSLog(@"my number is %@",idvalue);
    NSArray * define_array = [context executeFetchRequest:request error:&error];
    //    NSLog(@"define_array == %@",define_array);
    if(define_array.count > 0){
        Sample *s =[define_array objectAtIndex:0];
        NSLog(@"s name is  == %@",s.number);
        return s.number;
    }
    else{
        return nil;
    }
}

-(NSArray *)match_string_sibling:(NSString *)selectedId
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSString * matches = [[NSString alloc] initWithFormat:@"sibling MATCHES '.*%@.*'",selectedId];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:matches];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray * define_array = [context executeFetchRequest:request error:&error];
    NSLog(@"match_string_sibling === %@",define_array);
    return define_array;
    
}
-(NSArray *)match_string_parent:(NSString *)selectedId
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSString * matches = [[NSString alloc] initWithFormat:@"parent MATCHES '.*%@.*'",selectedId];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:matches];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray * define_array = [context executeFetchRequest:request error:&error];
    NSLog(@"match_string_parent === %@",define_array);
    return define_array;
}
-(NSArray *)match_string_child:(NSString *)selectedId
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSString * matches = [[NSString alloc] initWithFormat:@"child MATCHES '.*%@.*'",selectedId];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:matches];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray * define_array = [context executeFetchRequest:request error:&error];
    NSLog(@"match_string_child === %@",define_array);
    return define_array;
}

-(void)update_sibling :(NSString *)idvalue :(NSString *)updatevalue
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ids == %@", idvalue];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray * define_array = [context executeFetchRequest:request error:&error];
    
    if (define_array.count > 0)
    {
        Sample * s = [define_array objectAtIndex:0];
        s.sibling = updatevalue;
    }
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
}

-(void)update_parent :(NSString *)idvalue :(NSString *)updatevalue
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ids == %@", idvalue];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray * define_array = [context executeFetchRequest:request error:&error];
    
    if (define_array.count > 0)
    {
        Sample * s = [define_array objectAtIndex:0];
        s.parent = updatevalue;
    }
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
}
-(void)update_child :(NSString *)idvalue :(NSString *)updatevalue
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ids == %@", idvalue];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray * define_array = [context executeFetchRequest:request error:&error];
    
    if (define_array.count > 0)
    {
        Sample * s = [define_array objectAtIndex:0];
        s.child = updatevalue;
    }
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    
}
- (IBAction)adddata:(id)sender
{
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   // return myarray.count;
      return NameOfArr.count;
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
    
   
    //Sample *s = [myarray objectAtIndex:indexPath.row];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        UILabel *NameOFList=[[UILabel alloc]initWithFrame:CGRectMake(150, 7, 400, 50)];
        NameOFList.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
        NameOFList.text = [NSString stringWithFormat:@"%@",[NameOfArr objectAtIndex:indexPath.row]];
        NameOFList.backgroundColor=[UIColor clearColor];
        NameOFList.font = [UIFont fontWithName:@"Helvetica Neue" size:30.0f];
        [cell.contentView addSubview:NameOFList];
        
        //cell.textLabel.text = s.name;
        //cell.textLabel.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
        
        UIImageView *PhotoImage=[[UIImageView alloc]initWithFrame:CGRectMake(50, 7, 50, 50)];
        // PhotoImage.image=[UIImage imageNamed:@"sample_profile.png"];
        NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",[profile_nameArr objectAtIndex:indexPath.row]];
        NSURL *imageURL = [NSURL URLWithString:imagestring];
        NSString *key = [imagestring MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            PhotoImage.image=image;
        } else {
            
            dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue1, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    PhotoImage.image=image;
                });
            });
            
        }
        PhotoImage.clipsToBounds = YES;
        PhotoImage.layer.cornerRadius = 25;
        [cell.contentView addSubview:PhotoImage];
        
        if (EDITFLAG == YES)
        {
            /* CABasicAnimation *theAnimation;
             
             theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
             theAnimation.duration=1.0;
             theAnimation.repeatCount=HUGE_VALF;
             theAnimation.autoreverses=YES;
             theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
             theAnimation.toValue=[NSNumber numberWithFloat:0.0];
             [NameOFList.layer addAnimation:theAnimation forKey:@"animateOpacity"];
             [PhotoImage.layer addAnimation:theAnimation forKey:@"animateOpacity"];
             */
            [self shakeView:NameOFList];
            [self shakeView:PhotoImage];
            
        }

    }
    else
    {
        UILabel *NameOFList=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 200, 20)];
        NameOFList.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
        NameOFList.text = [NSString stringWithFormat:@"%@",[NameOfArr objectAtIndex:indexPath.row]];
        NameOFList.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:NameOFList];
        
        //cell.textLabel.text = s.name;
        //cell.textLabel.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
        
        UIImageView *PhotoImage=[[UIImageView alloc]initWithFrame:CGRectMake(3, 5, 35, 35)];
        // PhotoImage.image=[UIImage imageNamed:@"sample_profile.png"];
        NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",[profile_nameArr objectAtIndex:indexPath.row]];
        NSURL *imageURL = [NSURL URLWithString:imagestring];
        NSString *key = [imagestring MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            PhotoImage.image=image;
        } else {
            
            dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue1, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    PhotoImage.image=image;
                });
            });
            
        }
        PhotoImage.clipsToBounds = YES;
        PhotoImage.layer.cornerRadius = 17.5;
        [cell.contentView addSubview:PhotoImage];
        
        if (EDITFLAG == YES)
        {
            /* CABasicAnimation *theAnimation;
             
             theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
             theAnimation.duration=1.0;
             theAnimation.repeatCount=HUGE_VALF;
             theAnimation.autoreverses=YES;
             theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
             theAnimation.toValue=[NSNumber numberWithFloat:0.0];
             [NameOFList.layer addAnimation:theAnimation forKey:@"animateOpacity"];
             [PhotoImage.layer addAnimation:theAnimation forKey:@"animateOpacity"];
             */
            [self shakeView:NameOFList];
            [self shakeView:PhotoImage];
            
        }

    }
    
    //cell.imageView.frame = CGRectMake(0,0,44,44);
   // cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[NewAdddata PathOfBGImages:s.profile_name]]];
    //cell.imageView.bounds = CGRectMake(0, 0, 44, 44);
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //************** Ckeck The Bool If editable or not For user***********************
    if(EDIT_OR_VIEW_BOOL==YES)
    {
        if (EDITFLAG == YES)
        {
            SelectRecord = indexPath.row;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                
                //             [self.navigationController pushViewController:myaddfamily animated:YES];
            }
            else
            {
                if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
                {
                    myeditview = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
                    [self.navigationController pushViewController:myeditview animated:YES];
                }
                else
                {
                    myeditview = [[EditViewController alloc] initWithNibName:@"EditViewController_Iphone4" bundle:nil];
                    [self.navigationController pushViewController:myeditview animated:YES];
                }
            }
        }
        else
        {
            SelectRecord = indexPath.row;
            //Sample *s =[myarray objectAtIndex:SelectRecord];
            if (SelectRecord == 0 )//|| [s.spouse isEqualToString:@"NO"] || [s.number intValue] == 2)
            {
                [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"you cann't delete." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Are you sure you want to delete? If you delete it,It will refelect other also." delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil] show];
            }
        }
    }
    else
    {
          [self.view makeToast:@"You Don't Have permission to delete data. You just view Data" duration:2.0 position:@"center"];
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
       // [self DeleteRecordinTable];
        [self Delete_Record_By_service];
    }
    else if (buttonIndex == 1)
    {
        
    }
}

-(void)Delete_Record_By_service
{
   // http://prajas.com/familytree/delete.php?fb_id=&ids=
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
    NSURL *url = [NSURL URLWithString:@"http://prajas.com/familytree/delete.php"];
    ASIFormDataRequest *requestbyuid1 = [ASIFormDataRequest requestWithURL:url];
    [requestbyuid1 setRequestMethod:@"POST"];
    [requestbyuid1 setPostValue:EXCHAGE forKey:@"fb_id"];
    [requestbyuid1 setPostValue:[IdsArr objectAtIndex:SelectRecord] forKey:@"ids"];
    [requestbyuid1 setDidFinishSelector:@selector(Respods_OF_DETELE:)];
    [requestbyuid1 setDidFailSelector:@selector(failrequest:)];
    [requestbyuid1 setDelegate:self];
    [requestbyuid1 startSynchronous];

}
- (void)Respods_OF_DETELE:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"responsevalue=%@",responsevalue);
    [self Delete_AND_RELOAD];
}
-(void)Delete_AND_RELOAD
{
    EDIT_IS_DONE_BOOL=YES;
    [self CallMethodAfterEdit];

}
- (void)failrequest:(ASIHTTPRequest *)request
{
    NSLog(@"failrequest=%@",request);
}
- (void)shakeView:(UIView *)viewToShake
{
    CGFloat t = 2.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:HUGE_VALF];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

-(void)DeleteRecordinTable
{
    Sample *s = [myarray objectAtIndex:SelectRecord];
    NSString * my_selected_data = [[NSString alloc] initWithString:s.ids];
    NSLog(@"my_selected_data == %@",my_selected_data);
    
    NSArray * siblingarray = [[NSArray alloc] initWithArray:[self match_string_sibling:my_selected_data]];
    if (siblingarray.count > 0)
    {
        for (int k = 0; k < siblingarray.count; k++)
        {
            Sample * s =[siblingarray objectAtIndex:k];
            NSString * getvalue = [[NSString alloc] initWithString:s.sibling];
            getvalue = [getvalue stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",my_selected_data] withString:@""];
            [self update_sibling:s.ids :getvalue];
        }
    }
    
    NSArray * parentarray = [[NSArray alloc] initWithArray:[self match_string_parent:my_selected_data]];
    if (parentarray.count > 0)
    {
        for (int k = 0; k < parentarray.count; k++)
        {
            Sample * s =[parentarray objectAtIndex:k];
            NSString * getvalue = [[NSString alloc] initWithString:s.parent];
            NSArray * tempstore = [getvalue componentsSeparatedByString:@","];
            NSMutableArray * temparray = [[NSMutableArray alloc] init];
            for (int j = 0; j < tempstore.count -1; j++)
            {
                NSLog(@"counter");
                if ([[tempstore objectAtIndex:j]isEqualToString:my_selected_data])
                {
                    break;
                }
                else
                {
                    [temparray addObject:[tempstore objectAtIndex:j]];
                }
            }
            //            [temparray removeLastObject];
            getvalue = [NSString stringWithFormat:@"%@,",[temparray componentsJoinedByString:@","]];
            
            NSLog(@"get value is what is = %@",getvalue);
            // getvalue = [getvalue stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",my_selected_data] withString:@""];
            [self update_parent:s.ids :getvalue];
            
            for (int delete = temparray.count + 1; delete < tempstore.count - 1; delete ++)
            {
                NSString * getvalue = [[NSString alloc] initWithFormat:@"%@",[tempstore objectAtIndex:delete]];
                [self Delete:[getvalue intValue]];
            }
        }
        
    }
    
    NSArray * childarray = [[NSArray alloc] initWithArray:[self match_string_child:my_selected_data]];
    if (childarray.count > 0)
    {
        for (int k = 0; k < childarray.count; k++)
        {
            Sample * s =[childarray objectAtIndex:k];
            NSString * getvalue = [[NSString alloc] initWithString:s.child];
            getvalue = [getvalue stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",my_selected_data] withString:@""];
            [self update_child:s.ids :getvalue];
        }
        
    }
    
    NSNumber * tempvalue =  [self getnumbervalue:s.ids];
    int new = [tempvalue intValue];
    new = new - 1;
    if (new >= 2)
    {
        [[NSUserDefaults standardUserDefaults]
         setObject:[NSString stringWithFormat:@"%d",new] forKey:@"preferenceName10"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self Delete:[s.ids intValue]];
    [self getdata];
    [self.mytable reloadData];
}
- (void)dealloc {
    [_mytable release];
    
    [_edit_button release];
    [super dealloc];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    
    [self setEdit_button:nil];
    [super viewDidUnload];
}
- (IBAction)edit:(id)sender
{
    //************** Ckeck The Bool If editable or not For user***********************
    if(EDIT_OR_VIEW_BOOL==YES)
    {
        EDITFLAG = YES;
        if (EDITFLAG == NO)
        {
            self.edit_button.hidden = NO;
        }
        else
        {
            self.edit_button.hidden = YES;
            [self.view makeToast:@"Now,You can edit data." duration:2.0 position:@"center"];
        }
        
        [self.mytable reloadData];
    }
    else
    {
         [self.view makeToast:@"You Don't Have permission to Edit data. You just view Data" duration:2.0 position:@"center"];
    }
   
}
@end
