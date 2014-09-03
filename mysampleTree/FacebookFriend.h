//
//  FacebookFriend.h
//  Mera Parivar
//
//  Created by Prajas on 7/21/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversalUrl.h"
#import "SBJson.h"
#import "ASIFormDataRequest.h"
#import <FacebookSDK/FacebookSDK.h>

@protocol MJSecondPopupDelegate;

@interface FacebookFriend : UIViewController <UIActionSheetDelegate>
{
    int indexno;
    int movementDistance ;
    CGFloat animatedDistance;
    NSMutableArray *Search_USER_Freiend_Arr;
    NSMutableArray *Search_USER_Freiend_ID_Arr;

}
@property (strong, nonatomic) FBRequestConnection *requestConnection;
@property (retain, nonatomic) IBOutlet UISearchBar *MyserachBar;
@property (retain, nonatomic) IBOutlet UITableView *share_table;
@property (assign, nonatomic) id <MJSecondPopupDelegate>delegate;


@end

@protocol MJSecondPopupDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(FacebookFriend*)secondDetailViewController;
@end