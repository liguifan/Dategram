//
//  AskViewController.h
//  FinalProject
//
//  Created by bread on 5/2/14.
//  Copyright (c) 2014 COMS6998. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DategramAppDelegate.h"
#import "Profile.h"
#import "MatchViewController.h"
#import "IIViewDeckController.h"
#import "PCViewController.h"
#import  "SGJSON.h"
#import "SVProgressHUD.h"
#import "DXAlertView.h"
#import "AskViewController.h"

@interface AskViewController : UIViewController
@property (nonatomic, strong)NSMutableDictionary* matchinfo;
@property (nonatomic, strong)NSString* myid;
@property (atomic, strong)NSString *status;// store the current status: nothing, matching, quit, enter
@property (strong, nonatomic) IBOutlet UIButton *Play;
@property (strong, nonatomic) IBOutlet UIButton *Deny;
@end
