//
//  CameraViewController.m
//  FinalProject
//
//  Created by Eric Johnson on 4/26/14.
//  Copyright (c) 2014 COMS6998. All rights reserved.
//

#import "DategramAppDelegate.h"
#import "Profile.h"
#import "CameraViewController.h"

@interface CameraViewController ()

@property (nonatomic,strong)NSArray* fetchedRecordsArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)viewDidLoad
{
    DategramAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    // Fetching Records and saving it in "fetchedRecordsArray" object
    self.fetchedRecordsArray = [appDelegate getProfileInfor];
    Profile *myprofile = self.fetchedRecordsArray[0];
    self.profilePic.image = myprofile.pictureData;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.profilePic.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)chngePhoto:(id)sender {
    DategramAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    // Fetching Records and saving it in "fetchedRecordsArray" object
    self.fetchedRecordsArray = [appDelegate getProfileInfor];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    Profile * myprofile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile"
                                                       inManagedObjectContext:self.managedObjectContext];
    
    myprofile = self.fetchedRecordsArray[0];
    myprofile.pictureData = self.profilePic.image;
    
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    
    double resultsNum = [self.fetchedRecordsArray count];
    for (double i = 1; i < resultsNum; i++) {
        [self.managedObjectContext deleteObject:[self.fetchedRecordsArray objectAtIndex:i]];
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn’t save: %@", [error localizedDescription]);
        }
    }
}

@end
