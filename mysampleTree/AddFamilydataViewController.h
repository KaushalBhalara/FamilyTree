//
//  AddFamilydataViewController.h
//  treeeeeeeee
//
//  Created by Prajas on 4/30/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListFamily.h"
#import "TreeViewContoller.h"
#import "NewAdddata.h"
#import "ASIHTTPRequest.h"

@class ListFamily;
@class NewAdddata;

int LASTID;
NSString * ADDWHICH;

@interface AddFamilydataViewController : UIViewController<UIActionSheetDelegate,ASIHTTPRequestDelegate>
{
    ListFamily * mylist;
    NewAdddata * myadddata;
    int ChangeActionTagValue;
    NSArray * myarray;
}
@property (retain, nonatomic) NSOperationQueue * queue;
@property (retain, nonatomic) IBOutlet UILabel *display_name;
@property (retain, nonatomic) IBOutlet UILabel *last_name;
@property (retain, nonatomic) IBOutlet UILabel *gender;
@property (retain, nonatomic) IBOutlet UIImageView *profile_image;
@property (retain, nonatomic) IBOutlet UILabel *age;
@property (retain, nonatomic) IBOutlet UILabel *Relation_label;
@property (retain, nonatomic) IBOutlet UIButton *add_button;
- (IBAction)addFamily:(id)sender;
- (IBAction)back:(id)sender;

@end
