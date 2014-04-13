//
//  CPUserProfileViewController.m
//  GroupProject
//
//  Created by Eugenia Leong on 4/12/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPUserProfileViewController.h"
#import "CPUser.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>

@interface CPUserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *firstname;
@property (weak, nonatomic) IBOutlet UILabel *lastname;
@property (weak, nonatomic) IBOutlet UILabel *currentcity;
@property (weak, nonatomic) IBOutlet UILabel *email;

@property (strong,nonatomic) UIBarButtonItem *editButton;

@end

@implementation CPUserProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Me";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CPUser *currentUser = [CPUser currentUser];
    BOOL isLinkedToFacebook = [PFFacebookUtils isLinkedWithUser:currentUser];
    
    self.firstname.text = @"";
    self.lastname.text = @"";
    self.currentcity.text = @"";
    self.email.text = @"";
    
    self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEdit:)];
    self.navigationItem.rightBarButtonItem = self.editButton;
    
    if (isLinkedToFacebook)
    {
        // Create request for user's Facebook data
        FBRequest *request = [FBRequest requestForMe];
        
        // Send request to Facebook
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                NSLog(@"%@", userData);
                NSString *facebookID = userData[@"id"];
                self.firstname.text = userData[@"first_name"];
                self.lastname.text = userData[@"last_name"];
                self.currentcity.text = userData[@"location"][@"name"];
                                
                NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                
                [self.profileImage setImageWithURL:pictureURL placeholderImage:nil];

            }
        }];
    }
    else
    {

        if (currentUser.firstname)
        {
            self.firstname.text = currentUser.firstname;
        }
        else
        {
            self.firstname.text = @"";
        }
        
        if (currentUser.lastname)
        {
            self.lastname.text = currentUser.lastname;
        }
        else
        {
            self.lastname.text = @"";
        }
        
        if (currentUser.city && currentUser.state)
        {
            self.currentcity.text = [NSString stringWithFormat:@"%@, %@", currentUser.city, currentUser.state];
        }
        else if (currentUser.state)
        {
            self.currentcity.text = currentUser.state;
        }
        else if (currentUser.city)
        {
            self.currentcity.text = currentUser.city;
        }
        else
        {
            self.currentcity.text = @"";
        }
    }
    
    if (currentUser.email)
    {
        self.email.text = currentUser.email;
    }
    else
    {
        self.email.text = @"";
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onEdit:(id)sender
{
    
}

@end
