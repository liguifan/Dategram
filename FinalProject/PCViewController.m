//
//  PCViewController.m
//  PieChart
//
//  Created by LiZheang on 4/22/14.
//  Copyright (c) 2014 LiZheang. All rights reserved.
//

#import "DategramAppDelegate.h"
#import "Profile.h"
#import "PCViewController.h"
#import "CameraViewController.h"
#import "BasicCell.h"

@interface PCViewController ()

@property (nonatomic,strong)NSArray* fetchedRecordsArray;

@end

@implementation PCViewController

@synthesize piechart = _piechart;
//@synthesize piechart = _pieChartCopy;
//@synthesize percentageLabel = _percentageLabel;
//@synthesize selectedSliceLabel = _selectedSlice;
//@synthesize numOfSlices = _numOfSlices;
//@synthesize indexOfSlices = _indexOfSlices;
//@synthesize downArrow = _downArrow;
@synthesize slices = _slices;
@synthesize sliceColors = _sliceColors;


- (void)viewWillAppear:(BOOL)animated
{
    DategramAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    // Fetching Records and saving it in "fetchedRecordsArray" object
    self.fetchedRecordsArray = [appDelegate getProfileInfor];
    Profile *myprofile = self.fetchedRecordsArray[0];//[self.fetchedRecordsArray objectAtIndex:6];
    //    NSLog(@"%@", myprofile);
    [self.changePhoto setBackgroundImage: myprofile.pictureData forState:UIControlStateNormal];// = myprofile.pictureData;
    [super viewWillAppear: animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    self.table.backgroundColor = [UIColor whiteColor];
    //[self.table.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    self.table.transform = CGAffineTransformMakeRotation(M_PI/-2);
    self.table.showsVerticalScrollIndicator = NO;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.table.frame = CGRectMake(0, 0, 100, 60);
    self.table.rowHeight = 60.0;
    //self.table.
    self.table.delegate = self;
    self.table.dataSource = self;

    
    
    self.slices = [NSMutableArray arrayWithCapacity:10];
  /*
    for(int i = 0; i < 5; i ++)
    {
        NSNumber *one = [NSNumber numberWithInt:rand()%60+20];
        [_slices addObject:one];
    }*/
    [_slices addObject:[NSNumber numberWithInt:11]];
    [_slices addObject:[NSNumber numberWithInt:12]];
    [_slices addObject:[NSNumber numberWithInt:13]];
    [_slices addObject:[NSNumber numberWithInt:14]];
    [_slices addObject:[NSNumber numberWithInt:21]];
    [_slices addObject:[NSNumber numberWithInt:15]];
    [_slices addObject:[NSNumber numberWithInt:14]];

    
    [self.piechart setDataSource:self];
    [self.piechart setStartPieAngle:M_PI_2];
    [self.piechart setAnimationSpeed:1.0];
  //  [self.piechart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:20]];
    [self.piechart setLabelColor:[UIColor blackColor]];
    [self.piechart setLabelRadius:60];
    [self.piechart setShowPercentage:NO];
    [self.piechart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    //[self.piechart setPieCenter:CGPointMake(150, 100)];
    [self.piechart setUserInteractionEnabled:NO];
    [self.piechart setLabelShadowColor:[UIColor blackColor]];
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    
    //rotate up arrow
    //self.downArrow.transform = CGAffineTransformMakeRotation(M_PI);

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.piechart reloadData];
    //[self.pieChartRight reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    //if(pieChart == self.pieChartRight) return nil;
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %d",index);
    //self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
}

- (IBAction)changePhoto:(id)sender {
    
    [self performSegueWithIdentifier:@"SelectPicture" sender:self];
  
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"SelectPicture"]) {
        
        CameraViewController *receiver = segue.destinationViewController;
        //BookMark *result = [self.bookMarkedArray objectAtIndex: self.tappedPath.row];
        //self.sendData = result.data;
        //NSMutableDictionary __strong *data = self.sendData;
        //receiver.data = data;
        //receiver.firstloaded = true;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 16;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     static NSString *CellIdentifier = @"Cell";
     @autoreleasepool{
     BasicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     //if (cell == nil) {
     cell = [[BasicCell alloc] initWithStyle:UITableViewCellStyleDefault
     reuseIdentifier:CellIdentifier];
     cell.image.image=[UIImage imageNamed:@"image.png"];
     //cell.accessoryView
     // cell.imageView.sizeToFit;
     // cell.image.transform  =CGAffineTransformMakeRotation(M_PI/2);
     //cell.selectionStyle = UITableViewCellSelectionStyleGray;
     // cell.textLabel.textAlignment = NSTextAlignmentCenter;
     // cell.textLabel.backgroundColor = [UIColor redColor];
     cell.label.text = @"test";
     //cell.label.transform = CGAffineTransformMakeRotation(M_PI/2);
     cell.frame = CGRectMake(0, 0, 60, 60);
     
     //}
     // cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
     return cell;
     }*/
    static NSString *CellIdentifier = @"Cell2";
    @autoreleasepool {
        
        //DetailCell* CellIdentifier;
        // NSLog(@"here");
        BasicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.image.image=[UIImage imageNamed:@"page2.png"];
        //cell.accessoryView
        // cell.imageView.sizeToFit;
        cell.image.transform  =CGAffineTransformMakeRotation(M_PI/2);
        cell.image.layer.cornerRadius=roundf(cell.image.frame.size.width/2.0);
        cell.image.layer.masksToBounds=YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // cell.textLabel.backgroundColor = [UIColor redColor];
        cell.label.text = @"test";
        cell.label.transform = CGAffineTransformMakeRotation(M_PI/2);
        cell.label.textAlignment = NSTextAlignmentCenter;
        //cell.frame = CGRectMake(0, 0, 60, 60);
        
        
        
        // Configure the cell...
        
        return cell;
    }
}



@end
