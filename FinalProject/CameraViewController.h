//
//  CameraViewController.h
//  FinalProject
//
//  Created by Eric Johnson on 4/26/14.
//  Copyright (c) 2014 COMS6998. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *profilePic;

- (IBAction)takePhoto:(UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;

@end
