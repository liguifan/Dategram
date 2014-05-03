//
//  GameViewController.m
//  FinalProject
//
//  Created by bread on 4/29/14.
//  Copyright (c) 2014 COMS6998. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()
@property(atomic) UIImage *img;
@property(atomic)UIImage* nextimg;
@property (nonatomic, strong) NSMutableArray* buttons;
@end

@implementation GameViewController

@synthesize PicView;
- (IBAction)ShareButton:(id)sender {
}



- (IBAction)OnSubmit:(id)sender {
    [self.PicView flip];
    self.profile.animationDirection = AnimationDirectionLeftToRight;
    self.profile.image = self.nextimg;
    for(QRadioButton* button in self.buttons){
        [button setTitle:@"fuck" forState:UIControlStateNormal];
        [button setSelected:false];
    }
    
}

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
    [super viewDidLoad];
    UIImageView *first = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"ysg.jpg"]];
    UIImageView *second = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"profile.png"]];
    [PicView setPrimaryView: first];
    [PicView setSecondaryView: second];
    [PicView setSpinTime:1.0];
    [self.profile.layer setCornerRadius: (self.profile.frame.size.height/2)];

    self.profile.animationDuration = 1;
//    [self.profile.layer setCornerRadius: (self.profile.frame.size.height/2)];
//    [self.profile.layer setMasksToBounds:YES];
    self.profile.image = [UIImage imageNamed:@"profile.png"];

    self.nextimg = [UIImage imageNamed:@"ysg.jpg"];
    
    self.buttons =[NSMutableArray new];
    
    QRadioButton *radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    radio1.frame = CGRectMake(20, 420, 120, 40);
    [radio1 setTitle:@"苹果iuhuhiiuh" forState:UIControlStateNormal];
    [radio1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.view addSubview:radio1];
    [self.buttons addObject:radio1];
    QRadioButton *radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    radio2.frame = CGRectMake(20, 470, 120, 40);
    [radio2 setTitle:@"梨子" forState:UIControlStateNormal];
    [radio2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [radio2.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.view addSubview:radio2];
    [self.buttons addObject:radio2];
    QRadioButton *radio3 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    radio3.frame = CGRectMake(170, 420, 120, 40);
    [radio3 setTitle:@"梨子" forState:UIControlStateNormal];
    [radio3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [radio3.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.view addSubview:radio3];
    [self.buttons addObject:radio3];
    QRadioButton *radio4 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    radio4.frame = CGRectMake(170, 470, 120, 40);
    [radio4 setTitle:@"梨子" forState:UIControlStateNormal];
    [radio4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [radio4.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.view addSubview:radio4];
    [self.buttons addObject:radio4];


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
