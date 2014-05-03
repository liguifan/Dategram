//
//  MatchViewController.h
//  FinalProject
//
//  Created by bread on 4/27/14.
//  Copyright (c) 2014 COMS6998. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchViewController : UIViewController
@property (atomic, strong)NSTimer *time5s;
@property (atomic, strong)NSTimer *time2s;
@property (atomic, strong)NSDictionary *userinfo;// this is to store the info of userself
@property (strong, nonatomic) IBOutlet UIButton *profilePicture;
@property (atomic, strong)NSMutableDictionary *matchinfo;
@property (strong, nonatomic) IBOutlet UIButton *Matchbutton;
@property (atomic, strong)NSString *status;// store the current status: nothing, matching, quit, enter
@end
