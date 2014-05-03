//
//  CZLoginViewController.m
//  CZLogin
//
//  Created by Cong Zhu on 4/16/14.
//  Copyright (c) 2014 Cong. All rights reserved.
//

#import "DategramAppDelegate.h"
#import "Profile.h"
#import "LoginViewController.h"
#import "LoginShowImage.h"
#import "IIViewDeckController.h"
#import "MatchViewController.h"
#import "FriendlistViewController.h"
#import "SGJSON.h"

@interface LoginViewController ()

@property (nonatomic,strong)NSArray* fetchedRecordsArray;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailAddr;

@property (strong, nonatomic) UIImage * imageData;

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *photourl;
@property (strong, nonatomic) NSString *locale;
@property (strong, nonatomic) NSString *movies;
@property (strong, nonatomic) NSString *music;
@property (strong, nonatomic) NSString *sports;
@property (strong, nonatomic) NSString *favorite_athletes;
@property (strong, nonatomic) NSString *favorite_teams;
@property (strong, atomic) NSMutableArray *favoritewithid; // this is to save all the favourites and its id
@property (strong, nonatomic) NSNumber *age; // ?NSString
@property(nonatomic) dispatch_time_t  popTime;
@property(nonatomic) double delayInSeconds;





@end

@implementation LoginViewController

- (void)viewDidLoad
{
    //1
    DategramAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //2
    self.managedObjectContext = appDelegate.managedObjectContext;

    self.fetchedRecordsArray = [appDelegate getProfileInfor];
    double resultsNum = [self.fetchedRecordsArray count];
    for (double i = 0; i < resultsNum; i++) {
        [self.managedObjectContext deleteObject:[self.fetchedRecordsArray objectAtIndex:i]];
            NSError *error;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn’t save: %@", [error localizedDescription]);
            }
    }

    
    
    [super viewDidLoad];
    self.favoritewithid = [NSMutableArray new];

    [self.favoritewithid removeAllObjects];
	// Do any additional setup after loading the view, typically from a nib.
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:
                              @[@"basic_info", @"email", @"user_likes", @"user_photos", @"user_interests", @"user_birthday"]];
    loginView.delegate = self;
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 300);
    [self.view addSubview:loginView];
}

- (void) viewWillAppear {
    //1
    DategramAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //2
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    self.fetchedRecordsArray = [appDelegate getProfileInfor];
    
    double resultsNum = [self.fetchedRecordsArray count];
    for (double i = 0; i < resultsNum; i++) {
        [self.managedObjectContext deleteObject:[self.fetchedRecordsArray objectAtIndex:i]];
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn’t save: %@", [error localizedDescription]);
        }
    }
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.profilePictureView.profileID = user.id;
    self.nameLabel.text = user.name;
    self.emailAddr.text = [user objectForKey:@"email"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", user.id];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    self.imageData = [[UIImage alloc] initWithData:data];
    
    
    /////////////////////////////////////////
    [FBRequestConnection startWithGraphPath:@"me?fields=id,name,movies,favorite_teams,favorite_athletes,music"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  
                                  self.ID = [result objectForKey:@"id"];
                                       // NSLog(@"ID: %@", self.ID);
                                  self.name = [result objectForKey:@"name"];
                                        //NSLog(@"name: %@", self.name);
                                  self.gender = [user objectForKey:@"gender"];
                                        //NSLog(@"gender: %@", self.gender);
                                  self.photourl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", self.ID];
                                        //NSLog(@"photourl: %@", self.photourl);
                                  self.birthday = [user objectForKey:@"birthday"];
                                        //NSLog(@"birthday: %@", self.birthday);
                                  self.locale = [user objectForKey:@"locale"];
                                        //NSLog(@"locale: %@", self.locale);
                                  self.movies = [self likesFromFacebook: [[result objectForKey:@"movies"] objectForKey:@"data"]];
                                        //NSLog(@"movies: %@", self.movies);
                                  self.music = [self likesFromFacebook: [[result objectForKey:@"music"] objectForKey:@"data"]];
                                        //NSLog(@"music: %@", self.music);
                                  self.sports = [self likesFromFacebook: [user objectForKey:@"sports"]];
                                        //NSLog(@"sports: %@", self.sports);
                                  self.favorite_athletes = [self likesFromFacebook: [result objectForKey:@"favorite_athletes"]];
                                        //NSLog(@"favorite_athletes: %@", self.favorite_athletes);
                                  self.favorite_teams = [self likesFromFacebook: [result objectForKey:@"favorite_teams"]];
                                        //NSLog(@"favorite_teams: %@", self.favorite_teams);
                                  
                                  
                                  /*calculate age*/
                                  NSArray *birthdaySplit = [self.birthday componentsSeparatedByString:@"/"];
                                  
                                  NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                                  [f setNumberStyle:NSNumberFormatterDecimalStyle];
                                  NSString *currentYear = @"2014";
                                  self.age = [NSNumber numberWithFloat:([[f numberFromString:currentYear] floatValue] - [[f numberFromString:birthdaySplit[2]] floatValue])];
                                  //NSLog(@"age = %@", self.age);
                                  self.delayInSeconds = 0.8;
                                  self.popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayInSeconds * NSEC_PER_SEC));

                                  dispatch_after(self.popTime, dispatch_get_main_queue(), ^(void){
                                      //zoom the map to the specific region containing our venue
                                      
                                    //[self performSegueWithIdentifier:@"Tomain" sender:self];

                                      
                                  });
                                 
                                  
                                  
                                  
                                  
                                  //  1
                                  Profile * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Profile"
                                                                                     inManagedObjectContext:self.managedObjectContext];
                                  //  2
                                  newEntry.pictureData = self.imageData;
                                  newEntry.age = self.age;
                                  newEntry.favorite_teams = self.favorite_teams;
                                  newEntry.favoritewithid = self.favoritewithid;
                                  newEntry.favorite_athletes = self.favorite_athletes;
                                  newEntry.sports = self.sports;
                                  newEntry.iD = self.ID;
                                  newEntry.name = self.name;
                                  newEntry.gender = self.gender;
                                  newEntry.birthday = self.birthday;
                                  newEntry.photourl = self.photourl;
                                  newEntry.locale = self.locale;
                                  newEntry.movies = self.movies;
                                  newEntry.music = self.music;
                                  
                                  
                                  //  3
                                  NSError *error;
                                  if (![self.managedObjectContext save:&error]) {
                                      NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                                  }
                                  
                                 // NSLog(@"save to core data: %@", newEntry);
                                  
                                  
                            
                                  
                              } else {
                              }
                          }];
    
    

    
    
}

- (NSString*) likesFromFacebook:(NSArray *)category {
    double length = [category count];
    NSString *s = @"";
    for (double i = 0; i < length; i++) {
        NSUInteger j = i;
        NSMutableDictionary *item=[[NSMutableDictionary alloc]init];
        s = [s stringByAppendingString: [category[j] objectForKey: @"name"]];
        
        [item setObject: [category[j] objectForKey: @"id"] forKey:@"id"];
        [item setObject: [category[j] objectForKey: @"name"] forKey:@"name"];
        [self.favoritewithid addObject:item];
        NSLog(@"%lu",(unsigned long)self.favoritewithid.count);
        if (i+1 <length) {
            s = [s stringByAppendingString: @","];
        }
    };
    return s;
};
/////////////////////////////////////////////////////









// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.statusLabel.text = @"You're logged in as";
}

// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    self.nameLabel.text = @"";
    self.statusLabel.text= @"Dategram: ";
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveImageButtonClicked:(UIButton *)sender {    
    [self performSegueWithIdentifier:@"toAppView" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toShowImage"]) {
        LoginShowImage *receiver = segue.destinationViewController;
        receiver.imageData= self.imageData;
    }
}

- (IBAction)testCoreData:(id)sender {
    DategramAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    // Fetching Records and saving it in "fetchedRecordsArray" object
    self.fetchedRecordsArray = [appDelegate getProfileInfor];
    Profile *myprofile = self.fetchedRecordsArray[0];//[self.fetchedRecordsArray objectAtIndex:6];
    NSLog(@"%ld",[self.fetchedRecordsArray count]);
    NSLog(@"%@", myprofile.photourl);
    NSString* myid = myprofile.iD;
    NSLog(myid);
    NSString* myname = myprofile.name;
    NSString* mygender = myprofile.gender;
    NSString* myurl = myprofile.photourl;
    NSString* myage = [NSString stringWithFormat: @"%@", myprofile.age];
    NSString* mymovie = myprofile.movies;
    NSLog(@"%@", mymovie);
    NSString* mymusic = myprofile.music;
    NSString* myathlete = myprofile.favorite_athletes;
    NSString* myteam = myprofile.favorite_teams;
    NSMutableDictionary *myfavorite=[[NSMutableDictionary alloc]init];
    [myfavorite setObject: mymusic forKey:@"musician"];
    [myfavorite setObject: myathlete forKey:@"athlete"];
    [myfavorite setObject: myteam forKey:@"team"];
    NSLog(myurl);
    
    [SGJSON Register:myid withname:myname withgender:mygender withphotourl:myurl withage:myage withmovies:mymovie withfavorite:myfavorite completionHandler:^(bool success){//checked
        if(success) NSLog(@"register complete");
        else NSLog(@"register fail");
    }];
    
}



@end
