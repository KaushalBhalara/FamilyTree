//
//  TreeViewContoller.h
//  Mera Parivar
//
//  Created by Prajas on 4/21/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewIdentityView.h"
#import "ASIHTTPRequest.h"
#import "DrawLine.h"
#import <QuartzCore/QuartzCore.h>
#import "AddFamilydataViewController.h"
#import "Line_View.h"
#import "Line_Line.h"
#import "ListFamily.h"
#import "NewAdddata.h"
#import "AddNewIdentity.h"


@class AddFamilydataViewController;
@class ListFamily;
@class NewAdddata;
@class AddNewIdentity;

NSArray * mynewarray;
NSString * myname;
NSString * myprofilename;
NSString * WifeId;
NSString * SelectedId;
NSString * userdeviceToken;
NSString *PARENT;
NSString *CHILD;
NSString *SYBILING;
NSString *IDS;
NSString *NAME;

NSMutableArray *NameOfArr,*IdsArr,*profile_nameArr,*numberArr,*spouseArr,*ageArr,*lastArr,*genderArr,*profile_name,*devicetokenArr;

BOOL FIRSTADDPARENT;
int LOCK;
@interface TreeViewContoller : UIViewController <ASIHTTPRequestDelegate,UIScrollViewDelegate>
{
    NewIdentityView *mynewIdentityadd;
    NewAdddata *myadddata;
    ListFamily * mylist;
    AddFamilydataViewController * myaddfamily;
    Line_Line *new_line;
    AddNewIdentity * myaddnewidentity;
    
    float originx;
    float originy;
    int numberofparent;
    int numberofsibbling;
    int numberofchild;
    int tempcount;
    
    NSOperationQueue * queue;
    UIImageView *smallImage;
    
    float firstx;
    float firsty;
    float childx;
    float childy;
    float siblingx;
    float siblingy;
    float papax;
    float papay;
    
    NSMutableArray * Treee;
    NSMutableDictionary  * Dictree;
    
    
    BOOL FlagCallOne;
    CGPoint _last_touch_point;
    
    CGPoint _User_Upside;
    CGPoint _User_Bottomside;
    CGPoint _First_Parent_Bottom;
    CGPoint _Parent_Bottom;
    CGPoint _Child_Up;
    CGPoint _Sibling_Up;
    CGPoint _Upside_store;
    CGPoint _Upside_Sibling_store_left;
    CGPoint _Upside_Sibling_store_right;
    CGPoint _User_Wife_Center;
    CGPoint _Child_Up_left;
    CGPoint _Child_Up_right;
    
    int ParentsettingCounter;
    int SiblingTotal;
    int ChildTotal;
    
    NSString * storeUserparent;
    NSString * storeUsersibling;
    NSString * storeUserchild;
    NSString * storeUsername;
    NSString * storeUserids;
    NSString * storeUserprofileName;
    NSString * storeUserSpose;
    
}
@property (retain, nonatomic) IBOutlet UILabel *Tree_Title_Label;
@property (retain, nonatomic) NSOperationQueue * queue;
@property(nonatomic, retain) IBOutlet UIScrollView * myscroll;
//@property (nonatomic, retain) IBOutlet UIView * innerview;
@property (nonatomic, retain) IBOutlet Line_View * innerview;
- (IBAction)back:(id)sender;
- (IBAction)addIdentity:(id)sender;
- (IBAction)treeList:(id)sender;

@property (strong, nonatomic) IBOutlet Line_View *line_view;
- (IBAction)share_tree:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *Share_Button;

-(void) addNewLineFromPoint:(CGPoint)from_point toPoint: (CGPoint) to_point;

@end
