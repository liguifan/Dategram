//
//  AskViewController.m
//  FinalProject
//
//  Created by bread on 5/2/14.
//  Copyright (c) 2014 COMS6998. All rights reserved.
//

#import "AskViewController.h"

@interface AskViewController ()
@property(nonatomic,strong)NSTimer* time4s;
@end

@implementation AskViewController

- (void)viewDidLoad
{
    [self.view setNeedsDisplay];

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
      //  self.time4s=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scheduletask5s) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)ondeny:(id)sender {
    NSMutableDictionary *myfavorite=[[NSMutableDictionary alloc]init];
    
    NSString* myid = self.myid;
    NSLog(@"ondeny,%@", myid);
    [SGJSON match:myid withanswer:@"quit" withfliter:myfavorite completionHandler:^(NSDictionary *respond) {
        NSLog(@"I agree");
        NSString* respon = [respond objectForKey:@"OK"];
        NSLog(respon);
    }];
    
    
}

- (IBAction)onpaly:(id)sender {
    NSString* myid = self.myid;
    NSLog(@"onplay,%@", myid);
    NSMutableDictionary *myfavorite=[[NSMutableDictionary alloc]init];
    [SGJSON match:myid withanswer:@"hello" withfliter:myfavorite completionHandler:^(NSDictionary *respond) {
        NSLog(@"I agree");
        
    }];
    
}


-(void) scheduletask5s{
    NSLog(@"scheduletask4s: ask view controller");
    [SGJSON heartbeat:self.myid withstatus:@"online" completionHandler:^(NSString* respond,NSDictionary *matchrequest, bool isrequest) {
        if(isrequest){
            NSLog(@"%@",respond);
                  NSLog( @"%@", [matchrequest objectForKey:@"ID"]);
        
        }
        else if([respond isEqualToString:@"enter"]){
            self.status = @"enter";
            NSLog(@"enter");
        }
        else if([respond isEqualToString:@"quit"]){
            self.status = @"quit";
            NSLog(@"quit");
        }
        else NSLog(@"nothing+mm");
    }];
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
