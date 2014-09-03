//
//  AppDelegate.h
//  mysampleTree
//
//  Created by Prajas on 4/10/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"
#import "UIDevice+Resolutions.h"
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    LoginView * mylogin;
    UINavigationController * mynavigation;
}

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;
@end
