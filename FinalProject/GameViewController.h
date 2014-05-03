//
//  GameViewController.h
//  FinalProject
//
//  Created by bread on 4/29/14.
//  Copyright (c) 2014 COMS6998. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMSCoinView.h"
#import "LTransitionImageView.h"
#import "QRadioButton.h"
@interface GameViewController : UIViewController

@property (strong, nonatomic) IBOutlet CMSCoinView *PicView;
@property (strong, nonatomic) IBOutlet UIButton *Submit;
@property (strong, nonatomic) IBOutlet LTransitionImageView *profile;
@property (strong, nonatomic) IBOutlet QRadioButton *buttontest;

@end
