//
//  MatchViewController.m
//  FinalProject
//
//  Created by bread on 4/27/14.
//  Copyright (c) 2014 COMS6998. All rights reserved.
//

#import "DategramAppDelegate.h"
#import "Profile.h"
#import "MatchViewController.h"
#import "IIViewDeckController.h"
#import "PCViewController.h"
#import  "SGJSON.h"
#import "SVProgressHUD.h"
#import "DXAlertView.h"
#import "AskViewController.h"

@interface MatchViewController ()


@property (nonatomic,strong)NSArray* fetchedRecordsArray;
@property (strong, nonatomic) IBOutlet UIButton *toFriendList;
@property (nonatomic) DXAlertView *alert;
@property (nonatomic) DategramAppDelegate* appDelegate;
@property (nonatomic) Profile *myprofile;
@property (strong, nonatomic)NSString *mateID;
@end

@implementation MatchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.fetchedRecordsArray = [self.appDelegate getProfileInfor];
    self.myprofile= self.fetchedRecordsArray[0];//[self.fetchedRecordsArray objectAtIndex:6];
    NSString* myid = self.myprofile.iD;
    NSString* myname = self.myprofile.name;
    NSString* mygender = self.myprofile.gender;
    NSString* myurl = self.myprofile.photourl;
    NSString* myage = [NSString stringWithFormat: @"%@", self.myprofile.age];
    NSString* mymovie = self.myprofile.movies;
    NSString* mymusic = self.myprofile.music;
    NSString* myathlete = self.myprofile.favorite_athletes;
    NSString* myteam = self.myprofile.favorite_teams;
    NSMutableDictionary *myfavorite=[[NSMutableDictionary alloc]init];
    [myfavorite setObject: mymusic forKey:@"musician"];
    [myfavorite setObject: myathlete forKey:@"athlete"];
    [myfavorite setObject: myteam forKey:@"team"];
    NSLog(myurl);

    [self.profilePicture setBackgroundImage: self.myprofile.pictureData forState:UIControlStateNormal];// = myprofile.pictureData;
    [self.toFriendList setSelected: NO];
    [self.toFriendList setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
    
    [super viewWillAppear:animated];
    
    self.time5s=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scheduletask5s) userInfo:nil repeats:YES];
    
    //self.time2s=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scheduletask1s) userInfo:nil repeats:YES];
    self.alert = [[DXAlertView alloc] initWithTitle:@"Match" contentText:@"" leftButtonTitle:nil rightButtonTitle:@"Cancel"];
    self.matchinfo = [[NSMutableDictionary alloc] init];
    self.userinfo = [[NSMutableDictionary alloc] init];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openRight:(UIButton *)sender {
    if (sender.isSelected) {
        [sender setSelected: NO];
        [self.toFriendList setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
        [self.viewDeckController closeOpenView];}
    else {
        [sender setSelected: YES];
        [self.toFriendList setTitleColor:[UIColor blueColor] forState: UIControlStateSelected];
        [self.viewDeckController openRightView];}
}

- (IBAction)findmatch:(id)sender {
    [self.time5s invalidate];
    [self.alert show];
    NSString* myid = self.myprofile.iD;
    NSString* myname = self.myprofile.name;
    NSString* mygender = self.myprofile.gender;
    NSString* myurl = self.myprofile.photourl;
    NSString* myage = [NSString stringWithFormat: @"%@", self.myprofile.age];
    NSString* mymovie = self.myprofile.movies;
    NSString* mymusic = self.myprofile.music;
    NSString* myathlete = self.myprofile.favorite_athletes;
    NSString* myteam = self.myprofile.favorite_teams;
    NSMutableDictionary *myfavorite=[[NSMutableDictionary alloc]init];
    [myfavorite setObject: mymusic forKey:@"musician"];
    [myfavorite setObject: myathlete forKey:@"athlete"];
    [myfavorite setObject: myteam forKey:@"team"];

    
    [SGJSON match:myid withanswer:@"new" withfliter:myfavorite completionHandler:^(NSDictionary *respond) {
        self.mateID = [respond objectForKey:@"ID"];
        NSLog(self.mateID);
        if (![self.mateID isEqualToString:@""]) {
            double delayInSecondss = 0.3;
            dispatch_time_t popTimes = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSecondss * NSEC_PER_SEC));
            dispatch_after(popTimes, dispatch_get_main_queue(), ^(void){
                [self.alert dismissAlert];
                [SVProgressHUD dismiss];
            });
            self.matchinfo = respond;

            [self performSegueWithIdentifier:@"Togame" sender:sender];
        };
        
    }];
    
    self.alert.rightBlock = ^() {
        [SGJSON match:myid withanswer:@"quit" withfliter:myfavorite completionHandler:^(NSDictionary *respond) {
            NSLog(@"quit");
        }];
    self.time5s=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scheduletask5s) userInfo:nil repeats:YES];
    
           };

}




-(IBAction)close:(id)sender {
    [self.toFriendList setSelected: NO];
    [self.viewDeckController closeOpenView];
}

- (IBAction)toPersonalProfile:(id)sender {
    
    [self performSegueWithIdentifier:@"toPersonalProfile" sender:self];

}

-(void) scheduletask5s{
    NSLog(@"scheduletask5s");
    [SGJSON heartbeat:self.myprofile.iD withstatus:@"online" completionHandler:^(NSString* respond,NSDictionary *matchrequest, bool isrequest) {
                if(isrequest){ NSLog(@"there is a request");
                
                }
                else if([respond isEqualToString:@"enter"]){
                    self.status = @"enter";
                    NSLog(@"enter");
                }
                else if([respond isEqualToString:@"quit"]){
                    self.status = @"quit";
                    NSLog(@"quit");
                }
                else NSLog(@"nothing");
         }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Togame"]) {
        AskViewController *receiver = segue.destinationViewController;

        NSMutableDictionary __strong *data = self.matchinfo;
        receiver.matchinfo = data;
        receiver.myid= self.myprofile.iD;
        receiver.status =self.status;
        
    }
}




@end
