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
#import "CPRack.h"
#import "CPRackMiniDetailViewController.h"

@interface CPMainViewController ()
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (assign, nonatomic) BOOL mainContentShown;

@property (strong, nonatomic) UINavigationController *mapViewNavigationController;
@property (strong, nonatomic) UINavigationController *menuNavigationController;
@property (strong, nonatomic) UINavigationController *userProfileNavigationController;
@property (strong, nonatomic) UINavigationController *addParkingNavigationController;
@property (strong, nonatomic) UINavigationController *settingsNavigationController;
@property (strong, nonatomic) UINavigationController *signInNavigationController;
@property (strong, nonatomic) CPHamburgerMenuViewController *menuViewController;
@property (strong, nonatomic) CPViewLocationViewController *mapViewController;
@property (strong, nonatomic) CPUserProfileViewController *userProfileViewController;
@property (strong ,nonatomic) CPAddParkingViewController *addParkingViewController;
@property (strong, nonatomic) CPSettingsViewController *settingsViewController;
@property (strong, nonatomic) CPSignInViewController *signInViewController;



@property (nonatomic, strong) NSArray *viewControllers;
@property (weak, nonatomic) IBOutlet UIImageView *menuTab;
- (IBAction)onMenuTap:(UITapGestureRecognizer *)sender;

@property (nonatomic, strong) CPRackMiniDetailViewController *miniDetail;
@property (nonatomic, strong) CPAddParkingViewController *addNew;

@property (nonatomic, assign) int startx;

@end

@implementation CPMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.mapViewController = [[CPViewLocationViewController alloc] init];
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
        
        self.viewControllers = @[self.mapViewNavigationController, self.userProfileNavigationController, self.mapViewNavigationController];
        
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
    [self.contentView addSubview:self.menuTab];
	
	self.mapViewNavigationController.view.layer.shadowOffset = CGSizeMake(-5, 0);
    self.mapViewNavigationController.view.layer.shadowRadius = 5;
    self.mapViewNavigationController.view.layer.shadowOpacity = 0.3;
	
	/*add shadow to menu tab too */
	self.menuTab.layer.shadowOffset = CGSizeMake(-5, 0);
    self.menuTab.layer.shadowRadius = 5;
    self.menuTab.layer.shadowOpacity = 0.3;
	self.menuTab.layer.cornerRadius = 10;
    
    
    //add pan recongnizer to firstView
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc ] initWithTarget:self action:@selector(onPan:)];
    
    [self.contentView addGestureRecognizer:panGestureRecognizer];
	
	/* events for detail view */
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onOpenDetail:)
                                                 name:ViewMoreRackDetails object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUpdateDetail:)
                                                 name:UpdateMiniDetailNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onCloseDetail:)
                                                 name:CloseDetailNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUpdateWalkingTime:)
                                                 name:UpdateWalkingDistanceDetailNotification object:nil];
	
	
	/* create a new minidetail view */
	self.miniDetail = [[CPRackMiniDetailViewController alloc] init];
	self.miniDetail.view.layer.shadowColor = [UIColor blackColor].CGColor;
	self.miniDetail.view.layer.shadowRadius = 2;
	self.miniDetail.view.layer.shadowOpacity = 0.3;
	self.miniDetail.view.layer.shadowOffset = CGSizeMake(0, 0);
	self.miniDetail.view.layer.cornerRadius = 2;
    
   
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
                [self showMainContentView];
            }
            // hide main content view
            else {
                [self hideMainContentView];
                
            }
        }];
    }
}

- (IBAction)onMenuTap:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.5  animations:^{
        // show main content view
        if (!self.mainContentShown) {
            [self showMainContentView];
        }
        // hide main content view
        else {
            [self hideMainContentView];
        }
    }];
}

- (void) hideMainContentView {
    CGRect mainContentFrame = self.contentView.frame;
    mainContentFrame.origin.x = mainContentFrame.size.width-80;
    self.contentView.frame = mainContentFrame;
    self.mainContentShown = NO;
}

- (void) showMainContentView {
    CGRect mainContentFrame = self.contentView.frame;
    mainContentFrame.origin.x = 0;
    self.contentView.frame = mainContentFrame;
    self.mainContentShown = YES;
}

#pragma mark - CPHamburgerMenuViewController methods
-(void)sender:(CPHamburgerMenuViewController *)sender menuTapped:(int)index
{
    // move main display view back
    [self showMainContentView];

    CPUser *user = [CPUser currentUser];
    
    // log in
    if (!user && index == [self.viewControllers count]-1)
    {
        [self presentViewController:self.signInNavigationController animated:YES completion:nil];
        return;
    }
    // log out
    else if (user && index == [self.viewControllers count]-1)
    {
        [CPUser logOut];
    }
    
    UINavigationController *nvc = self.viewControllers[index];
    [self.contentView addSubview:nvc.view];
    
    if (index == 0 || ![CPUser currentUser])
    {
        [self.contentView addSubview:self.menuTab];
    }

    
    
    
}

#pragma mark minidetail methods

-(void)onOpenDetail:(NSNotification *) notification {
	CPRack *rack = (CPRack *)notification.userInfo[@"rack"];
	
	UIView *miniDetailView = self.miniDetail.view;
	miniDetailView.frame = CGRectMake(10, self.view.frame.size.height+10, self.view.frame.size.width-20, 100);
	[self.miniDetail setRack:rack];
	[self.view addSubview:miniDetailView];
	
	[UIView animateWithDuration:0.15 animations:^{
		miniDetailView.frame = CGRectMake(10, self.view.frame.size.height-100, self.view.frame.size.width-20, 100);
		[self createPanView:CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 100)];
	} ];
	
	
}

-(void)onUpdateDetail:(NSNotification *) notification {
	NSLog(@"update detail");
	CPRack *rack = (CPRack *)notification.userInfo[@"rack"];
	[self.miniDetail setRack:rack];

}

-(void)onCloseDetail:(NSNotification *) notification {
	NSLog(@"close detail");
	UIView *miniDetailView = self.miniDetail.view;
	[UIView animateWithDuration:0.15 animations:^{
		miniDetailView.frame = CGRectMake(10, self.view.frame.size.height+10, self.view.frame.size.width-20, 100);
	} ];
}

-(void)onUpdateWalkingTime:(NSNotification *) notification {
	NSTimeInterval time = [notification.userInfo[@"time"] doubleValue];
	[self.miniDetail setTime:time];
}

-(void)createPanView:(CGRect)rect {
	UIView *panView = [[UIView alloc] initWithFrame:rect];
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanDetails:)];
	NSLog(@"create pan view");
	[panView addGestureRecognizer:pan];
	[self.view addSubview:panView];
}

- (IBAction)onPanDetails:(UIPanGestureRecognizer *)gesture {
	
	CGPoint point = [gesture locationInView:self.miniDetail.view];
	CGPoint velocity = [gesture velocityInView:self.miniDetail.view];
	
	NSLog(@"pan: %f", point.x);
	
	if (gesture.state == UIGestureRecognizerStateBegan){
		self.startx = point.x;
	} else if (gesture.state == UIGestureRecognizerStateChanged){
		CGRect viewFrame = self.miniDetail.view.frame;
		viewFrame.origin.x += point.x - self.startx;
		self.miniDetail.view.frame = viewFrame;
	} else if (gesture.state == UIGestureRecognizerStateEnded){
		NSLog(@"x %f ",self.miniDetail.view.frame.origin.x);
		
		if (self.miniDetail.view.frame.origin.x < -100 ||
			self.miniDetail.view.frame.origin.x > 100){
			
			if (velocity.x > 1){
				NSLog(@"right?");
				CGRect viewFrame = self.miniDetail.view.frame;
				viewFrame.origin.x += self.view.frame.size.width;
				[UIView animateWithDuration:0.15 animations:^{
					//move off screen
					self.miniDetail.view.frame = viewFrame;
				} completion:^(BOOL finished) {
					self.miniDetail.view.hidden = true;
					CGRect viewFrame = self.miniDetail.view.frame;
					viewFrame.origin.x = -self.view.frame.size.width;
					self.miniDetail.view.frame = viewFrame;
					self.miniDetail.view.hidden = false;
					viewFrame.origin.x = 10;
					[UIView animateWithDuration:0.15 animations:^{
						self.miniDetail.view.frame = viewFrame;
					}];
				}];
			}else{
				NSLog(@"left?");
				CGRect viewFrame = self.miniDetail.view.frame;
				viewFrame.origin.x = -self.miniDetail.view.frame.size.width;
				[UIView animateWithDuration:0.15 animations:^{
					//move off screen
					self.miniDetail.view.frame = viewFrame;
				} completion:^(BOOL finished) {
					self.miniDetail.view.hidden = true;
					CGRect viewFrame = self.miniDetail.view.frame;
					viewFrame.origin.x = self.view.frame.size.width;
					self.miniDetail.view.frame = viewFrame;
					self.miniDetail.view.hidden = false;
					
					viewFrame.origin.x = 10;
					[UIView animateWithDuration:0.15 animations:^{
						self.miniDetail.view.frame = viewFrame;
					}];
				}];
			}
		}else{
			NSLog(@"reset");
			CGRect viewFrame = self.miniDetail.view.frame;
			viewFrame.origin.x = 10;
			[UIView animateWithDuration:0.15 animations:^{
				self.miniDetail.view.frame = viewFrame;
			}];
		}
	}
}

@end
