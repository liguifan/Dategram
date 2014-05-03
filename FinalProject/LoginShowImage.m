//
//  CZLoginShowImage.m
//  CZLogin
//
//  Created by Cong Zhu on 4/18/14.
//  Copyright (c) 2014 Cong. All rights reserved.
//

#import "LoginShowImage.h"

@interface LoginShowImage ()
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@end

@implementation LoginShowImage

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toShowImage:(id)sender {
    [self.profilePicture setImage:self.imageData];
}

@end
