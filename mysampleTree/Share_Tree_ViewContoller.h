//
//  Share_Tree_ViewContoller.h
//  Mera Parivar
//
//  Created by Prajas on 7/21/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MJPopupViewController.h"
#import "FacebookFriend.h"

@interface Share_Tree_ViewContoller : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MJSecondPopupDelegate,UIActionSheetDelegate>
{
    NSString *inputText;
}
@property (retain, nonatomic) IBOutlet UITableView *share_table;
- (IBAction)back:(id)sender;
- (IBAction)facebook_share:(id)sender;
- (IBAction)mail_share:(id)sender;

@end
