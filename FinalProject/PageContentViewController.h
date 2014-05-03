//
//  PageContentViewController.h
//  FinalProject
//
//  Created by Eric Johnson on 4/23/14.
//  Copyright (c) 2014 COMS6998. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *stockImage;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

@end
