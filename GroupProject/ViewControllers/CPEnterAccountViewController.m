//
//  CPEnterAccountViewController.m
//  GroupProject
//
//  Created by Eugenia Leong on 4/11/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPEnterAccountViewController.h"
#import "CPUser.h"
#import "CPMainViewController.h"

@interface CPEnterAccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstname;
@property (weak, nonatomic) IBOutlet UITextField *lastname;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastnameLabel;
@property (assign, nonatomic) BOOL newAccount;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;

- (IBAction)submit:(id)sender;

@end

@implementation CPEnterAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNewAccountOption
{
    self = [super init];
    if (self) {
        self.newAccount = YES;
    }
    return self;
}

- (id)initWithSignInOption
{
    self = [super init];
    if (self) {
        self.newAccount = NO;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    
    if (self.newAccount) {
        [self signUp];
    }
    else {
        [self signIn];
    }
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupView {
    if (!self.newAccount) {
        self.firstname.hidden = YES;
        self.lastname.hidden = YES;
        self.email.hidden = YES;
        self.firstnameLabel.hidden = YES;
        self.lastnameLabel.hidden = YES;
        self.emailLabel.hidden = YES;
        
        self.firstname.text = @"";
        self.lastname.text = @"";
        self.email.text = @"";
        self.username.text = @"";
        self.password.text = @"";
    }
    
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
}

- (void)signUp {
    CPUser *newUser = [[CPUser alloc] initWithDictionary:@{
                                                            @"username": self.username.text,
                                                            @"firstname": self.firstname.text,
                                                            @"lastname": self.lastname.text,
                                                            @"password": self.password.text,
                                                            @"email": self.email.text
                                                            }];
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"User %@ signed up!", self.username.text);
            self.newAccount = NO;
            
            [self setupView];
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            NSLog(@"Error signing user %@ up: %@", self.username.text, errorString);
        }
    }];

}

- (void)signIn {
    
    [PFUser logInWithUsernameInBackground:self.username.text password:self.password.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // get current user info
                                            CPUser *currentUser = [CPUser currentUser];
                                            if (currentUser) {
                                                NSLog(@"User %@ has real name: %@ %@", currentUser.username, currentUser.firstname, currentUser.lastname);
                                                 CPMainViewController *mainViewController = [[CPMainViewController alloc] init];
                                                UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
                                                [self presentViewController:navigationController animated:YES completion:nil];
                                            } else {
                                                NSLog(@"User not signed in");
                                            }
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSLog(@"Log in failed: %@", [error userInfo][@"error"]);
                                        }
    }];

}
@end
