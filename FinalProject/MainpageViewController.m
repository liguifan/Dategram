//
//  MainpageViewController.m
//  FinalProject
//
//  Created by bread on 4/27/14.
//  Copyright (c) 2014 COMS6998. All rights reserved.
//

#import "MainpageViewController.h"
#import "MatchViewController.h"
#import "FriendlistViewController.h"
#import "IIViewDeckController.h"

@interface MainpageViewController ()

@end

@implementation MainpageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    MatchViewController* centerController = [sb instantiateViewControllerWithIdentifier:@"MatchViewController"];
    FriendlistViewController* rightController = [sb instantiateViewControllerWithIdentifier:@"FriendlistViewController"];
    
    IIViewDeckController* deckController =   [[IIViewDeckController alloc]
                                              initWithCenterViewController:centerController
                                              rightViewController:rightController];
    
    self.window.rootViewController = deckController;
    [self.window makeKeyAndVisible];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
