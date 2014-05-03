//
//  efj2106AppDelegate.h
//  FinalProject
//
//  Created by Eric Johnson on 4/23/14.
//  Copyright (c) 2014 COMS6998. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface DategramAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator ;

@property (strong, nonatomic) UIWindow *window;

-(NSArray*)getProfileInfor;
@end
