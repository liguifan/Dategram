//
//  PCViewController.h
//  PieChart
//
//  Created by LiZheang on 4/22/14.
//  Copyright (c) 2014 LiZheang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface PCViewController : UIViewController<XYPieChartDataSource,XYPieChartDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *changePhoto;
@property (strong, nonatomic) IBOutlet XYPieChart *piechart;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;
@property (strong, nonatomic) IBOutlet UITableView *table;
@end
