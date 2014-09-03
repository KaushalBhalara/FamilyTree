//
//  MyView.h
//  Mera Parivar
//
//  Created by Prajas on 4/18/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyidentityView.h"
#import "TreeViewContoller.h"

NSString *Pass_User_ID;
NSString *Tree_title_String;
BOOL CLICKTREEBOOL;
BOOL EDIT_OR_VIEW_BOOL;
BOOL Ckeck_For_Share_Button;

@class MyidentityView;
//@class TreeViewContoller;
@interface MyView : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSOperationQueue * queue;
    
    TreeViewContoller * mytreeView;
    MyidentityView * myidentity;
    NSMutableArray * storedata;
    NSString *check_Status;
    NSMutableArray *user_id,*editable,*tree_name;
    
}
- (IBAction)LogOut_Button_Press:(id)sender;
@property (retain, nonatomic) NSOperationQueue * queue;
@property (retain, nonatomic) IBOutlet UITableView *mytableview;
@property (retain, nonatomic) IBOutlet UILabel *mytree_label;
@property (retain, nonatomic) IBOutlet UILabel *title_label;
- (IBAction)myVIew:(id)sender;
@end
