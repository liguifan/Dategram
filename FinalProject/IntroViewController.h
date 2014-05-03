//
//  efj2106ViewController.h
//  FinalProject
//
//  Created by Eric Johnson on 4/23/14.
//  Copyright (c) 2014 COMS6998. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface IntroViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end
