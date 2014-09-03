//
//  ListFamily.h
//  treeeeeeeee
//
//  Created by Prajas on 4/30/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewAdddata.h"
#import "TreeViewContoller.h"
#import "EditViewController.h"
#import "ASIHTTPRequest.h"

@class NewAdddata;
int SelectRecord;
NSString * Select_Name;
//int LASTID;
//NSString * ADDWHICH;
BOOL MAKECHANGEBOOL;
@interface ListFamily : UIViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,ASIHTTPRequestDelegate>
{
    NewAdddata * myadddata;
    EditViewController * myeditview;
    NSArray * myarray;
    
    
    BOOL EDITFLAG;
    
}
@property (retain, nonatomic) NSOperationQueue * queue;
- (IBAction)adddata:(id)sender;
@property (retain, nonatomic) IBOutlet UITableView *mytable;
- (IBAction)back:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *edit_button;

- (IBAction)edit:(id)sender;

@end
