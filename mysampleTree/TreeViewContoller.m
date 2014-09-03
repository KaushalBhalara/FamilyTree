//
//  TreeViewContoller.m
//  Mera Parivar
//
//  Created by Prajas on 4/21/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import "TreeViewContoller.h"
#import "UIDevice+Resolutions.h"
#import "UniversalUrl.h"
#import "SBJson.h"
#import "UIView+Toast.h"
#import "Sample.h"
#import "AppDelegate.h"
#import "UIDevice+Resolutions.h"
#import "NewAdddata.h"
#import <QuartzCore/QuartzCore.h>
#import "Share_Tree_ViewContoller.h"
#import "ASIFormDataRequest.h"
#import "FTWCache.h"
#import "NSString+MD5.h"
@interface TreeViewContoller ()

@end

@implementation TreeViewContoller
@synthesize queue,myscroll,innerview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (NSString *)PathOfBackgroundImages
{
    NSArray *path3 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentfolder3 = [path3 objectAtIndex:0];
    return [documentfolder3 stringByAppendingPathComponent:@"BackGroundData"];
    
}
#pragma mark - Web service Function
 -(void)requestFailed:(ASIHTTPRequest *)request
 {
     
   // http://prajas.com/familytree/images/PHOTO_68611406039460
     
     [self.view hideToastActivity];
     NSError *error = [request error];
    [self.view makeToast:@"Server is down please try again later" duration:3.0 position:@"center"];
     NSLog(@"requestFailed:%@",error);
 }
-(void)getdata :(NSString *)facebookId
{
    NSLog(@"facebookId=--=%@",facebookId);
    NSString * urlstring = [[NSString alloc] initWithFormat:@"%@%@",getdata_URL,facebookId];
    NSLog(@"urlstring==%@",urlstring);
    NSURL * myurl = [NSURL URLWithString:urlstring];
    ASIHTTPRequest *requestbyuidgetdata = [ASIHTTPRequest requestWithURL:myurl];
    [requestbyuidgetdata setDelegate:self];
    [requestbyuidgetdata setDidFinishSelector:@selector(requestDonegetdata:)];
    [requestbyuidgetdata setDidFailSelector:@selector(requestFailed:)];

    [self.queue addOperation:requestbyuidgetdata];
    //[requestbyuid startAsynchronous];
}

- (void)requestDonegetdata:(ASIHTTPRequest *)request
{
    //NSLog(@"Request==%@",request);
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"Insert Value = %@",responsevalue );
    
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
    storeUserSpose = [[NSString alloc] initWithString:[spouseArr objectAtIndex:0]];
    //*ageArr,*lastArr,*genderArr
    ageArr=[[NSMutableArray alloc]init];
    ageArr=[[responsevalue valueForKey:@"age"]retain];
    lastArr=[[NSMutableArray alloc]init];
    lastArr=[[responsevalue valueForKey:@"last"]retain];
    genderArr=[[NSMutableArray alloc]init];
    genderArr=[[responsevalue valueForKey:@"gender"]retain];
    
    profile_name=[[NSMutableArray alloc]init];
    profile_name=[[responsevalue valueForKey:@"profile_name"]retain];
    
    devicetokenArr=[[NSMutableArray alloc]init];
    devicetokenArr=[[responsevalue valueForKey:@"devicetoken"]retain];
    
    storeUserprofileName=[[NSString alloc] initWithFormat:@"%@",[profile_name objectAtIndex:0]];
    
    NSArray *tempparent = [responsevalue valueForKey:@"parent"];
    
    storeUserparent = [[NSString alloc] initWithFormat:@"%@",[tempparent objectAtIndex:0]];
    NSArray *tempsibling = [responsevalue valueForKey:@"siblings"];
    storeUsersibling = [[NSString alloc] initWithFormat:@"%@",[tempsibling objectAtIndex:0]];
    
    NSArray *tempchild = [responsevalue valueForKey:@"child"];
    storeUserchild = [[NSString alloc] initWithFormat:@"%@",[tempchild objectAtIndex:0]];
    
    NSArray *tempname = [responsevalue valueForKey:@"name"];
    storeUsername = [[NSString alloc] initWithFormat:@"%@",[tempname objectAtIndex:0]];
    
    NSArray * tempids = [responsevalue valueForKey:@"ids"];
    storeUserids = [[NSString alloc] initWithFormat:@"%@",[tempids objectAtIndex:0]];
    
//    NSLog(@"Parent Value is == %@",tempparent);
//    NSLog(@"Child value is == %@",CHILD);
    Sample *s = [mynewarray objectAtIndex:0];
    
    NSLog(@"MY name == %@ Id == %@ Child == %@ Parent == %@ Sibling == %@ number == %@ profile_name = %@",s.name,s.ids,s.child,s.parent,s.sibling,s.number,s.profile_name);
    
    NSString * tempParentvalue = storeUserparent;//s.parent;
    NSArray * totalparentvalue = [tempParentvalue componentsSeparatedByString:@","];
    
    //self.myscroll.sc
    NSString * tempstoresibling = storeUsersibling;//s.sibling;
    //    NSLog(@"tempstoresibling == %@",tempstoresibling);
    NSArray * totalsilind = [tempstoresibling componentsSeparatedByString:@","];
    //    NSLog(@"totalsilind == %@",totalsilind);
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        self.myscroll.delegate = self;
        self.myscroll.scrollEnabled = YES;
        self.myscroll.showsHorizontalScrollIndicator = YES;
        self.myscroll.showsVerticalScrollIndicator = YES;
        self.myscroll.contentSize = CGSizeMake(900, 1400);
        self.innerview.frame = CGRectMake(0, 0, self.myscroll.contentSize.width, self.myscroll.contentSize.height);
        self.myscroll.contentOffset = CGPointMake(120, 500);
        [self initaluserPosition:storeUsername :storeUserids:storeUserprofileName];
       // NSLog(@"Complete User Create");
        // [self.myscroll addSubview:self.innerview];
    }
    else
    {
        if (totalsilind.count >3)
        {
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
            }
            else
            {
                self.myscroll.contentSize = CGSizeMake(320 + (totalsilind.count * 70) , 1280);
                self.innerview.frame = CGRectMake(0, 0, self.myscroll.contentSize.width, self.myscroll.contentSize.height);
                self.myscroll.contentOffset = CGPointMake(self.myscroll.contentSize.width/3.3,self.myscroll.contentSize.height/2.1);
                [self initaluserPosition:storeUsername :storeUserids:storeUserprofileName];
                [self.myscroll addSubview:self.innerview];
            }
        }
        else
        {
            self.myscroll.contentSize = CGSizeMake(500  , 1280);
            self.innerview.frame = CGRectMake(0, 0, self.myscroll.contentSize.width, self.myscroll.contentSize.height);
            self.myscroll.contentOffset = CGPointMake(125, 600);
            [self initaluserPosition:storeUsername :storeUserids:storeUserprofileName];
            [self.myscroll addSubview:self.innerview];
        }
    }
    //    self.innerview.frame = CGRectMake(self.myscroll.frame.origin.x, self.myscroll.frame.origin.y, self.myscroll.frame.size.width, self.myscroll.frame.size.height);
    
    //[self.myscroll addSubview:self.innerview];
    //    [self.myscroll addSubview:self.innerview];
    self.myscroll.scrollEnabled = YES;
    
    
    numberofsibbling= 0;
    
    NSLog(@"totalparentvalue == %@",totalparentvalue);
    NSString *savedValue1 = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"preferenceName10"];
    NSLog(@"preferenceName10 %@ ",savedValue1);
    ParentsettingCounter = 0;
    NSLog(@"count for total parent == %d",totalparentvalue.count);
    if (totalparentvalue.count == 1)
    {
        //        NSLog(@"count for total parent == %d",totalparentvalue.count);
        FIRSTADDPARENT = YES;
    }
    
    if (totalparentvalue.count == 0)
    {
        
        if (totalparentvalue != nil)
        {
            
        }
    }
    else
    {
        //        FIRSTADDPARENT = NO;
        for(int jk = 2; jk <= [totalparentvalue count]; jk++)
        {
            
            int indename=[numberArr indexOfObject:[NSString stringWithFormat:@"%d",jk]];
            NSString  *totalparentvalued =[[NSString alloc] initWithFormat:@"%@",[IdsArr objectAtIndex:indename]];
            numberofparent = 0;
            for (int k = 0; k < 1; k++)
            {
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    originx = papax;
                    originy = papay - 85 * (jk-1);
                }
                else
                {
                    originx = papax;
                    originy = papay - 85*(jk-1);
                }
                
                NSString * mystring = totalparentvalued;
                NSLog(@"Chodu string =%@",mystring);
//                if([mystring length]>0)
//                {
                    int indexno=[IdsArr indexOfObject:mystring];
                NSLog(@"indexno === %d",indexno);
                    NSString *mystring12=[NameOfArr objectAtIndex:indexno];
                    NSString *myimagename=[profile_nameArr objectAtIndex:indexno];
                    NSString * myspouse=[spouseArr objectAtIndex:indexno];
                NSLog(@"call This or not");
                    [self DrawParent:mystring12:mystring:myimagename:myspouse];
               // }
                NSLog(@"count for k == %d",k);
            }
        }
    }
    
    if (totalsilind.count == 0)
    {
        if (tempstoresibling != nil)
        {
        }
    }
    else
    {
               NSLog(@"totalsilind == %@",totalsilind);
                NSLog(@"First_Name == %@",First_Name);
        
        SiblingTotal = totalsilind.count;
        for (int k = 0; k < totalsilind.count - 1; k++)
        {
            originx = siblingx;
            originy = siblingy;
            NSString * mystring = [totalsilind objectAtIndex:k];
            NSLog(@"mystring = %@",mystring);
            
//            if([mystring length]>0)
//            {
                int indexno=[IdsArr indexOfObject:mystring];
                NSString *mystring12=[NameOfArr objectAtIndex:indexno];
                NSString *myimagename=[profile_nameArr objectAtIndex:indexno];
                
                // NSString * mystring12 = [[NSString alloc] initWithString:[self getdataname:mystring]];
                NSLog(@"mystring12=%@",mystring12);
                //NSString * myimagename = [[NSString alloc] initWithString:[self getdataProfilename:mystring]];
                NSLog(@"myimagename =%@",myimagename);
              [self drawsibling:mystring12 :mystring :myimagename];
          //  }
        
            
            
        }
        if (SiblingTotal > 2)
        {
            [self LineDraw:_Upside_Sibling_store_left :_Upside_Sibling_store_right];
        }
    }
    numberofsibbling= 0;
    NSString * tempchildvalue = storeUserchild;//s.child;
    NSArray * totaltempchildvalue = [tempchildvalue componentsSeparatedByString:@","];
    ChildTotal = totaltempchildvalue.count;
    NSLog(@"ChildTotal == %d",ChildTotal);
    if (totaltempchildvalue.count == 0)
    {
        if (totaltempchildvalue != nil)
        {
            
        }
    }
    else
    {   NSLog(@"totaltempchildvalue=%@",totaltempchildvalue);
        
        for (int k = 0; k < totaltempchildvalue.count - 1; k++)
        {
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                originx = childx ;
                originy = childy + 190;
            }
            else
            {
                originx = childx;
                originy = childy + 85;
            }
            NSString * mystring = [totaltempchildvalue objectAtIndex:k];
            int indexno = 0;
            
//            if([mystring length]>0)
//            {
               indexno=[IdsArr indexOfObject:mystring];
                NSLog(@"mystring lodu =%@",mystring);
                NSLog(@"indexno lodu =%d",indexno);
                NSString *mystring12=[NameOfArr objectAtIndex:indexno];
                NSString *myimagename=[profile_nameArr objectAtIndex:indexno];
                // NSString * mystring12 = [[NSString alloc] initWithString:[self getdataname:mystring]];
                // NSString * myimagename = [[NSString alloc] initWithString:[self getdataProfilename:mystring]];
                //            [self DrawChild:mystring12 :myimagename];
                [self DrawChild:mystring12 :mystring :myimagename];
           // }
            
           
        }
        if (ChildTotal > 2)
        {
            [self LineDraw:_Child_Up_left :_Child_Up_right];
        }
    }
    [self.view hideToastActivity];
}
-(void)parent_data_add :(NSString *)firstname :(NSString *)lastname :(NSString *) gender
{
   // NSString * urlstring = [[NSString alloc] initWithFormat:@"%@name=%@&surname=%@&age=%@&gender=%@&profile_name=%@%@&fb_id=%@",parent_URL,firstname,lastname,@"0",gender,firstname,lastname,facebookID];
    
    NSString *imageFilePath = [[NSBundle mainBundle] pathForResource:@"sample_profile" ofType:@"png"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:imageFilePath];
        NSString *ProfName=[[NSString alloc]initWithFormat:@"%@%@",firstname,lastname];
    NSURL * myurl = [NSURL URLWithString:parent_URL];
    NSLog(@"insert_URL = =%@",insert_URL);
    
    ASIFormDataRequest *requestbyuidpapa = [ASIFormDataRequest requestWithURL:myurl];
    [requestbyuidpapa setPostValue:facebookID forKey:@"fb_id"];
    [requestbyuidpapa setPostValue:gender forKey:@"gender"];
    [requestbyuidpapa setPostValue:lastname forKey:@"surname"];
    [requestbyuidpapa setPostValue:firstname forKey:@"name"];
    [requestbyuidpapa setPostValue:@"0" forKey:@"age"];
    [requestbyuidpapa setPostValue:ProfName forKey:@"profile_name"];
    [requestbyuidpapa setData:data withFileName:facebookID andContentType:@"image/jpeg" forKey:@"userfile"];
    [requestbyuidpapa setDelegate:self];
    [requestbyuidpapa setDidFinishSelector:@selector(requestDoneParentAdd:)];
    [requestbyuidpapa setDidFailSelector:@selector(requestFailed:)];
    
    [self.queue addOperation:requestbyuidpapa];
    
    
    
    /*
    NSLog(@"urlstring papa == %@",urlstring);
    NSURL * myurl = [NSURL URLWithString:urlstring];
    ASIHTTPRequest *requestbyuidpapa = [ASIHTTPRequest requestWithURL:myurl];
    [requestbyuidpapa setDelegate:self];
    [requestbyuidpapa setDidFinishSelector:@selector(requestDoneParentAdd:)];
    [requestbyuidpapa setDidFailSelector:@selector(requestFailed:)];

    [self.queue addOperation:requestbyuidpapa];
   // [requestbyuid startAsynchronous];*/
    
}

- (void)requestDoneParentAdd:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"Insert Value requestDoneParentAdd = %@",responsevalue );
}

-(void)sibliing_data_add :(NSString *)firstname :(NSString *)lastname :(NSString *)gender :(NSString *)Imageurl
{
   // NSString * urlstring = [[NSString alloc] initWithFormat:@"%@name=%@&surname=%@&age=%@&gender=%@&profile_name=%@%@&fb_id=%@",sibling_URL,firstname,lastname,@"0",gender,firstname,lastname,facebookID];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",Imageurl]];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    NSString *ProfName=[[NSString alloc]initWithFormat:@"%@%@",firstname,lastname];
    
    NSURL * myurl = [NSURL URLWithString:sibling_URL];
    NSLog(@"insert_URL = =%@",insert_URL);
    
    ASIFormDataRequest *requestbyuidsibling = [ASIFormDataRequest requestWithURL:myurl];
    [requestbyuidsibling setPostValue:facebookID forKey:@"fb_id"];
    [requestbyuidsibling setPostValue:gender forKey:@"gender"];
    [requestbyuidsibling setPostValue:lastname forKey:@"surname"];
    [requestbyuidsibling setPostValue:firstname forKey:@"name"];
    [requestbyuidsibling setPostValue:@"0" forKey:@"age"];
    [requestbyuidsibling setPostValue:ProfName forKey:@"profile_name"];
    [requestbyuidsibling setData:data withFileName:facebookID andContentType:@"image/jpeg" forKey:@"userfile"];
    [requestbyuidsibling setDelegate:self];
    [requestbyuidsibling setDidFinishSelector:@selector(requestDoneParentAdd:)];
    [requestbyuidsibling setDidFailSelector:@selector(requestFailed:)];
    
    [self.queue addOperation:requestbyuidsibling];
    
    
    
    
    /*
    urlstring = [urlstring stringByReplacingOccurrencesOfString:@" "  withString:@"%20"];
    NSLog(@"urlstring == %@",urlstring);
    NSURL * myurl = [NSURL URLWithString:urlstring];
    ASIHTTPRequest *requestbyuidsibling = [ASIHTTPRequest requestWithURL:myurl];
    [requestbyuidsibling setDelegate:self];
    [requestbyuidsibling setDidFinishSelector:@selector(requestDoneSiblingAdd:)];
    [requestbyuidsibling setDidFailSelector:@selector(requestFailed:)];
    [self.queue addOperation:requestbyuidsibling];*/
}

- (void)requestDoneSiblingAdd:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"Insert Value requestDoneSiblingAdd = %@",responsevalue );
}

#pragma mark - Core database

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
    
//    [self.navigationController popViewControllerAnimated:YES];
    
    NSError *error;
    
    if (![context save:&error])
    {
        NSLog(@"Ohhhhh You are fool because no memory you have");
    }
}

-(NSArray *)GetUserData :(NSString *)idsValue
{
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ids == %@", idsValue];
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

-(void )getdata
{
    mynewarray = [[NSArray alloc] init];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    mynewarray = [context executeFetchRequest:request error:&error];
    
    [mynewarray retain];
    
    Sample *s = [mynewarray lastObject];
    int temp = [s.ids integerValue];
    NSLog(@"temp == %@",s.name);
    LASTID = 1 + temp;
    
    //    [self.mytable reloadData];
    
}

-(NSString*)getdatanamed :(NSString *)idvalue
{
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"number == %@", idvalue];
    [request setPredicate:predicate];
    [request setEntity:entity];
    NSLog(@"my number is %@",idvalue);
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

-(NSString*)getdataname :(NSString *)idvalue
{
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ids == %@", idvalue];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray * define_array = [context executeFetchRequest:request error:&error];
//    NSLog(@"define_array == %@",define_array);
    if (define_array.count > 0) {
        Sample *s =[define_array objectAtIndex:0];
        NSLog(@"s name is  == %@",s.name);
        return s.name;
    }
    else{
        return @"";
    }
}

-(NSString*)getdataProfilename :(NSString *)idvalue
{
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ids == %@", idvalue];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray * define_array = [context executeFetchRequest:request error:&error];
//    NSLog(@"define_array == %@",define_array);
    if (define_array.count > 0) {
        Sample *s =[define_array objectAtIndex:0];
        NSLog(@"s name is  == %@",s.profile_name);
        return s.profile_name;
    }
    else{
        return @"";
    }
}
-(NSString*)getSpouse :(NSString *)idvalue
{
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ids == %@", idvalue];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray * define_array = [context executeFetchRequest:request error:&error];
//    NSLog(@"define_array == %@",define_array);
    if (define_array.count > 0) {
        Sample *s =[define_array objectAtIndex:0];
        NSLog(@"s name is  == %@",s.spouse);
        return s.spouse;
    }
    else{
        return @"";
    }
}
-(NSString*)getcolumn :(NSString *) myidpass
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ids == %@", myidpass];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray * define_array = [context executeFetchRequest:request error:&error];
//    NSLog(@"define_array == %@",define_array);
    Sample *s =[define_array objectAtIndex:0];
    NSString * returnvalue = [[NSString alloc] initWithFormat:@"%@",s.number];
    return returnvalue;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    /*
    for(UIView *subview in [self.myscroll subviews])
    {
        [subview removeFromSuperview];
//        self.innerview = nil;
//        self.line_view = nil;
    }
    for(UIView *subview in [self.innerview subviews])
    {
        [subview removeFromSuperview];
    }*/
//    self.innerview = [[Line_View alloc] init];
//    self.innerview.backgroundColor = [UIColor colorWithRed:61/255.0 green:58/255.0 blue:57/255.0 alpha:1.0];
//    self.line_view = [[Line_View alloc] init];
//    [[self line_view] setNeedsDisplay];
}

//****************** Facebook Coredata **************************
-(void)parent :(NSString *)firstname :(NSString *)lastname :(NSString *)gender
{
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"preferenceName10"];
    NSLog(@"savedata === %@",savedValue);
    if (savedValue == nil)
    {
        NSLog(@"callll this ---->");
//        PARENTCOUNTER = 2;
        
        [[NSUserDefaults standardUserDefaults]
         setObject:@"2" forKey:@"preferenceName10"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
//        NSLog(@"callll this ----> %d",PARENTCOUNTER);
//        PARENTCOUNTER = [savedValue integerValue];
//        PARENTCOUNTER = 1 + PARENTCOUNTER;
//        [[NSUserDefaults standardUserDefaults]
//         setObject:[NSString stringWithFormat:@"%d",PARENTCOUNTER] forKey:@"preferenceName10"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    Sample *s = [NSEntityDescription insertNewObjectForEntityForName:@"Sample" inManagedObjectContext:context];
    
    s.name = firstname;
    s.ids = [NSString stringWithFormat:@"%d",LASTID];
    s.parent =@"";
    s.child = [NSString stringWithFormat:@"%@,",IDS];
    s.sibling = @"";
    s.number = [NSNumber numberWithInt:2];
    s.last = lastname;
    s.age = [NSNumber numberWithInt:0];
    s.gender =gender;
    s.profile_name = [NSString stringWithFormat:@"%@%@",firstname,lastname];
    s.spouse = @"";
    
    NSError *error;
    
    if (![context save:&error])
    {
        NSLog(@"Ohhhhh You are fool because no memory you have");
    }
    
    NSLog(@"NAME == %@ ,IDs == %@ , Parent == %@ , LatsID = %d",NAME,IDS,PARENT,LASTID);
    NSLog(@"First Array is  == %@",[mynewarray objectAtIndex:0]);
    
    
    NSManagedObject * device = [mynewarray objectAtIndex:0];
    [device setValue:NAME forKey:@"name"];
    [device setValue:IDS forKey:@"ids"];
    if ([PARENT isEqualToString:@"<null>"] || PARENT == nil || PARENT.length < 1)
    {
        NSLog(@"call THis");
        // NSLog(@"NAME == %@ ,IDs == %@ , Parent == %@ , LatsID = %d",NAME,IDS,PARENT,LASTID);
        [device setValue:[NSString stringWithFormat:@"%d,",LASTID] forKey:@"parent"];
    }
    else
    {
        NSLog(@"call THis Not");
         //NSLog(@"NAME == %@ ,IDs == %@ , Parent == %@ , LatsID = %d",NAME,IDS,PARENT,LASTID);
        [device setValue:[NSString stringWithFormat:@"%@%d,",PARENT,LASTID] forKey:@"parent"];
    }
    
    [device setValue:CHILD forKey:@"child"];

    [device setValue:SYBILING forKey:@"sibling"];
    
    
    NSError *error1;
    
    if (![context save:&error1])
    {
        NSLog(@"Ohhhhh You are fool because no memory you have");
    }
    
    
    
    
//    [context save:&error];
    
}
-(void)sybiling :(NSString *)firstname :(NSString *)lastname :(NSString*)male
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    Sample *s = [NSEntityDescription insertNewObjectForEntityForName:@"Sample" inManagedObjectContext:context];
    
    s.name = firstname;
    s.ids = [NSString stringWithFormat:@"%d",LASTID];
    s.number = [NSNumber numberWithInt:1];
    s.parent =@"";
    s.child = @"";
    s.sibling = [NSString stringWithFormat:@"%@,",IDS];
    s.last = lastname;
    s.age = [NSNumber numberWithInt:0];
    s.gender = male;
    s.profile_name = [NSString stringWithFormat:@"%@%@",firstname,lastname];
    s.spouse = @"";
    
    
    NSError *error;
    
    if (![context save:&error])
    {
        NSLog(@"Ohhhhh You are fool because no memory you have");
    }
    NSLog(@"Secon time Array is  == %@",[mynewarray objectAtIndex:0]);
    NSManagedObject * device = [mynewarray objectAtIndex:0];
    [device setValue:NAME forKey:@"name"];
    [device setValue:IDS forKey:@"ids"];
   // [device setValue:PARENT forKey:@"parent"];
    //[device setValue:CHILD forKey:@"child"];
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
    
}

-(void)child :(NSString *)firstname :(NSString *)lastname :(NSString *)gender
{
    if ([CHILD isEqualToString:@"<null>"] || CHILD.length >0)
    {
        //        CHILD = @"0,";
    }
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    
    Sample *s = [NSEntityDescription insertNewObjectForEntityForName:@"Sample" inManagedObjectContext:context];
    
    
    s.name = firstname;
    s.ids = [NSString stringWithFormat:@"%d",LASTID];
    s.parent =[NSString stringWithFormat:@"%@,",IDS];
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
    
//    [device setValue:NAME forKey:@"name"];
//    [device setValue:IDS forKey:@"ids"];
//    [device setValue:PARENT forKey:@"parent"];
    if ([CHILD isEqualToString:@"<null>"] || CHILD == nil)
    {
        [device setValue:[NSString stringWithFormat:@"%d,",LASTID] forKey:@"child"];
    }
    else
    {
        [device setValue:[NSString stringWithFormat:@"%@%d,",CHILD,LASTID] forKey:@"child"];
    }
    
//    [device setValue:SYBILING forKey:@"sibling"];
    
    NSError *error1;
    
    if (![context save:&error1])
    {
        NSLog(@"Ohhhhh You are fool because no memory you have");
    }
    
}


-(void)CalloneTime
{
   // [self insert_data];
}
-(void)CalloneTime1
{
    [self parent_data_add:@"Add" :@"PaPa" :@"Male"];
}
-(void)CalloneTime2
{
    [self.view makeToastActivity];
    [self getdata:Pass_User_ID];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(Ckeck_For_Share_Button==YES)
    {
        [self.Share_Button setHidden:NO];
       // Ckeck_For_Share_Button=NO;
    }
    else
    {
        [self.Share_Button setHidden:YES];
    }
    if(EDITFAMILYBOOL==YES)
    {
        for(UIView *subview in [self.myscroll subviews])
        {
            [subview removeFromSuperview];
            //        self.innerview = nil;
            //        self.line_view = nil;
        }
        for(UIView *subview in [self.innerview subviews])
        {
            [subview removeFromSuperview];
        }
    }
    if(EDIT_IS_DONE_BOOL==YES)
    {
        for(UIView *subview in [self.myscroll subviews])
        {
            [subview removeFromSuperview];
            //        self.innerview = nil;
            //        self.line_view = nil;
        }
        for(UIView *subview in [self.innerview subviews])
        {
            [subview removeFromSuperview];
        }
    }
    if(ADD_NEW_ENTITY_BOOL==YES)
    {
        for(UIView *subview in [self.myscroll subviews])
        {
            [subview removeFromSuperview];
            //        self.innerview = nil;
            //        self.line_view = nil;
        }
        for(UIView *subview in [self.innerview subviews])
        {
            [subview removeFromSuperview];
        }
    }
    FlagCallOne = NO;

    self.line_view.lines = [[NSMutableArray alloc] init];
    _last_touch_point = CGPointMake(-1.0, -1.0);
    numberofchild = 0;
    numberofparent = 0;
    numberofsibbling = 0;
    tempcount = 1;
    papax = 0.0;
    papay = 0.0;
    siblingx = 0.0;
    siblingy = 0.0;
    
    if (![self queue]) {
        [self setQueue:[[[NSOperationQueue alloc] init] autorelease]];
    }
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"preferenceName1"];
    NSLog(@"savedValue === %@",savedValue);
    if (User_Relation.count > 0)
    {
        if ([savedValue isEqualToString:@"YES"])
        {
            self.Tree_Title_Label.text=[NSString stringWithFormat:@"%@ FAMILY TREE",Tree_title_String.uppercaseString];
        }
        else
        {
            NSLog(@"insert data");
            // [self getdata];
            // [self getdata:facebookID];
            Sample *s = [mynewarray objectAtIndex:0];
            PARENT = s.parent;
            CHILD = s.child;
            SYBILING = s.sibling;
            IDS = s.ids;
            NAME = s.name;
            
            int temp = [s.ids integerValue];
            LASTID = 1 + temp;
            NSLog(@"LASTID == %d",LASTID);
            BOOL CHECKP = NO;
            
            for (int k = 0; k < User_Relation.count; k++)
            {
                NSString * fetchdata = [[[NSString alloc] initWithFormat:@"%@",[User_Relation objectAtIndex:k]] autorelease];
                if ([fetchdata isEqualToString:@"father"])
                {
                    CHECKP = YES;
                }
            }
            
            if (CHECKP == YES)
            {
                CHECKP = NO;
            }
            else
            {
                FIRSTADDPARENT = NO;
                // [self getdata];
                Sample *s = [mynewarray objectAtIndex:0];
                PARENT = s.parent;
                CHILD = s.child;
                SYBILING = s.sibling;
                IDS = s.ids;
                NAME = s.name;
                int temp = [s.ids integerValue];
                LASTID = 1 + temp;
                [self parent:@"Add" :@"PaPa" : @"Male"];
                //            [self performSelectorOnMainThread:@selector(CalloneTime1) withObject:nil waitUntilDone:YES];
                [self parent_data_add:@"Add" :@"PaPa" :@"Male"];
                
                //            [self parent_data_add:@"Add" :@"PaPa" :@"Male"];
                
                //            NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                
                // If you go to the folder below, you will find those pictures
                //            NSLog(@"%@",docDir);
                
                //            NSLog(@"saving png");
                
                
                NSString * profilename = [[NSString alloc] initWithFormat:@"%@%@",@"Add",@"PaPa"];
                NSString *imageFilePath = [[NSBundle mainBundle] pathForResource:@"sample_profile" ofType:@"png"];
                //            NSLog(@"imagefile path == %@",imageFilePath);
                //            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imageFilePath]];
                NSData *data = [[NSData alloc] initWithContentsOfFile:imageFilePath];
                //            NSLog(@"data image is = %@",data);
                [data writeToFile:[LoginView FacebookImageDirect:profilename] atomically:YES];
                CHECKP = NO;
            }
            for (int k = 0; k < User_Relation.count; k++)
            {
                if ([[User_Relation objectAtIndex:k] isEqualToString:@"sister"])
                {
                    NSLog(@"Sistername == %@ %@",[First_Name objectAtIndex:k],[Last_Name objectAtIndex:k]);
                    //[self getdata];
                    Sample *s = [mynewarray objectAtIndex:0];
                    PARENT = s.parent;
                    CHILD = s.child;
                    SYBILING = s.sibling;
                    IDS = s.ids;
                    NAME = s.name;
                    Sample *s1 = [mynewarray lastObject];
                    int temp = [s1.ids integerValue];
                    
                    LASTID = 1 + temp;
                    NSLog(@"LASTID == %d",LASTID);
                    
                    [self sybiling:[First_Name objectAtIndex:k] :[Last_Name objectAtIndex:k] :@"Female"];
                    [self sibliing_data_add:[First_Name objectAtIndex:k] :[Last_Name objectAtIndex:k] :@"Female" :[Image_Url objectAtIndex:k]];
                    
                    //                counter = 1 + counter;
                    //                [self sybiling:[firstname objectAtIndex:k] :[lastname objectAtIndex:k] :@"Female"];
                    //
                    NSString * profilename = [[NSString alloc] initWithFormat:@"%@%@",[First_Name objectAtIndex:k],[Last_Name objectAtIndex:k]];
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[Image_Url objectAtIndex:k]]];
                    
                    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
                    
                    [data writeToFile:[LoginView FacebookImageDirect:profilename] atomically:YES];
                }
                else if ([[User_Relation objectAtIndex:k] isEqualToString:@"brother"])
                {
                    NSLog(@"Brother");
                    // [self getdata];
                    Sample *s = [mynewarray objectAtIndex:0];
                    PARENT = s.parent;
                    CHILD = s.child;
                    SYBILING = s.sibling;
                    IDS = s.ids;
                    NAME = s.name;
                    Sample *s1 = [mynewarray lastObject];
                    int temp = [s1.ids integerValue];
                    
                    LASTID = 1 + temp;
                    NSLog(@"LASTID == %d",LASTID);
                    
                    [self sybiling:[First_Name objectAtIndex:k] :[Last_Name objectAtIndex:k] :@"Female"];
                    [self sibliing_data_add:[First_Name objectAtIndex:k] :[Last_Name objectAtIndex:k] :@"male" :[Image_Url objectAtIndex:k]];
                    
                    //                counter = 1 + counter;
                    //                [self sybiling:[firstname objectAtIndex:k] :[lastname objectAtIndex:k] :@"Female"];
                    //
                    NSString * profilename = [[NSString alloc] initWithFormat:@"%@%@",[First_Name objectAtIndex:k],[Last_Name objectAtIndex:k]];
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[Image_Url objectAtIndex:k]]];
                    
                    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
                    
                    [data writeToFile:[LoginView FacebookImageDirect:profilename] atomically:YES];
                }
                else if ([[User_Relation objectAtIndex:k] isEqualToString:@"mother"])
                {
                    NSLog(@"Mother");
                }
                else if ([[User_Relation objectAtIndex:k] isEqualToString:@"father"])
                {
                    NSLog(@"Father");
                }
                else if ([[User_Relation objectAtIndex:k] isEqualToString:@"son"])
                {
                    NSLog(@"Son");
                    //                counter = 1 + counter;
                    //
                    //                [self child:[firstname objectAtIndex:k] :[lastname objectAtIndex:k] :@"Male"];
                    // [self getdata];
                    Sample *s = [mynewarray objectAtIndex:0];
                    PARENT = s.parent;
                    CHILD = s.child;
                    SYBILING = s.sibling;
                    IDS = s.ids;
                    NAME = s.name;
                    Sample *s1 = [mynewarray lastObject];
                    int temp = [s1.ids integerValue];
                    
                    LASTID = 1 + temp;
                    NSLog(@"LASTID == %d",LASTID);
                    
                    [self child:[First_Name objectAtIndex:k] :[Last_Name objectAtIndex:k] :@"Female"];
                    
                    //                counter = 1 + counter;
                    //                [self sybiling:[firstname objectAtIndex:k] :[lastname objectAtIndex:k] :@"Female"];
                    //
                    NSString * profilename = [[NSString alloc] initWithFormat:@"%@%@",[First_Name objectAtIndex:k],[Last_Name objectAtIndex:k]];
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[Image_Url objectAtIndex:k]]];
                    
                    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
                    
                    [data writeToFile:[LoginView FacebookImageDirect:profilename] atomically:YES];
                    
                }
                else if ([[User_Relation objectAtIndex:k] isEqualToString:@"daughter"])
                {
                    NSLog(@"Daughter");
                    //[self getdata];
                    Sample *s = [mynewarray objectAtIndex:0];
                    PARENT = s.parent;
                    CHILD = s.child;
                    SYBILING = s.sibling;
                    IDS = s.ids;
                    NAME = s.name;
                    Sample *s1 = [mynewarray lastObject];
                    int temp = [s1.ids integerValue];
                    
                    LASTID = 1 + temp;
                    NSLog(@"LASTID == %d",LASTID);
                    
                    [self child:[First_Name objectAtIndex:k] :[Last_Name objectAtIndex:k] :@"Female"];
                    
                    //                counter = 1 + counter;
                    //                [self sybiling:[firstname objectAtIndex:k] :[lastname objectAtIndex:k] :@"Female"];
                    //
                    NSString * profilename = [[NSString alloc] initWithFormat:@"%@%@",[First_Name objectAtIndex:k],[Last_Name objectAtIndex:k]];
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[Image_Url objectAtIndex:k]]];
                    
                    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
                    
                    [data writeToFile:[LoginView FacebookImageDirect:profilename] atomically:YES];
                    //                counter = 1 + counter;
                    //                
                    //                [self child:[firstname objectAtIndex:k] :[lastname objectAtIndex:k] :@"Female"];
                }
            }
            
            NSString * mystr = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/PHP-Data-Services-master/services/data/family_tree/family_tree_service/change_flag/change_relativeflag?secret=prajas&fb_id=%@",facebookID];
            NSURL * myurl = [NSURL URLWithString:mystr];
            ASIHTTPRequest *DoONETOSERVER = [ASIHTTPRequest requestWithURL:myurl];
            [DoONETOSERVER setDelegate:self];
            [DoONETOSERVER setDidFinishSelector:@selector(DOTHEDUE:)];
            [DoONETOSERVER setDelegate:self];
            [DoONETOSERVER startSynchronous];

        }
    }
    else
    {
         self.Tree_Title_Label.text=[NSString stringWithFormat:@"%@ FAMILY TREE",Tree_title_String.uppercaseString];
    }
    if(EDITFAMILYBOOL==YES)
    {
         [self performSelectorOnMainThread:@selector(CalloneTime2) withObject:nil waitUntilDone:YES];
        EDITFAMILYBOOL=NO;
    }
    else
    {
        if(CLICKTREEBOOL==YES)
        {
             [self performSelectorOnMainThread:@selector(CalloneTime2) withObject:nil waitUntilDone:YES];
            CLICKTREEBOOL=NO;
        }
    }
    
    if (EDIT_IS_DONE_BOOL==YES)
    {
         [self performSelectorOnMainThread:@selector(CalloneTime2) withObject:nil waitUntilDone:YES];
        EDIT_IS_DONE_BOOL=NO;
        NSLog(@"EDIT_IS_DONE_BOOL is YES");

    }
    if(ADD_NEW_ENTITY_BOOL==YES)
    {
        [self performSelectorOnMainThread:@selector(CalloneTime2) withObject:nil waitUntilDone:YES];
        ADD_NEW_ENTITY_BOOL=NO;
        NSLog(@"ADD_NEW_ENTITY_BOOL is YES");
    }
    else
    {
        NSLog(@"ADD_NEW_ENTITY_BOOL is NO");
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.myscroll.frame=CGRectMake(100, 300, 500, 900);
    
    //[self.myscroll scrollRectToVisible:CGRectMake(320,200,320,416) animated:NO];
    self.myscroll.minimumZoomScale=0.5;
    self.myscroll.maximumZoomScale=6.0;
    self.myscroll.delegate=self;
    //    NSArray * temp = [[NSArray alloc] initWithObjects:@"K",@"L",@"M", nil];
    Treee = [[NSMutableArray alloc] init];
    
    NSMutableArray * myarray = [[NSMutableArray alloc] initWithObjects:[NSMutableArray arrayWithObjects:@"1", nil],nil];
    [Treee addObject:myarray];
    
    NSMutableArray *arr = [myarray objectAtIndex:0];
    [arr addObject:[NSMutableArray arrayWithObjects:@"2", nil]];
    [myarray replaceObjectAtIndex:0 withObject:arr];
    [myarray addObject:[NSMutableArray arrayWithObjects:@"4", nil]];
    NSLog(@"my treee %@",Treee);
    // Do any additional setup after loading the view from its nib.
    
}
-(void)DOTHEDUE:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSDictionary *responsevalue = [response JSONValue];
    NSLog(@"responsevalue=%@",responsevalue);
}
#pragma mark - Object Method

-(void)DrawParent:(NSString *)name :(NSString*)setId : (NSString*)Profilename :(NSString *)spouse
{

    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        numberofparent ++ ;
        if(numberofparent % 2 == 0)
        {
            
            UIButton * mybutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [mybutton setTitle:name forState:UIControlStateNormal];
            [mybutton setTag:[setId integerValue]];
            mybutton.frame = CGRectMake(originx + 130 *numberofparent -1/2 ,originy , 80, 80);
            mybutton.titleLabel.font = [UIFont systemFontOfSize:18.0];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, 80, 15)];
            lable.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
            lable.text = [NSString stringWithFormat:@"%@",name];
            lable.font = [UIFont systemFontOfSize:15.0];
            lable.textAlignment = UITextAlignmentCenter;
            lable.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
            [mybutton addSubview:lable];
            [mybutton addTarget:self action:@selector(Callthis:) forControlEvents:UIControlEventTouchUpInside];
            [self.innerview addSubview:mybutton];
            
            CGPoint mypoint_bottomSide = CGPointMake(mybutton.frame.origin.x + 40 + (mybutton.frame.size.width / 2), mybutton.frame.origin.y + (mybutton.frame.size.height / 2));
            
//            NSLog(@"mypoint_bottomSide is _Parent_Bottom = %2.f - %2.f",mypoint_bottomSide.x,mypoint_bottomSide.y);
            _Parent_Bottom = mypoint_bottomSide;
            
            [self LineDraw:_User_Upside :_Parent_Bottom];
            
        }
        else
        {
            UIButton * mybutton = [UIButton buttonWithType:UIButtonTypeCustom];
            mybutton.layer.borderColor = [UIColor colorWithRed:92/255.0 green:88/255.0 blue:87/255.0 alpha:1.0].CGColor;
            mybutton.layer.borderWidth = 2.0;
            [mybutton setTag:[setId integerValue]];
            mybutton.frame = CGRectMake(originx - 130 *(numberofparent - 1)/2 ,originy, 80, 80);
            
            NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",Profilename];
            NSURL *imageURL = [NSURL URLWithString:imagestring];
            NSString *key = [imagestring MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                [mybutton setImage:image forState:UIControlStateNormal];
            } else {
                //		imageView.image = [UIImage imageNamed:@"img_def"];
                dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue1, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [mybutton setImage:image forState:UIControlStateNormal];
                        
                    });
                });
            }
            mybutton.layer.cornerRadius = 40.0f;
            mybutton.clipsToBounds = YES;
            [self.innerview addSubview:mybutton];
            //[mybutton setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:[NewAdddata PathOfBGImages:Profilename]]] forState:UIControlStateNormal];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(mybutton.frame.origin.x, mybutton.frame.origin.y + 80, 80, 15)];
            lable.backgroundColor = [UIColor clearColor];
            lable.text = [NSString stringWithFormat:@"%@",name];
            lable.font = [UIFont systemFontOfSize:14.0];
            lable.textAlignment = UITextAlignmentCenter;
            lable.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
            [self.innerview addSubview:lable];
            [mybutton addTarget:self action:@selector(Callthis:) forControlEvents:UIControlEventTouchUpInside];
            
            
            CGPoint mypoint1_leftSide;
            spouse = [spouse stringByReplacingOccurrencesOfString:@"," withString:@""];
            if (spouse.length == 0 || [spouse isEqualToString:@"<null>"] || spouse == nil)
            {
                UIButton * mybutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
                mybutton1.layer.borderColor = [UIColor colorWithRed:255/255.0 green:105/255.0 blue:180/255.0 alpha:1.0].CGColor;
                mybutton1.layer.borderWidth = 2.0;
                [mybutton1 setTag:[setId integerValue]];
                mybutton1.frame = CGRectMake(mybutton.frame.origin.x + 100 ,originy + 5, 70, 70);
                //            [mybutton1 setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:[NewAdddata PathOfBGImages:Profilename]]] forState:UIControlStateNormal];
                mybutton1.layer.cornerRadius = 35.0f;
                mybutton1.clipsToBounds = YES;
                [self.innerview addSubview:mybutton1];
                UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(mybutton1.frame.origin.x, mybutton1.frame.origin.y + 70, 70, 15)];
                lable1.backgroundColor = [UIColor clearColor];
                //            lable1.text = [NSString stringWithFormat:@"%@",name];
                lable1.font = [UIFont systemFontOfSize:14.0];
                lable1.textAlignment = UITextAlignmentCenter;
                lable1.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
                [self.innerview addSubview:lable1];
                [mybutton1 addTarget:self action:@selector(addSpouse:) forControlEvents:UIControlEventTouchUpInside];
                
                
                //********** for button mybutton1 ***************
                
                mypoint1_leftSide = CGPointMake(mybutton1.frame.origin.x - 35 + (mybutton1.frame.size.width / 2), mybutton1.frame.origin.y  + (mybutton1.frame.size.height / 2));
            }
            else
            {
                int selectedindex = [IdsArr indexOfObject:spouse];
                
                UIButton * mybutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
                mybutton1.layer.borderColor = [UIColor colorWithRed:255/255.0 green:105/255.0 blue:180/255.0 alpha:1.0].CGColor;
                mybutton1.layer.borderWidth = 2.0;
                [mybutton1 setTag:[setId integerValue]];
                mybutton1.frame = CGRectMake(mybutton.frame.origin.x + 100 ,originy + 5, 70, 70);
                [mybutton1 setTitle:[NameOfArr objectAtIndex:selectedindex] forState:UIControlStateNormal];
                
                NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",[profile_nameArr objectAtIndex:selectedindex]];
                NSURL *imageURL = [NSURL URLWithString:imagestring];
                NSString *key = [imagestring MD5Hash];
                NSData *data = [FTWCache objectForKey:key];
                if (data) {
                    UIImage *image = [UIImage imageWithData:data];
                    [mybutton1 setImage:image forState:UIControlStateNormal];
                } else {
                    //		imageView.image = [UIImage imageNamed:@"img_def"];
                    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                    dispatch_async(queue1, ^{
                        NSData *data = [NSData dataWithContentsOfURL:imageURL];
                        [FTWCache setObject:data forKey:key];
                        UIImage *image = [UIImage imageWithData:data];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [mybutton1 setImage:image forState:UIControlStateNormal];
                            
                        });
                    });
                }

                mybutton1.layer.cornerRadius = 35.0f;
                mybutton1.clipsToBounds = YES;
                [self.innerview addSubview:mybutton1];
                UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(mybutton1.frame.origin.x, mybutton1.frame.origin.y + 70, 70, 15)];
                lable1.backgroundColor = [UIColor clearColor];
//                [mybutton setTitle:[NSString stringWithFormat:@"%@",s1.name] forState:UIControlStateNormal];
                lable1.text = [NSString stringWithFormat:@"%@",[NameOfArr objectAtIndex:selectedindex]];
                lable1.font = [UIFont systemFontOfSize:14.0];
                lable1.textAlignment = UITextAlignmentCenter;
                lable1.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
                [self.innerview addSubview:lable1];
                [mybutton1 addTarget:self action:@selector(addSpouse:) forControlEvents:UIControlEventTouchUpInside];
                
                
                //********** for button mybutton1 ***************
                
                mypoint1_leftSide = CGPointMake(mybutton1.frame.origin.x - 35 + (mybutton1.frame.size.width / 2), mybutton1.frame.origin.y  + (mybutton1.frame.size.height / 2));
            }

            CGPoint mypoint_bottomSide = CGPointMake(mybutton.frame.origin.x  + (mybutton.frame.size.width / 2), mybutton.frame.origin.y + 40 + (mybutton.frame.size.height / 2));
            
            
            
            CGPoint mypoint_rightSide = CGPointMake(mybutton.frame.origin.x + 40 + (mybutton.frame.size.width / 2), mybutton.frame.origin.y  + (mybutton.frame.size.height / 2));
            
//            NSLog(@"mypoint_bottomSide _Parent_Bottom = %2.f - %2.f",mypoint_bottomSide.x,mypoint_bottomSide.y);
            _Parent_Bottom = mypoint_bottomSide;
            
            //*********** Draw Line B/W Husband and wife  ****************
            [self LineDraw:mypoint_rightSide :mypoint1_leftSide];
            
             
            CGPoint centerpoint = {mypoint1_leftSide.x - mypoint_rightSide.x,mypoint1_leftSide.y - mypoint_rightSide.y};
            //            NSLog(@"centerpoint X = %f",centerpoint.x);
            //            NSLog(@"centerpoint Y = %f",centerpoint.y);
            CGPoint newpiont = {mypoint_rightSide.x + centerpoint.x/2,mypoint_rightSide.y + 0};
            //            NSLog(@"newpiont X = %f",newpiont.x);
            //            NSLog(@"newpiont Y = %f",newpiont.y);
            
            CGPoint mynewpoint = {newpiont.x,newpiont.y+70};
            [self LineDraw:newpiont :mynewpoint];
            //            NSLog(@"mypoint_bottomSide _Parent_Bottom Second = %2.f - %2.f",mypoint_bottomSide.x,mypoint_bottomSide.y);
            
            _Parent_Bottom = mypoint_bottomSide;
            if (FlagCallOne == NO)
            {
                FlagCallOne = YES;
                _First_Parent_Bottom = mypoint_bottomSide;
                
            }
            if (ParentsettingCounter == 0)
            {
                _Upside_store = _User_Upside;
                ParentsettingCounter++;
                CGPoint upsideuser = {_Upside_store.x,_Upside_store.y - 35};
                //            [self LineDraw:_User_Upside :_Parent_Bottom];
                [self LineDraw:_Upside_store :upsideuser ];
                [self LineDraw:upsideuser :mynewpoint];
                
            }
            else
            {
                CGPoint upsideuser = {_Upside_store.x,_Upside_store.y - 20};
                //            [self LineDraw:_User_Upside :_Parent_Bottom];
//                [self LineDraw:_Upside_store :upsideuser ];
                [self LineDraw:upsideuser :mynewpoint];
            }
            
            _Upside_store = CGPointMake(mybutton.frame.origin.x  + (mybutton.frame.size.width / 2), mybutton.frame.origin.y - 25 + (mybutton.frame.size.height / 2));
            
//            _Parent_Bottom = mypoint_bottomSide;
//            if (FlagCallOne == NO)
//            {
//                FlagCallOne = YES;
//                _First_Parent_Bottom = mypoint_bottomSide;
//                
//            }
//
//            
//            [self LineDraw:_User_Upside :_Parent_Bottom];
            
        }

        
    }
    else
    {
        numberofparent ++ ;
        if(numberofparent % 2 == 0)
        {
            
            UIButton * mybutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            mybutton.layer.borderColor = [UIColor colorWithRed:92/255.0 green:88/255.0 blue:87/255.0 alpha:1.0].CGColor;
            mybutton.layer.borderWidth = 2.0;
            //[mybutton setTitle:name forState:UIControlStateNormal];
            [mybutton setTag:[setId integerValue]];
            mybutton.frame = CGRectMake(originx + 70 *numberofparent/2 ,originy , 50, 50);
            
            NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",Profilename];
            NSURL *imageURL = [NSURL URLWithString:imagestring];
            NSString *key = [imagestring MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                [mybutton setImage:image forState:UIControlStateNormal];
            } else {
                //		imageView.image = [UIImage imageNamed:@"img_def"];
                dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue1, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [mybutton setImage:image forState:UIControlStateNormal];
                        
                    });
                });
            }
//            [mybutton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0)];
//            [mybutton setTitleEdgeInsets:UIEdgeInsetsMake(40.0,-10.0, 0.0, 0.0)];
//            mybutton.titleLabel.font = [UIFont systemFontOfSize:12.0];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 38, 50, 12)];
            lable.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
            lable.text = [NSString stringWithFormat:@"%@",name];
            lable.font = [UIFont systemFontOfSize:12.0];
            lable.textAlignment = UITextAlignmentCenter;
            lable.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
            [mybutton addSubview:lable];
            [mybutton addTarget:self action:@selector(Callthis:) forControlEvents:UIControlEventTouchUpInside];
            [self.innerview addSubview:mybutton];
            
            CGPoint mypoint_bottomSide = CGPointMake(mybutton.frame.origin.x + 25 + (mybutton.frame.size.width / 2), mybutton.frame.origin.y + (mybutton.frame.size.height / 2));
            
//            NSLog(@"mypoint_bottomSide is _Parent_Bottom First = %2.f - %2.f",mypoint_bottomSide.x,mypoint_bottomSide.y);
            _Parent_Bottom = mypoint_bottomSide;
            
//            [self LineDraw:_User_Upside :_Parent_Bottom];
            
        }
        else
        {
            UIButton * mybutton = [UIButton buttonWithType:UIButtonTypeCustom];
            mybutton.layer.borderColor = [UIColor colorWithRed:92/255.0 green:88/255.0 blue:87/255.0 alpha:1.0].CGColor;
            mybutton.layer.borderWidth = 2.0;
            
//            [mybutton setTitle:name forState:UIControlStateNormal];
            
            [mybutton setTag:[setId integerValue]];
            mybutton.frame = CGRectMake(originx - 70 *(numberofparent - 1)/2 ,originy, 50, 50);
            mybutton.clipsToBounds=YES;
            mybutton.layer.cornerRadius = 25.0f;
            NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",Profilename];
            NSURL *imageURL = [NSURL URLWithString:imagestring];
            NSString *key = [imagestring MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                [mybutton setImage:image forState:UIControlStateNormal];
            } else {
                //		imageView.image = [UIImage imageNamed:@"img_def"];
                dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue1, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [mybutton setImage:image forState:UIControlStateNormal];
                        
                    });
                });
            }
            
            [mybutton addTarget:self action:@selector(Callthis:) forControlEvents:UIControlEventTouchUpInside];
            [self.innerview addSubview:mybutton];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(mybutton.frame.origin.x, mybutton.frame.origin.y + 50, 50, 12)];
            lable.backgroundColor = [UIColor clearColor];
            lable.text = [NSString stringWithFormat:@"%@",name];
            lable.font = [UIFont systemFontOfSize:12.0];
            lable.textAlignment = UITextAlignmentCenter;
            lable.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
            [self.innerview addSubview:lable];
            
            CGPoint mypoint1_leftSide;
            spouse = [spouse stringByReplacingOccurrencesOfString:@"," withString:@""];
            if (spouse.length == 0 || [spouse isEqualToString:@"<null>"] || spouse == nil)
            {
                UIButton * mybutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
                mybutton1.layer.borderColor = [UIColor colorWithRed:255/255.0 green:105/255.0 blue:180/255.0 alpha:1.0].CGColor;
                mybutton1.layer.borderWidth = 2.0;
                [mybutton1 setTag:[setId integerValue]];
                mybutton1.frame = CGRectMake(mybutton.frame.origin.x + 60 ,originy + 5, 40, 40);
                mybutton1.clipsToBounds = YES;
                mybutton1.layer.cornerRadius = 20.0f;
                //            [mybutton1 setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:[NewAdddata PathOfBGImages:Profilename]]] forState:UIControlStateNormal];
                
                
                [mybutton1 addTarget:self action:@selector(addSpouse:) forControlEvents:UIControlEventTouchUpInside];
                [self.innerview addSubview:mybutton1];
                
                UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(mybutton1.frame.origin.x, mybutton1.frame.origin.y + 40, 40, 12)];
                lable1.backgroundColor = [UIColor clearColor];
                //            lable1.text = [NSString stringWithFormat:@"%@",name];
                lable1.font = [UIFont systemFontOfSize:12.0];
                lable1.textAlignment = UITextAlignmentCenter;
                lable1.textColor = [UIColor clearColor];
                [self.innerview addSubview:lable1];
                //********** for button mybutton1 ***************
                
                mypoint1_leftSide = CGPointMake(mybutton1.frame.origin.x - 20 + (mybutton1.frame.size.width / 2), mybutton1.frame.origin.y  + (mybutton1.frame.size.height / 2));
            }
            else
            {
                int selectedindex = [IdsArr indexOfObject:spouse];
//                NSArray * wifedata = [[NSArray alloc] initWithArray:[self GetUserData:spouse]];
//                Sample * s1 =[wifedata objectAtIndex:0];
                
                UIButton * mybutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
                mybutton1.layer.borderColor = [UIColor colorWithRed:255/255.0 green:105/255.0 blue:180/255.0 alpha:1.0].CGColor;
                mybutton1.layer.borderWidth = 2.0;
                [mybutton1 setTag:[setId integerValue]];
                [mybutton1 setTitle:[NameOfArr objectAtIndex:selectedindex] forState:UIControlStateNormal];
                mybutton1.clipsToBounds = YES;
                mybutton1.layer.cornerRadius = 20.0f;
                mybutton1.frame = CGRectMake(mybutton.frame.origin.x + 60 ,originy + 5, 40, 40);
                NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",[profile_nameArr objectAtIndex:selectedindex]];
                NSURL *imageURL = [NSURL URLWithString:imagestring];
                NSString *key = [imagestring MD5Hash];
                NSData *data = [FTWCache objectForKey:key];
                if (data) {
                    UIImage *image = [UIImage imageWithData:data];
                    [mybutton1 setImage:image forState:UIControlStateNormal];
                } else {
                    //		imageView.image = [UIImage imageNamed:@"img_def"];
                    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                    dispatch_async(queue1, ^{
                        NSData *data = [NSData dataWithContentsOfURL:imageURL];
                        [FTWCache setObject:data forKey:key];
                        UIImage *image = [UIImage imageWithData:data];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [mybutton1 setImage:image forState:UIControlStateNormal];
                            
                        });
                    });
                }
                
                [mybutton1 addTarget:self action:@selector(addSpouse:) forControlEvents:UIControlEventTouchUpInside];
                [self.innerview addSubview:mybutton1];
                
                UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(mybutton1.frame.origin.x, mybutton1.frame.origin.y + 40, 40, 12)];
                lable1.backgroundColor = [UIColor clearColor];
                lable1.text = [NSString stringWithFormat:@"%@",[NameOfArr objectAtIndex:selectedindex]];
                lable1.font = [UIFont systemFontOfSize:12.0];
                lable1.textAlignment = UITextAlignmentCenter;
                lable1.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
                [self.innerview addSubview:lable1];
                //********** for button mybutton1 ***************
                
                mypoint1_leftSide = CGPointMake(mybutton1.frame.origin.x - 20 + (mybutton1.frame.size.width / 2), mybutton1.frame.origin.y  + (mybutton1.frame.size.height / 2));
            }
            CGPoint mypoint_bottomSide = CGPointMake(mybutton.frame.origin.x  + (mybutton.frame.size.width / 2), mybutton.frame.origin.y + 25 + (mybutton.frame.size.height / 2));
            
            CGPoint mypoint_rightSide = CGPointMake(mybutton.frame.origin.x + 25 + (mybutton.frame.size.width / 2), mybutton.frame.origin.y  + (mybutton.frame.size.height / 2));
            
//            NSLog(@"mypoint_rightSide x = %f",mypoint_rightSide.x);
//            NSLog(@"mypoint1_leftSide x = %f",mypoint1_leftSide.x);
            
            
            //*********** Draw Line B/W Husband and wife  ****************
            [self LineDraw:mypoint_rightSide :mypoint1_leftSide];
            CGPoint centerpoint = {mypoint1_leftSide.x - mypoint_rightSide.x,mypoint1_leftSide.y - mypoint_rightSide.y};
//            NSLog(@"centerpoint X = %f",centerpoint.x);
//            NSLog(@"centerpoint Y = %f",centerpoint.y);
            CGPoint newpiont = {mypoint_rightSide.x + centerpoint.x/2,mypoint_rightSide.y + 0};
//            NSLog(@"newpiont X = %f",newpiont.x);
//            NSLog(@"newpiont Y = %f",newpiont.y);
            
            CGPoint mynewpoint = {newpiont.x,newpiont.y+40};

            [self LineDraw:newpiont :mynewpoint];
//            NSLog(@"mypoint_bottomSide _Parent_Bottom Second = %2.f - %2.f",mypoint_bottomSide.x,mypoint_bottomSide.y);
            
            _Parent_Bottom = mypoint_bottomSide;
            if (FlagCallOne == NO)
            {
                FlagCallOne = YES;
                _First_Parent_Bottom = mypoint_bottomSide;
                
            }
            if (ParentsettingCounter == 0)
            {
                _Upside_store = _User_Upside;
                ParentsettingCounter++;
                CGPoint upsideuser = {_Upside_store.x,_Upside_store.y - 15};
                //            [self LineDraw:_User_Upside :_Parent_Bottom];
                [self LineDraw:_Upside_store :upsideuser ];
                [self LineDraw:upsideuser :mynewpoint];

            }
            else
            {
                CGPoint upsideuser = {_Upside_store.x,_Upside_store.y - 20};
                //            [self LineDraw:_User_Upside :_Parent_Bottom];
                [self LineDraw:_Upside_store :upsideuser ];
                [self LineDraw:upsideuser :mynewpoint];
            }
            
            _Upside_store = CGPointMake(mybutton.frame.origin.x  + (mybutton.frame.size.width / 2), mybutton.frame.origin.y - 25 + (mybutton.frame.size.height / 2));
        }
        
    }
    
}

-(void)DrawChild:(NSString *)name : (NSString *)setId : (NSString *)Profilename
{
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        numberofsibbling ++ ;
        if(numberofsibbling % 2 == 0)
        {
            
            
            UIButton * mybutton = [UIButton buttonWithType:UIButtonTypeCustom];
            //[mybutton setTitle:name forState:UIControlStateNormal];
            mybutton.layer.borderColor = [UIColor colorWithRed:92/255.0 green:88/255.0 blue:87/255.0 alpha:1.0].CGColor;
            
            NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",Profilename];
            NSURL *imageURL = [NSURL URLWithString:imagestring];
            NSString *key = [imagestring MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                [mybutton setImage:image forState:UIControlStateNormal];
            } else {
                //		imageView.image = [UIImage imageNamed:@"img_def"];
                dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue1, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [mybutton setImage:image forState:UIControlStateNormal];
                        
                    });
                });
            }
            mybutton.frame = CGRectMake(originx + 130 *numberofsibbling/2 ,originy , 70, 70);
            [mybutton setTag:[setId integerValue]];
            mybutton.layer.cornerRadius = 35.0f;
            mybutton.clipsToBounds = YES;
            mybutton.titleLabel.font = [UIFont systemFontOfSize:18.0];
            [self.innerview addSubview:mybutton];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(mybutton.frame.origin.x, mybutton.frame.origin.y + 70, 70, 15)];
            lable.backgroundColor = [UIColor clearColor];
            lable.text = [NSString stringWithFormat:@"%@",name];
            lable.font = [UIFont systemFontOfSize:14.0];
            lable.textAlignment = UITextAlignmentCenter;
            lable.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
            [self.innerview addSubview:lable];
            [mybutton addTarget:self action:@selector(Callthis:) forControlEvents:UIControlEventTouchUpInside];
            
            
            CGPoint mypoint_upSide = CGPointMake(mybutton.frame.origin.x  + (mybutton.frame.size.width / 2), mybutton.frame.origin.y - 35 + (mybutton.frame.size.height / 2));
            
//            NSLog(@"mypoint_bottomSide is Done that = %2.f - %2.f",mypoint_upSide.x,mypoint_upSide.y);
            _Child_Up = mypoint_upSide;
            CGPoint childlineup = {_Child_Up.x,_Child_Up.y - 20};
            [self LineDraw:_Child_Up :childlineup];
            _Child_Up_right = childlineup;
//            [self LineDraw:_User_Bottomside :_Child_Up];
        }
        else
        {
            
            UIButton * mybutton = [UIButton buttonWithType:UIButtonTypeCustom];
            //[mybutton setTitle:name forState:UIControlStateNormal];
            mybutton.layer.borderColor = [UIColor colorWithRed:92/255.0 green:88/255.0 blue:87/255.0 alpha:1.0].CGColor;
            NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",Profilename];
            NSURL *imageURL = [NSURL URLWithString:imagestring];
            NSString *key = [imagestring MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                [mybutton setImage:image forState:UIControlStateNormal];
            } else {
                //		imageView.image = [UIImage imageNamed:@"img_def"];
                dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue1, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [mybutton setImage:image forState:UIControlStateNormal];
                        
                    });
                });
            }
            [mybutton setTag:[setId integerValue]];
            mybutton.titleLabel.font = [UIFont systemFontOfSize:18.0];
            mybutton.frame = CGRectMake(originx - 130 *(numberofsibbling-1)/2 ,originy , 70, 70);
            mybutton.layer.cornerRadius = 35.0f;
            mybutton.clipsToBounds = YES;
            [self.innerview addSubview:mybutton];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(mybutton.frame.origin.x, mybutton.frame.origin.y + 70, 70, 15)];
            lable.backgroundColor = [UIColor clearColor];
            lable.text = [NSString stringWithFormat:@"%@",name];
            lable.font = [UIFont systemFontOfSize:15.0];
            lable.textAlignment = UITextAlignmentCenter;
            lable.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
            [self.innerview addSubview:lable];
            [mybutton addTarget:self action:@selector(Callthis:) forControlEvents:UIControlEventTouchUpInside];
            
            
            CGPoint mypoint_upSide = CGPointMake(mybutton.frame.origin.x  + (mybutton.frame.size.width / 2), mybutton.frame.origin.y - 35 + (mybutton.frame.size.height / 2));
            
//            NSLog(@"mypoint_upSide is Done that = %2.f - %2.f",mypoint_upSide.x,mypoint_upSide.y);
            _Child_Up = mypoint_upSide;
            if(numberofsibbling == 1)
            {
                //                if (ChildTotal == 2)
                //                {
                CGPoint temppoint = {_User_Wife_Center.x,_User_Wife_Center.y+65};
                [self LineDraw:_User_Wife_Center :temppoint];
                CGPoint childlineup = {_Child_Up.x,_Child_Up.y - 20};
                [self LineDraw:_Child_Up :childlineup];
                _Child_Up_left = childlineup;
                [self LineDraw: childlineup:temppoint];
                //                }
                
            }
            else
            {
                CGPoint childlineup = {_Child_Up.x,_Child_Up.y - 20};
                [self LineDraw:_Child_Up :childlineup];
                _Child_Up_left = childlineup;
            }

            
        }
    }
    else
    {
        numberofsibbling ++ ;
        
        NSLog(@"numberofsibbling == %d",numberofsibbling);
        
//        NSLog(@"Data Give me response = %@",[NSData dataWithContentsOfFile:[NewAdddata PathOfBGImages:Profilename]]);
        if(numberofsibbling % 2 == 0)
        {
            UIButton * mybutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            //[mybutton setTitle:name forState:UIControlStateNormal];
            mybutton.layer.borderColor = [UIColor colorWithRed:92/255.0 green:88/255.0 blue:87/255.0 alpha:1.0].CGColor;
            mybutton.layer.borderWidth = 2.0;
            mybutton.frame = CGRectMake(originx + 70 *numberofsibbling/2 ,originy , 40, 40);
            mybutton.clipsToBounds = YES;
            mybutton.layer.cornerRadius = 20.0f;
            [mybutton setTag:[setId integerValue]];
            NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",Profilename];
            NSURL *imageURL = [NSURL URLWithString:imagestring];
            NSString *key = [imagestring MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                [mybutton setImage:image forState:UIControlStateNormal];
            } else {
                //		imageView.image = [UIImage imageNamed:@"img_def"];
                dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue1, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [mybutton setImage:image forState:UIControlStateNormal];
                        
                    });
                });
            }
            
            //[mybutton setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:[NewAdddata PathOfBGImages:Profilename]]] forState:UIControlStateNormal];
//            [mybutton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0)];
//            [mybutton setTitleEdgeInsets:UIEdgeInsetsMake(40.0,-10.0, 0.0, 0.0)];
//            mybutton.titleLabel.font = [UIFont systemFontOfSize:12.0];
//            mybutton.titleLabel.backgroundColor = [UIColor whiteColor];
            
            
            [mybutton addTarget:self action:@selector(Callthis:) forControlEvents:UIControlEventTouchUpInside];
            [self.innerview addSubview:mybutton];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(mybutton.frame.origin.x, mybutton.frame.origin.y + 40, 40, 10)];
            lable.backgroundColor = [UIColor clearColor];
            lable.text = [NSString stringWithFormat:@"%@",name];
            lable.font = [UIFont systemFontOfSize:12.0];
            lable.textAlignment = UITextAlignmentCenter;
            lable.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
            [self.innerview addSubview:lable];
            CGPoint mypoint_upSide = CGPointMake(mybutton.frame.origin.x  + (mybutton.frame.size.width / 2), mybutton.frame.origin.y - 20 + (mybutton.frame.size.height / 2));
            
//            NSLog(@"mypoint_bottomSide is Done that = %2.f - %2.f",mypoint_upSide.x,mypoint_upSide.y);
            _Child_Up = mypoint_upSide;
            CGPoint childlineup = {_Child_Up.x,_Child_Up.y - 15};
            [self LineDraw:_Child_Up :childlineup];
            _Child_Up_right = childlineup;
//            [self LineDraw:_User_Bottomside :_Child_Up];
        }
        else
        {
                        
            UIButton * mybutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            mybutton.layer.borderColor = [UIColor colorWithRed:92/255.0 green:88/255.0 blue:87/255.0 alpha:1.0].CGColor;
            mybutton.layer.borderWidth = 2.0;
           // [mybutton setTitle:name forState:UIControlStateNormal];
            [mybutton setTag:[setId integerValue]];
          //  mybutton.titleLabel.font = [UIFont systemFontOfSize:12.0];
            mybutton.frame = CGRectMake(originx - 80 *(numberofsibbling-1)/2 ,originy , 40, 40);
            mybutton.clipsToBounds = YES;
            mybutton.layer.cornerRadius = 20.0f;
            [mybutton setContentMode:UIViewContentModeScaleAspectFill];
            [mybutton.layer setMasksToBounds:YES];
            
            NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",Profilename];
            NSURL *imageURL = [NSURL URLWithString:imagestring];
            NSString *key = [imagestring MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                [mybutton setImage:image forState:UIControlStateNormal];
            } else {
                //		imageView.image = [UIImage imageNamed:@"img_def"];
                dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue1, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [mybutton setImage:image forState:UIControlStateNormal];
                        
                    });
                });
            }
            //[mybutton setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:[NewAdddata PathOfBGImages:Profilename]]] forState:UIControlStateNormal];
//            [mybutton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0)];
//            [mybutton setTitleEdgeInsets:UIEdgeInsetsMake(40.0,-10.0, 0.0, 0.0)];
           // mybutton.titleLabel.backgroundColor = [UIColor whiteColor];
            
            
            [mybutton addTarget:self action:@selector(Callthis:) forControlEvents:UIControlEventTouchUpInside];
            [self.innerview addSubview:mybutton];
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(mybutton.frame.origin.x, mybutton.frame.origin.y + 40, 40, 10)];
            lable.backgroundColor = [UIColor clearColor];
            lable.text = [NSString stringWithFormat:@"%@",name];
            lable.font = [UIFont systemFontOfSize:12.0];
            lable.textAlignment = UITextAlignmentCenter;
            lable.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
            [self.innerview addSubview:lable];
            CGPoint mypoint_upSide = CGPointMake(mybutton.frame.origin.x  + (mybutton.frame.size.width / 2), mybutton.frame.origin.y - 20 + (mybutton.frame.size.height / 2));
            
//            NSLog(@"mypoint_upSide is Done that = %2.f - %2.f",mypoint_upSide.x,mypoint_upSide.y);
            _Child_Up = mypoint_upSide;
            if(numberofsibbling == 1)
            {
//                if (ChildTotal == 2)
//                {
                    CGPoint temppoint = {_User_Wife_Center.x,_User_Wife_Center.y+45};
                    [self LineDraw:_User_Wife_Center :temppoint];
                    CGPoint childlineup = {_Child_Up.x,_Child_Up.y - 15};
                    [self LineDraw:_Child_Up :childlineup];
                    _Child_Up_left = childlineup;
                    [self LineDraw: childlineup:temppoint];
//                }
                
            }
            else
            {
                CGPoint childlineup = {_Child_Up.x,_Child_Up.y - 15};
                [self LineDraw:_Child_Up :childlineup];
                _Child_Up_left = childlineup;
            }
            
            
            //[self LineDraw:_User_Bottomside :_Child_Up];
            
        }

    }
}

-(void)drawsibling :(NSString*)name :(NSString *)setId :(NSString *)Profilename
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        tempcount = 1 + tempcount;
        if (numberofsibbling == 0)
        {
            originx = originx + (130 * tempcount);
            
            UIButton * mybutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [mybutton setTitle:name forState:UIControlStateNormal];
            mybutton.layer.borderColor = [UIColor colorWithRed:92/255.0 green:88/255.0 blue:87/255.0 alpha:1.0].CGColor;
            NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",Profilename];
            NSURL *imageURL = [NSURL URLWithString:imagestring];
            NSString *key = [imagestring MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                [mybutton setImage:image forState:UIControlStateNormal];
            } else {
                //		imageView.image = [UIImage imageNamed:@"img_def"];
                dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue1, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [mybutton setImage:image forState:UIControlStateNormal];
                        
                    });
                });
            }
            [mybutton setTag:[setId integerValue]];
            mybutton.frame = CGRectMake(originx  ,originy , 80, 80);
            mybutton.layer.cornerRadius = 40.0f;
            mybutton.clipsToBounds = YES;
            mybutton.layer.borderWidth = 2.0f;
            [self.innerview addSubview:mybutton];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(mybutton.frame.origin.x, mybutton.frame.origin.y + 80, 80, 15)];
            lable.backgroundColor = [UIColor clearColor];
            lable.text = [NSString stringWithFormat:@"%@",name];
            lable.font = [UIFont systemFontOfSize:14.0];
            lable.textAlignment = UITextAlignmentCenter;
            lable.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
            [self.innerview addSubview:lable];
            [mybutton addTarget:self action:@selector(Callthis:) forControlEvents:UIControlEventTouchUpInside];
            mybutton.titleLabel.font = [UIFont systemFontOfSize:18.0];
            
            numberofsibbling = 1;
            
            CGPoint mypoint_upSide = CGPointMake(mybutton.frame.origin.x  + (mybutton.frame.size.width / 2), mybutton.frame.origin.y - 40 + (mybutton.frame.size.height / 2));
            
//            NSLog(@"mypoint_bottomSide is Done that = %2.f - %2.f",mypoint_upSide.x,mypoint_upSide.y);
//            _Sibling_Up = mypoint_upSide;
//            [self LineDraw:_Parent_Bottom :_Sibling_Up];
            if (tempcount == 2)
            {
                if (SiblingTotal == 2)
                {
                    _Sibling_Up = mypoint_upSide;
                    CGPoint siblingupside = {_Sibling_Up.x,_Sibling_Up.y - 35};
                    _Upside_Sibling_store_left = siblingupside;
                    CGPoint tempupuser = {_User_Upside.x,_User_Upside.y-15};
                    [self LineDraw:siblingupside :_Sibling_Up];
                    [self LineDraw:tempupuser :siblingupside];
                }
                else
                {
                    _Sibling_Up = mypoint_upSide;
                    CGPoint siblingupside = {_Sibling_Up.x,_Sibling_Up.y - 35};
                    _Upside_Sibling_store_left = siblingupside;
                    [self LineDraw:siblingupside :_Sibling_Up];
                }
            }
            else
            {
                _Sibling_Up = mypoint_upSide;
                CGPoint siblingupside = {_Sibling_Up.x,_Sibling_Up.y - 35};
                _Upside_Sibling_store_left = siblingupside;
                [self LineDraw:siblingupside :_Sibling_Up];
            }

            
        }
        else
        {
            originx = originx - (130 * tempcount);
            UIButton * mybutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [mybutton setTitle:name forState:UIControlStateNormal];
            mybutton.layer.borderColor = [UIColor colorWithRed:92/255.0 green:88/255.0 blue:87/255.0 alpha:1.0].CGColor;
            NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",Profilename];
            NSURL *imageURL = [NSURL URLWithString:imagestring];
            NSString *key = [imagestring MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                [mybutton setImage:image forState:UIControlStateNormal];
            } else {
                //		imageView.image = [UIImage imageNamed:@"img_def"];
                dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue1, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [mybutton setImage:image forState:UIControlStateNormal];
                        
                    });
                });
            }
            mybutton.titleLabel.font = [UIFont systemFontOfSize:18.0];
            mybutton.layer.cornerRadius = 40.0f;
            mybutton.clipsToBounds = YES;
            [mybutton setTag:[setId integerValue]];
            mybutton.frame = CGRectMake(originx  ,originy, 80, 80);
            [self.innerview addSubview:mybutton];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(mybutton.frame.origin.x,mybutton.frame.origin.y + 80, 80, 15)];
            lable.backgroundColor = [UIColor clearColor];
            lable.text = [NSString stringWithFormat:@"%@",name];
            lable.font = [UIFont systemFontOfSize:14.0];
            lable.textAlignment = UITextAlignmentCenter;
            lable.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
            [self.innerview addSubview:lable];
            [mybutton addTarget:self action:@selector(Callthis:) forControlEvents:UIControlEventTouchUpInside];
            
            numberofsibbling = 0;
            
            
            CGPoint mypoint_upSide = CGPointMake(mybutton.frame.origin.x  + (mybutton.frame.size.width / 2), mybutton.frame.origin.y - 40 + (mybutton.frame.size.height / 2));
            
//            NSLog(@"mypoint_bottomSide is Done that = %2.f - %2.f",mypoint_upSide.x,mypoint_upSide.y);
            _Sibling_Up = mypoint_upSide;
            _Sibling_Up = mypoint_upSide;
            CGPoint siblingupside = {_Sibling_Up.x,_Sibling_Up.y - 35};
            _Upside_Sibling_store_right = siblingupside;
            [self LineDraw:siblingupside :_Sibling_Up];
            
        }
        siblingx = originx;
    }
    else
    {
        
        tempcount = 1 + tempcount;
        NSLog(@"tempcount --->  %d",tempcount);
//        NSLog(@"Origin x == %f",originx);
        if (numberofsibbling == 0)
        {
            originx = originx + (70 * tempcount);
            
            UIButton * mybutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            //[mybutton setTitle:name forState:UIControlStateNormal];
            mybutton.layer.borderColor = [UIColor colorWithRed:92/255.0 green:88/255.0 blue:87/255.0 alpha:1.0].CGColor;
            mybutton.layer.borderWidth = 2.0;
            //[mybutton setTitle:name forState:UIControlStateNormal];
            [mybutton setTag:[setId integerValue]];
            mybutton.frame = CGRectMake(originx  ,originy , 50, 50);
            mybutton.clipsToBounds = YES;
            mybutton.layer.cornerRadius = 25.0f;
            NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",Profilename];
            NSURL *imageURL = [NSURL URLWithString:imagestring];
            NSString *key = [imagestring MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                [mybutton setImage:image forState:UIControlStateNormal];
            } else {
                //		imageView.image = [UIImage imageNamed:@"img_def"];
                dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue1, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [mybutton setImage:image forState:UIControlStateNormal];
                        
                    });
                });
            }
//            [mybutton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0)];
//            [mybutton setTitleEdgeInsets:UIEdgeInsetsMake(40.0,-10.0, 0.0, 0.0)];
            
            [mybutton addTarget:self action:@selector(Callthis:) forControlEvents:UIControlEventTouchUpInside];
//            mybutton.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [self.innerview addSubview:mybutton];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(mybutton.frame.origin.x, mybutton.frame.origin.y + 50, 50, 12)];
            lable.backgroundColor = [UIColor clearColor];
            lable.text = [NSString stringWithFormat:@"%@",name];
            lable.font = [UIFont systemFontOfSize:12.0];
            lable.textAlignment = UITextAlignmentCenter;
            lable.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
            [self.innerview addSubview:lable];
            numberofsibbling = 1;
            
            CGPoint mypoint_upSide = CGPointMake(mybutton.frame.origin.x  + (mybutton.frame.size.width / 2), mybutton.frame.origin.y - 25 + (mybutton.frame.size.height / 2));
            
//            NSLog(@"mypoint_bottomSide is Done that = %2.f - %2.f",mypoint_upSide.x,mypoint_upSide.y);
            
            NSLog(@"temp count == %d",tempcount);
            NSLog(@"SiblingTotal == %d",SiblingTotal);
            if (tempcount == 2)
            {
                if (SiblingTotal == 2)
                {
                    _Sibling_Up = mypoint_upSide;
                    CGPoint siblingupside = {_Sibling_Up.x,_Sibling_Up.y - 20};
                    _Upside_Sibling_store_left = siblingupside;
                    CGPoint tempupuser = {_User_Upside.x,_User_Upside.y-15};
                    [self LineDraw:siblingupside :_Sibling_Up];
                    [self LineDraw:tempupuser :siblingupside];
                }
                else
                {
                    _Sibling_Up = mypoint_upSide;
                    CGPoint siblingupside = {_Sibling_Up.x,_Sibling_Up.y - 20};
                    _Upside_Sibling_store_left = siblingupside;
                    [self LineDraw:siblingupside :_Sibling_Up];
                }
            }
            else
            {
                _Sibling_Up = mypoint_upSide;
                CGPoint siblingupside = {_Sibling_Up.x,_Sibling_Up.y - 20};
                _Upside_Sibling_store_left = siblingupside;
                [self LineDraw:siblingupside :_Sibling_Up];
            }
//            [self LineDraw:_First_Parent_Bottom :_Sibling_Up];
        }
        else
        {
            originx = originx - (70 * tempcount);
            UIButton * mybutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            mybutton.layer.borderColor = [UIColor colorWithRed:92/255.0 green:88/255.0 blue:87/255.0 alpha:1.0].CGColor;
            mybutton.layer.borderWidth = 2.0;
           // [mybutton setTitle:name forState:UIControlStateNormal];
//            mybutton.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [mybutton setTag:[setId integerValue]];
            mybutton.frame = CGRectMake(originx  ,originy, 50, 50);
            mybutton.clipsToBounds = YES;
            mybutton.layer.cornerRadius = 25.0f;
            NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",Profilename];
            NSURL *imageURL = [NSURL URLWithString:imagestring];
            NSString *key = [imagestring MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                [mybutton setImage:image forState:UIControlStateNormal];
            } else {
                //		imageView.image = [UIImage imageNamed:@"img_def"];
                dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue1, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [mybutton setImage:image forState:UIControlStateNormal];
                        
                    });
                });
            }
//           [mybutton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0)];
//           [mybutton setTitleEdgeInsets:UIEdgeInsetsMake(40.0,-10.0, 0.0, 0.0)];
            [mybutton addTarget:self action:@selector(Callthis:) forControlEvents:UIControlEventTouchUpInside];
            [self.innerview addSubview:mybutton];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(mybutton.frame.origin.x, mybutton.frame.origin.y + 50, 50, 12)];
            lable.backgroundColor = [UIColor clearColor];
            lable.text = [NSString stringWithFormat:@"%@",name];
            lable.font = [UIFont systemFontOfSize:12.0];
            lable.textAlignment = UITextAlignmentCenter;
            lable.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
            [self.innerview addSubview:lable];
            numberofsibbling = 0;
            
            
            CGPoint mypoint_upSide = CGPointMake(mybutton.frame.origin.x  + (mybutton.frame.size.width / 2), mybutton.frame.origin.y - 25 + (mybutton.frame.size.height / 2));
            
//            NSLog(@"mypoint_bottomSide is Done that = %2.f - %2.f",mypoint_upSide.x,mypoint_upSide.y);
            _Sibling_Up = mypoint_upSide;
            _Sibling_Up = mypoint_upSide;
            CGPoint siblingupside = {_Sibling_Up.x,_Sibling_Up.y - 20};
            _Upside_Sibling_store_right = siblingupside;
            [self LineDraw:siblingupside :_Sibling_Up];
          //  [self LineDraw:tempupuser :_Sibling_Up];
        }
        siblingx = originx;
//        NSLog(@"Origin x == %f",originx);
    }
}

-(void)initaluserPosition : (NSString *)Profilename :(NSString *)profileids :(NSString *)profile
{
    NSLog(@"Profilename===%@",Profilename);
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        UIButton * mybutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        mybutton.layer.borderColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0].CGColor;
        mybutton.layer.borderWidth = 3.0;
        Sample *s = [mynewarray objectAtIndex:0];
        ;
        [mybutton setTitle:Profilename forState:UIControlStateNormal];
        NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",profile];
        NSURL *imageURL = [NSURL URLWithString:imagestring];
        NSString *key = [imagestring MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            [mybutton setImage:image forState:UIControlStateNormal];
        } else {
            //		imageView.image = [UIImage imageNamed:@"img_def"];
            dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue1, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [mybutton setImage:image forState:UIControlStateNormal];
                    
                });
            });
        }

        [mybutton setTag:[profileids integerValue]];
        mybutton.clipsToBounds = YES;
        mybutton.layer.cornerRadius = 45.0f;
        mybutton.frame = CGRectMake((self.innerview.frame.size.width/2)-25, (self.innerview.frame.size.height/2)+75, 90, 90);
        [self.innerview addSubview:mybutton];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(mybutton.frame.origin.x, mybutton.frame.origin.y + 90, 90, 14)];
        lable.backgroundColor = [UIColor clearColor];
        lable.text = [NSString stringWithFormat:@"%@",Profilename];
        lable.font = [UIFont systemFontOfSize:15.0];
        lable.textAlignment = UITextAlignmentCenter;
        lable.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
        [self.innerview addSubview:lable];
        [mybutton addTarget:self action:@selector(Callthis:) forControlEvents:UIControlEventTouchUpInside];
       
        
        CGPoint mypoint1_leftSide;
        
        NSLog(@"s.spose value ======= %@",s.spouse);
        storeUserSpose = [storeUserSpose stringByReplacingOccurrencesOfString:@"," withString:@""];
        if (storeUserSpose == nil || [storeUserSpose isEqualToString:@"<null>"] || storeUserSpose.length == 0)
        {
            UIButton * mybutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
            mybutton1.layer.borderColor = [UIColor colorWithRed:255/255.0 green:105/255.0 blue:180/255.0 alpha:1.0].CGColor;
            mybutton1.layer.borderWidth = 2.0f;
            [mybutton1 setTitle:@"" forState:UIControlStateNormal];
            //            [mybutton setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:[NewAdddata PathOfBGImages:s1.profile_name]]] forState:UIControlStateNormal];
            [mybutton1 setTag:[profileids intValue]];
            mybutton1.clipsToBounds = YES;
            mybutton1.layer.cornerRadius = 35.0f;
            mybutton1.frame = CGRectMake((self.innerview.frame.size.width/2) +85, (self.innerview.frame.size.height/2)+85, 70, 70);
            UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(mybutton1.frame.origin.x, mybutton1.frame.origin.y + 70, 70, 15)];
            lable1.backgroundColor = [UIColor clearColor];
            lable1.text = [NSString stringWithFormat:@"%@",@""];
            lable1.font = [UIFont systemFontOfSize:15.0];
            lable1.textAlignment = UITextAlignmentCenter;
            lable1.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
            [self.innerview addSubview:lable1];
            [mybutton1 addTarget:self action:@selector(addSpouse:) forControlEvents:UIControlEventTouchUpInside];
            [self.innerview addSubview:mybutton1];
            //********** for button mybutton1 ***************
            mypoint1_leftSide = CGPointMake(mybutton1.frame.origin.x - 35 + (mybutton1.frame.size.width / 2), mybutton1.frame.origin.y + (mybutton1.frame.size.height / 2));
        }
        else
        {
//            NSArray * wifedata = [[NSArray alloc] initWithArray:[self GetUserData:s.spouse]];
//            Sample * s1 =[wifedata objectAtIndex:0];
            int selectedIndex = [IdsArr indexOfObject:storeUserSpose];
            UIButton * mybutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
            mybutton1.layer.borderColor = [UIColor colorWithRed:255/255.0 green:105/255.0 blue:180/255.0 alpha:1.0].CGColor;
            mybutton1.layer.borderWidth = 2.0f;
            mybutton1.layer.cornerRadius = 35.0f;
            mybutton1.clipsToBounds = YES;
//            [mybutton1 setTitle:s1.name forState:UIControlStateNormal];
            NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",[profile_nameArr objectAtIndex:selectedIndex]];
            NSURL *imageURL = [NSURL URLWithString:imagestring];
            NSString *key = [imagestring MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                [mybutton1 setImage:image forState:UIControlStateNormal];
            } else {
                //		imageView.image = [UIImage imageNamed:@"img_def"];
                dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue1, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [mybutton1 setImage:image forState:UIControlStateNormal];
                        
                    });
                });
            }

            [mybutton1 setTag:[profileids intValue]];
            mybutton1.frame = CGRectMake((self.innerview.frame.size.width/2) +  85, (self.innerview.frame.size.height/2)+85, 70, 70);
            UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, 80, 15)];
            lable1.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
            lable1.text = [NSString stringWithFormat:@"%@",[NameOfArr objectAtIndex:selectedIndex]];
            lable1.font = [UIFont systemFontOfSize:15.0];
            lable1.textAlignment = UITextAlignmentCenter;
            lable1.textColor = [UIColor clearColor];
            [self.innerview addSubview:lable1];
            [mybutton1 addTarget:self action:@selector(addSpouse:) forControlEvents:UIControlEventTouchUpInside];
            [self.innerview addSubview:mybutton1];
            //********** for button mybutton1 ***************
            mypoint1_leftSide = CGPointMake(mybutton1.frame.origin.x - 5 + (mybutton1.frame.size.width / 2), mybutton1.frame.origin.y + (mybutton1.frame.size.height / 2));
        }
        
        
        
        originx = (self.innerview.frame.size.width/2) - 25;
        originy = (self.innerview.frame.size.height/2) + 15;
        //        NSLog(@"origin of x and y is %f And %f",originx,originy);
        
        
        CGPoint mypoint_rightSide = CGPointMake(mybutton.frame.origin.x + 45 + (mybutton.frame.size.width / 2), mybutton.frame.origin.y + (mybutton.frame.size.height / 2));
        
        //*********** Draw Line B/W Husband and wife  ****************
        
        [self LineDraw:mypoint_rightSide :mypoint1_leftSide];

        CGPoint centerpoint = {mypoint1_leftSide.x - mypoint_rightSide.x,mypoint1_leftSide.y - mypoint_rightSide.y};
        //        NSLog(@"centerpoint X = %f",centerpoint.x);
        //        NSLog(@"centerpoint Y = %f",centerpoint.y);
        CGPoint newpiont = {mypoint_rightSide.x + centerpoint.x/2,mypoint_rightSide.y + 0};
        _User_Wife_Center = newpiont;
        
        //        NSLog(@"mypoint_rightSide is Done that = %2.f - %2.f",mypoint_rightSide.x,mypoint_rightSide.y);
        
        CGPoint mypoint_upside = CGPointMake(mybutton.frame.origin.x  + (mybutton.frame.size.width / 2), mybutton.frame.origin.y - 45 + (mybutton.frame.size.height / 2));
        
        //        NSLog(@"mypoint_upside is Done that = %2.f - %2.f",mypoint_upside.x,mypoint_upside.y);
        
        CGPoint mypoint_downside = CGPointMake(mybutton.frame.origin.x  + (mybutton.frame.size.width / 2), mybutton.frame.origin.y + 40 + (mybutton.frame.size.height / 2));
        
        //        NSLog(@"mypoint_upside is Done that = %2.f - %2.f",mypoint_downside.x,mypoint_downside.y);
        
        _User_Upside = mypoint_upside;
        _User_Bottomside = mypoint_downside;
        
        
        
        PARENT = s.parent;
        CHILD = s.child;
        SYBILING = s.sibling;
        IDS = s.ids;
        NAME = s.name;
        
        childx = originx;
        childy = originy;
        
        papax = originx;
        papay = originy ;
        
        siblingx = originx;
        siblingy = originy + 60;
    }
    else
    {
        UIButton * mybutton = [UIButton buttonWithType:UIButtonTypeCustom];
        mybutton.layer.borderColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0].CGColor;
        mybutton.layer.borderWidth = 3.0f;
        Sample *s = [mynewarray objectAtIndex:0];
        
       // [mybutton setTitle:storeUsername forState:UIControlStateNormal];
        NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",profile];
        NSURL *imageURL = [NSURL URLWithString:imagestring];
        NSString *key = [imagestring MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
             [mybutton setImage:image forState:UIControlStateNormal];
        } else {
            //		imageView.image = [UIImage imageNamed:@"img_def"];
            dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue1, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [mybutton setImage:image forState:UIControlStateNormal];

                });
            });
        }
        //[mybutton setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:[NewAdddata PathOfBGImages:Profilename]]] forState:UIControlStateNormal];
        [mybutton setTag:[profileids intValue]];
        
//        [mybutton addSubview:lable];
        [mybutton addTarget:self action:@selector(Callthis:) forControlEvents:UIControlEventTouchUpInside];
        mybutton.frame = CGRectMake((self.innerview.frame.size.width/2)-25, (self.innerview.frame.size.height/2)+75, 60, 60);
        mybutton.clipsToBounds = YES;
        mybutton.layer.cornerRadius = 30.0f;
        
        //[mybutton setContentMode:UIViewContentModeScaleAspectFill];

        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(mybutton.frame.origin.x, mybutton.frame.origin.y+60, 60, 12)];
        lable.backgroundColor = [UIColor clearColor];
        lable.text = [NSString stringWithFormat:@"%@",Profilename];
        lable.font = [UIFont systemFontOfSize:12.0];
        lable.textAlignment = UITextAlignmentCenter;
        lable.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
//        lable.clipsToBounds = YES;
//        lable.layer.cornerRadius = 1.0f;
        [self.innerview addSubview:lable];
//        lable = (UILabel *)[self roundCornersOnView:lable onTopLeft:YES topRight:YES bottomLeft:YES bottomRight:YES radius:25.0];
//        [self setRoundedView:mybutton toDiameter:50];
        
        CGPoint mypoint1_leftSide;
        
        NSLog(@"s.spose value ======= %@",storeUserSpose);
        storeUserSpose = [storeUserSpose stringByReplacingOccurrencesOfString:@"," withString:@""];
        if (storeUserSpose == nil || [storeUserSpose isEqualToString:@"<null>"] || storeUserSpose.length == 0)
        {
            UIButton * mybutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
            mybutton1.layer.borderColor = [UIColor colorWithRed:255/255.0 green:105/255.0 blue:180/255.0 alpha:1.0].CGColor;
            mybutton1.layer.borderWidth = 2.0f;
            [mybutton1 setTitle:@"" forState:UIControlStateNormal];
            
            NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",profile];
            NSURL *imageURL = [NSURL URLWithString:imagestring];
            NSString *key = [imagestring MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                [mybutton setImage:image forState:UIControlStateNormal];
            } else {
                //		imageView.image = [UIImage imageNamed:@"img_def"];
                dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue1, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [mybutton setImage:image forState:UIControlStateNormal];
                        
                    });
                });
            }
            [mybutton1 setTag:[profileids intValue]];
            mybutton1.frame = CGRectMake((self.innerview.frame.size.width/2) + 45, (self.innerview.frame.size.height/2)+85, 40, 40);
            
            [mybutton1 addTarget:self action:@selector(addSpouse:) forControlEvents:UIControlEventTouchUpInside];
            mybutton1.clipsToBounds = YES;
            mybutton1.layer.cornerRadius = 20.0f;
            [self.innerview addSubview:mybutton1];
            UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(mybutton1.frame.origin.x, mybutton1.frame.origin.y + 40, 40, 12)];
            lable1.backgroundColor = [UIColor clearColor];
            lable1.text = [NSString stringWithFormat:@"%@",@""];
            lable1.font = [UIFont systemFontOfSize:12.0];
            lable1.textAlignment = UITextAlignmentCenter;
            lable1.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
            [self.innerview addSubview:lable1];
            //********** for button mybutton1 ***************
             mypoint1_leftSide = CGPointMake(mybutton1.frame.origin.x - 20 + (mybutton1.frame.size.width / 2), mybutton1.frame.origin.y + (mybutton1.frame.size.height / 2));
        }
        else
        {
            NSLog(@"*********************************************");
            NSArray * wifedata = [[NSArray alloc] initWithArray:[self GetUserData:s.spouse]];
            NSLog(@"storeUserSpose == %@",storeUserSpose);
            NSLog(@"IdsArr == %@",IdsArr);
            int selectedIndex = [IdsArr indexOfObject:storeUserSpose];
            NSLog(@"selectedIndex == %d",selectedIndex);
//            Sample * s1 =[wifedata objectAtIndex:0];
            NSLog(@"selectedIndex == %d",selectedIndex);
             NSLog(@"Name is  ==== %@",NameOfArr);
            UIButton * mybutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
            mybutton1.layer.borderColor = [UIColor colorWithRed:255/255.0 green:105/255.0 blue:180/255.0 alpha:1.0].CGColor;
            mybutton1.layer.borderWidth = 2.0f;
            [mybutton1 setTitle:[NameOfArr objectAtIndex:selectedIndex] forState:UIControlStateNormal];
            NSString * imagestring = [[NSString alloc] initWithFormat:@"http://prajas.com/familytree/images/%@",[profile_nameArr objectAtIndex:selectedIndex]];
            NSURL *imageURL = [NSURL URLWithString:imagestring];
            NSString *key = [imagestring MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                [mybutton1 setImage:image forState:UIControlStateNormal];
            } else {
                //		imageView.image = [UIImage imageNamed:@"img_def"];
                dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue1, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [mybutton1 setImage:image forState:UIControlStateNormal];
                        
                    });
                });
            }

            [mybutton1 setTag:[profileids intValue]];
            mybutton1.frame = CGRectMake((self.innerview.frame.size.width/2) + 45, (self.innerview.frame.size.height/2)+85, 40, 40);
            
            [mybutton1 addTarget:self action:@selector(addSpouse:) forControlEvents:UIControlEventTouchUpInside];
            mybutton1.clipsToBounds = YES;
            mybutton1.layer.cornerRadius = 20.0f;
            [self.innerview addSubview:mybutton1];
            
            UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(mybutton1.frame.origin.x , mybutton1.frame.origin.y + 40, 40, 12)];
            lable1.backgroundColor = [UIColor clearColor];
            NSLog(@"Name is  ==== %@",NameOfArr);
            NSLog(@"Wife name is  == %@",[NameOfArr objectAtIndex:selectedIndex]);
            lable1.text = [NSString stringWithFormat:@"%@",[NameOfArr objectAtIndex:selectedIndex]];
            lable1.font = [UIFont systemFontOfSize:12.0];
            lable1.textAlignment = UITextAlignmentCenter;
            lable1.textColor = [UIColor colorWithRed:249/255.0 green:155/255.0 blue:28/255.0 alpha:1.0];
            [self.innerview addSubview:lable1];
            //********** for button mybutton1 ***************
             mypoint1_leftSide = CGPointMake(mybutton1.frame.origin.x - 20 + (mybutton1.frame.size.width / 2), mybutton1.frame.origin.y + (mybutton1.frame.size.height / 2));
        }
       
        
        originx = (self.innerview.frame.size.width/2) - 30;
        originy = (self.innerview.frame.size.height/2)+80;
//        NSLog(@"origin of x and y is %f And %f",originx,originy);
        
        
        CGPoint mypoint_rightSide = CGPointMake(mybutton.frame.origin.x + 30 + (mybutton.frame.size.width / 2), mybutton.frame.origin.y + (mybutton.frame.size.height / 2));
        
        
        
        //*********** Draw Line B/W Husband and wife  ****************
        
        [self LineDraw:mypoint_rightSide :mypoint1_leftSide];
        
        CGPoint centerpoint = {mypoint1_leftSide.x - mypoint_rightSide.x,mypoint1_leftSide.y - mypoint_rightSide.y};
//        NSLog(@"centerpoint X = %f",centerpoint.x);
//        NSLog(@"centerpoint Y = %f",centerpoint.y);
        CGPoint newpiont = {mypoint_rightSide.x + centerpoint.x/2,mypoint_rightSide.y + 0};
        _User_Wife_Center = newpiont;
        
//        NSLog(@"mypoint_rightSide is Done that = %2.f - %2.f",mypoint_rightSide.x,mypoint_rightSide.y);
        
        CGPoint mypoint_upside = CGPointMake(mybutton.frame.origin.x  + (mybutton.frame.size.width / 2), mybutton.frame.origin.y - 30 + (mybutton.frame.size.height / 2));
        
//        NSLog(@"mypoint_upside is Done that = %2.f - %2.f",mypoint_upside.x,mypoint_upside.y);
        
        CGPoint mypoint_downside = CGPointMake(mybutton.frame.origin.x  + (mybutton.frame.size.width / 2), mybutton.frame.origin.y + 30 + (mybutton.frame.size.height / 2));
        
//        NSLog(@"mypoint_upside is Done that = %2.f - %2.f",mypoint_downside.x,mypoint_downside.y);
        
        _User_Upside = mypoint_upside;
        _User_Bottomside = mypoint_downside;
        
        [self.innerview addSubview:mybutton];
        
        
        PARENT = s.parent;
        CHILD = s.child;
        SYBILING = s.sibling;
        IDS = s.ids;
        NAME = s.name;
        
        childx = originx;
        childy = originy;
        
        papax = originx;
        papay = originy ;
        
        siblingx = originx;
        siblingy = originy;
    }
    
    
}

-(UIView *)roundCornersOnView:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius {
    
    if (tl || tr || bl || br)
    {
        UIRectCorner corner; //holds the corner
        //Determine which corner(s) should be changed
        if (tl)
        {
            corner = UIRectCornerTopLeft;
        }
        if (tr)
        {
            UIRectCorner add = corner | UIRectCornerTopRight;
            corner = add;
        }
        if (bl)
        {
            UIRectCorner add = corner | UIRectCornerBottomLeft;
            corner = add;
        }
        if (br)
        {
            UIRectCorner add = corner | UIRectCornerBottomRight;
            corner = add;
        }
        
        UIView *roundedView = view;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = roundedView.bounds;
        maskLayer.path = maskPath.CGPath;
        roundedView.layer.mask = maskLayer;
        return roundedView;
    } else {
        return view;
    }
    
}
-(void)setRoundedView:(UIButton *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}


#pragma mark - Button Method

-(void)Callthis:(id)sender
{
    NSLog(@"call this");
    
    if(EDIT_OR_VIEW_BOOL==YES)
    {
        myname= [[NSString alloc] init];
        UIButton *mybuton = (id)sender;
        NSLog(@"My tag value == %d",mybuton.tag);
        
        //NSString * tagstore = [[NSString alloc] initWithFormat:@"%d",mybuton.tag];
        SelectedId = [[NSString alloc] initWithFormat:@"%d",mybuton.tag ];
        NSLog(@"SelectedId =%@ ",SelectedId);
        int indexs=[IdsArr indexOfObject:SelectedId];
        userdeviceToken=[[NSString alloc] initWithFormat:@"%@",[devicetokenArr objectAtIndex:indexs]];
        
        //myprofilename =[[NSString alloc] initWithFormat:@"%@",[self getdataProfilename:tagstore]];
        LOCK = [[numberArr objectAtIndex:indexs ] integerValue];
        
        //myname = mybuton.titleLabel.text;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            myaddfamily = [[AddFamilydataViewController alloc] initWithNibName:@"AddFamilydataViewController_Ipad" bundle:nil];
            [self.navigationController pushViewController:myaddfamily animated:YES];
        }
        else
        {
            if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
            {
                myaddfamily = [[AddFamilydataViewController alloc] initWithNibName:@"AddFamilydataViewController" bundle:nil];
                [self.navigationController pushViewController:myaddfamily animated:YES];
            }
            else
            {
                myaddfamily = [[AddFamilydataViewController alloc] initWithNibName:@"AddFamilydataViewController_Iphone4" bundle:nil];
                [self.navigationController pushViewController:myaddfamily animated:YES];
            }
        }
    }
    
   
}

-(void)addSpouse:(id)sender
{
    if(EDIT_OR_VIEW_BOOL==YES)
    {
        UIButton * defaultbutton = sender;
        NSLog(@"defaultbutton tag is = %@",defaultbutton.titleLabel.text);
        
        if (defaultbutton.titleLabel.text.length == 0 || [defaultbutton.titleLabel.text isEqualToString:@"<null>"] || defaultbutton.titleLabel.text == nil)
        {
            NSLog(@"buttun title is nil");
            WifeId = [[NSString alloc] initWithFormat:@"%d",defaultbutton.tag];
            ADDWHICH = [[NSString alloc] initWithString:@"Wife"];
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
        else
        {
            NSLog(@"buttun title is full");
            int selectedIndex = [NameOfArr indexOfObject:defaultbutton.titleLabel.text];
            SelectedId = [[NSString alloc] initWithFormat:@"%@",[IdsArr objectAtIndex:selectedIndex] ];
            NSLog(@"SelectedId =%@ ",SelectedId);
            NSLog(@"storeUserSpose =%d ",defaultbutton.tag);
            
            
            //int indexs=[IdsArr indexOfObject:SelectedId];
            userdeviceToken=[[NSString alloc] initWithFormat:@"%@",[devicetokenArr objectAtIndex:selectedIndex]];
            //myprofilename =[[NSString alloc] initWithFormat:@"%@",[self getdataProfilename:tagstore]];
            //myname = mybuton.titleLabel.text;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                myaddfamily = [[AddFamilydataViewController alloc] initWithNibName:@"AddFamilydataViewController_Ipad" bundle:nil];
                [self.navigationController pushViewController:myaddfamily animated:YES];
            }
            else
            {
                if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
                {
                    myaddfamily = [[AddFamilydataViewController alloc] initWithNibName:@"AddFamilydataViewController" bundle:nil];
                    [self.navigationController pushViewController:myaddfamily animated:YES];
                }
                else
                {
                    myaddfamily = [[AddFamilydataViewController alloc] initWithNibName:@"AddFamilydataViewController_Iphone4" bundle:nil];
                    [self.navigationController pushViewController:myaddfamily animated:YES];
                }
            }
        }
    }
}



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.innerview;
}

/*
- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // The zoom rect is in the content view's coordinates.
    // At a zoom scale of 1.0, it would be the size of the
    // imageScrollView's bounds.
    // As the zoom scale decreases, so more content is visible,
    // the size of the rect grows.
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}
*/

#pragma mark - Action Delegate

- (IBAction)back:(id)sender
{
    
    [self.view makeToastActivity];
    // initialize the viewcontroller with a little delay, so that the UI displays the changes made above
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
         [self.navigationController popViewControllerAnimated:YES];
        [self.view hideToastActivity];
    });
   
}

- (IBAction)addIdentity:(id)sender
{
    if(EDIT_OR_VIEW_BOOL==YES)
    {
         userdeviceToken=[[NSString alloc] initWithFormat:@"%@",[devicetokenArr objectAtIndex:0]];
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            myaddnewidentity = [[AddNewIdentity
                                 alloc] initWithNibName:@"AddNewIdentity_Ipad" bundle:nil];
            [self.navigationController pushViewController:myaddnewidentity animated:YES];
        }
        else
        {
            if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
            {
                myaddnewidentity = [[AddNewIdentity
                                     alloc] initWithNibName:@"AddNewIdentity" bundle:nil];
                [self.navigationController pushViewController:myaddnewidentity animated:YES];
            }
            else
            {
                myaddnewidentity = [[AddNewIdentity
                                     alloc] initWithNibName:@"AddNewIdentity_Iphone4" bundle:nil];
                [self.navigationController pushViewController:myaddnewidentity animated:YES];
            }
        }
    }
    else
    {
        [self.view makeToast:@"You Don't Have permission to Add data. You just view Data" duration:2.0 position:@"center"];
    }
}

- (IBAction)treeList:(id)sender
{
    userdeviceToken=[[NSString alloc] initWithFormat:@"%@",[devicetokenArr objectAtIndex:0]];

    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mylist = [[ListFamily alloc] initWithNibName:@"ListFamily_Ipad" bundle:nil];
        [self.navigationController pushViewController:mylist animated:YES];
    }
    else
    {
        if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
        {
            mylist = [[ListFamily alloc] initWithNibName:@"ListFamily" bundle:nil];
            [self.navigationController pushViewController:mylist animated:YES];
        }
        else
        {
            mylist = [[ListFamily alloc] initWithNibName:@"ListFamily_Iphone4" bundle:nil];
            [self.navigationController pushViewController:mylist animated:YES];
        }
    }
}



-(void)LineDraw :(CGPoint) First : (CGPoint) Second
{
//    the next two lines are needed to get the touch point
//    UITouch *touch = [touches anyObject];
//    CGPoint new_point; //= [touch locationInView:touch.view];
    
    // first time
//    if(_last_touch_point.x < 0){
//        _last_touch_point = Second; //record the initial point, nothing to draw the first time
//    }
//    else {
    
        [self addNewLineFromPoint:First toPoint:Second];
        [[self line_view] setNeedsDisplay]; //redraw the screen
    
//        _last_touch_point = First; //now get ready for the next touch
//    }
    
}

- (IBAction)share_tree:(id)sender
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        Share_Tree_ViewContoller * mysharetree = [[Share_Tree_ViewContoller alloc] initWithNibName:@"Share_Tree_ViewContoller_Ipad" bundle:nil];
        [self.navigationController pushViewController:mysharetree animated:YES];
    }
    else
    {
        if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes)
        {
            Share_Tree_ViewContoller * mysharetree = [[Share_Tree_ViewContoller alloc] initWithNibName:@"Share_Tree_ViewContoller" bundle:nil];
            [self.navigationController pushViewController:mysharetree animated:YES];
        }
        else
        {
            Share_Tree_ViewContoller * mysharetree = [[Share_Tree_ViewContoller alloc] initWithNibName:@"Share_Tree_ViewController_Iphone4" bundle:nil];
            [self.navigationController pushViewController:mysharetree animated:YES];
        }
    }
   

}

-(void) addNewLineFromPoint:(CGPoint)from_point toPoint:(CGPoint)to_point
{
    
    
    
    Line_Line *new_line1 = [[Line_Line alloc] init];
    
//    NSLog(@"form point = %2.f - %2f",from_point.x,from_point.y);
//    NSLog(@"to_point = %2.f - %2f",to_point.x,to_point.y);
    new_line1.from_point = from_point;
    new_line1.to_point = to_point;
//    if (self.line_view == nil)
//    {
//        NSLog(@"Lineview Null So call this");
//        self.line_view = [[Line_View alloc] init];
//    }
   
    
    
    [[[self line_view] lines] addObject:new_line1];
    
//    NSLog(@"Mutable line array = %@",self.line_view.lines);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidUnload
{
    [self setShare_Button:nil];
    [self setTree_Title_Label:nil];
    [super viewDidUnload];
    self.line_view = Nil;
    self.line_view = Nil;
}

- (void)dealloc {
    [_Share_Button release];
    [_Tree_Title_Label release];
    [super dealloc];
}
@end
