//
//  CPMainViewController.m
//  GroupProject
//
//  Created by Alexander Seville on 4/7/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPMainViewController.h"
#import "CPHamburgerMenuViewController.h"
#import "CPViewLocationViewController.h"
#import "CPAddParkingViewController.h"
#import "CPUserProfileViewController.h"
#import "CPSignInViewController.h"
#import "CPSettingsViewController.h"
#import "CPUser.h"

@interface CPMainViewController ()
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) UINavigationController *mapViewNavigationController;
@property (strong, nonatomic) UINavigationController *menuNavigationController;
@property (strong, nonatomic) UINavigationController *userProfileNavigationController;
@property (strong, nonatomic) UINavigationController *addParkingNavigationController;
@property (strong, nonatomic) UINavigationController *settingsNavigationController;
@property (strong, nonatomic) UINavigationController *signInNavigationController;
@property (strong, nonatomic) CPHamburgerMenuViewController *menuViewController;
@property (strong, nonatomic) CPViewLocationViewController *mapViewController;   // CHANGE THIS BACK TO MAP VIEW
@property (strong, nonatomic) CPUserProfileViewController *userProfileViewController;
@property (strong ,nonatomic) CPAddParkingViewController *addParkingViewController;
@property (strong, nonatomic) CPSettingsViewController *settingsViewController;
@property (strong, nonatomic) CPSignInViewController *signInViewController;


@property (nonatomic, strong) NSArray *loggedInViewControllers;
@property (nonatomic, strong) NSArray *loggedOutViewControllers;

@end

@implementation CPMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.mapViewController = [[CPViewLocationViewController alloc] init];    // CHANGE THIS BACK TO MAP VIEW
        self.mapViewNavigationController = [[UINavigationController alloc] initWithRootViewController:self.mapViewController];
        
        self.userProfileViewController = [[CPUserProfileViewController alloc] init];
        self.userProfileNavigationController = [[UINavigationController alloc] initWithRootViewController:self.userProfileViewController];
        
        self.menuViewController = [[CPHamburgerMenuViewController alloc] init];
        self.menuNavigationController = [[UINavigationController alloc] initWithRootViewController:self.menuViewController];
        
        self.addParkingViewController = [[CPAddParkingViewController alloc] init];
        self.addParkingNavigationController = [[UINavigationController alloc] initWithRootViewController:self.addParkingViewController];
        
        self.settingsViewController = [[CPSettingsViewController alloc] init];
        self.settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:self.settingsViewController];
        
        self.signInViewController = [[CPSignInViewController alloc] init];
        self.signInNavigationController = [[UINavigationController alloc] initWithRootViewController:self.signInViewController];
        
        self.loggedInViewControllers = @[self.mapViewNavigationController, self.userProfileNavigationController, self.addParkingNavigationController, self.settingsNavigationController, self.mapViewNavigationController];
        
        self.loggedOutViewControllers = @[self.mapViewNavigationController, self.signInNavigationController];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationController.navigationBar.hidden=YES;
    
    [self.menuView addSubview:self.menuNavigationController.view];
    self.menuViewController.delegate = self;
    
    [self.contentView addSubview:self.mapViewNavigationController.view];
    [self.contentView bringSubviewToFront:self.mapViewNavigationController.view];
    [self.view bringSubviewToFront:self.contentView];
    
    
    //add pan recongnizer to firstView
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc ] initWithTarget:self action:@selector(onPan:)];
    
    [self.contentView addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    // drag the MAIN CONTENT VIEW frame away
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (velocity.x > 0) {
            CGRect mainContentFrame = self.contentView.frame;
            if (mainContentFrame.origin.x <= self.view.frame.size.width-80) {
                mainContentFrame.origin.x += 10;
                self.contentView.frame = mainContentFrame;
            }
        }
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.5  animations:^{
            // show main content view
            if (velocity.x <= 0) {
                CGRect mainContentFrame = self.contentView.frame;
                mainContentFrame.origin.x = 0;
                self.contentView.frame = mainContentFrame;
            }
            // hide main content view
            else {
                CGRect mainContentFrame = self.contentView.frame;
                mainContentFrame.origin.x = mainContentFrame.size.width-80;
                self.contentView.frame = mainContentFrame;
                
            }
        }];
    }
}

- (void)displayMainContentView
{
    [UIView animateWithDuration:0.5  animations:^{
        CGRect mainContentFrame = self.contentView.frame;
        mainContentFrame.origin.x = 0;
        self.contentView.frame = mainContentFrame;
        
    }];
}

#pragma mark - CPHamburgerMenuViewController methods
-(void)sender:(CPHamburgerMenuViewController *)sender menuTapped:(int)index
{
    // move main display view back
    [self displayMainContentView];

    CPUser *user = [CPUser currentUser];
    
    // log in
    if (!user && index == [self.loggedOutViewControllers count]-1)
    {
        [self presentViewController:self.signInNavigationController animated:YES completion:nil];
        return;
    }
    // log out
    else if (user && index == [self.loggedInViewControllers count]-1)
    {
        [CPUser logOut];
    }
    
    UINavigationController *nvc = self.loggedInViewControllers[index];
    [self.contentView addSubview:nvc.view];
    [self.contentView bringSubviewToFront:nvc.view];
    
    
    
}
@end
