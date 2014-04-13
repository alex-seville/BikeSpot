//
//  CPSignInViewController.m
//  GroupProject
//
//  Created by Eugenia Leong on 4/12/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPSignInViewController.h"
#import "CPEnterAccountViewController.h"
#import <Parse/Parse.h>
#import "CPViewLocationViewController.h"

@interface CPSignInViewController ()
- (IBAction)signInFB:(id)sender;
- (IBAction)SignIn:(id)sender;
- (IBAction)createNewAccount:(id)sender;

@property (strong, nonatomic) CPEnterAccountViewController *enterAccountViewController;
@property (strong, nonatomic) UINavigationController *enterAccountNavigationViewController;
@property (strong, nonatomic) CPEnterAccountViewController * createAccountViewController;
@property (strong, nonatomic) UINavigationController *createAccountNavigationViewController;

@end

@implementation CPSignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // sign in view controller
        self.enterAccountViewController = [[CPEnterAccountViewController alloc] initWithSignInOption];
        self.enterAccountNavigationViewController = [[UINavigationController alloc] initWithRootViewController:self.enterAccountViewController];
        
        // sign up view controller
        self.createAccountViewController = [[ CPEnterAccountViewController alloc] initWithNewAccountOption];
        self.createAccountNavigationViewController = [[UINavigationController alloc] initWithRootViewController:self.createAccountViewController];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)viewDidAppear:(BOOL)animated
{
    if ([PFUser currentUser])// && // Check if a user is cached
        //[PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        [self showLocationViewController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInFB:(id)sender {
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            if (!error)
            {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            }
            else
            {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        }
        else {
            NSLog(@"User with facebook logged in!");
            [self showLocationViewController];
        }
    }];
}

- (IBAction)SignIn:(id)sender {
    [self presentViewController:self.enterAccountNavigationViewController animated:YES completion:nil];
    
}

- (IBAction)createNewAccount:(id)sender {
    [self presentViewController:self.createAccountNavigationViewController animated:YES completion:nil];
}
        
- (void) showLocationViewController {
    CPViewLocationViewController *viewLocationViewController = [[CPViewLocationViewController alloc] init];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:viewLocationViewController];
    [self presentViewController:navigationController animated:NO completion:nil];
}

@end
