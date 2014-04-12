//
//  CPSignInViewController.m
//  GroupProject
//
//  Created by Eugenia Leong on 4/12/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPSignInViewController.h"
#import "CPEnterAccountViewController.h"

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInFB:(id)sender {
}

- (IBAction)SignIn:(id)sender {
    [self presentViewController:self.enterAccountNavigationViewController animated:YES completion:nil];
    
}

- (IBAction)createNewAccount:(id)sender {
    [self presentViewController:self.createAccountNavigationViewController animated:YES completion:nil];
}

@end
