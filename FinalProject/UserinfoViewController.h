//
//  UserinfoViewController.h
//  FinalProject
//
//  Created by bread on 4/27/14.
//  Copyright (c) 2014 COMS6998. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface UserinfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,XYPieChartDataSource,XYPieChartDelegate>
@property (strong, nonatomic) IBOutlet XYPieChart *piechart;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;
@property (strong, nonatomic) IBOutlet UITableView *table;

@end
