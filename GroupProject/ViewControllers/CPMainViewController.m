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
#import "CPHelpScreenViewController.h"
#import "CPInstructionViewController.h"
#import "CPAboutViewController.h"

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
@property (strong, nonatomic) UINavigationController *aboutNavigationController;
@property (strong, nonatomic) CPHamburgerMenuViewController *menuViewController;
@property (strong, nonatomic) CPViewLocationViewController *mapViewController;
@property (strong, nonatomic) CPUserProfileViewController *userProfileViewController;
@property (strong ,nonatomic) CPAddParkingViewController *addParkingViewController;
@property (strong, nonatomic) CPSettingsViewController *settingsViewController;
@property (strong, nonatomic) CPSignInViewController *signInViewController;
@property (strong, nonatomic) CPHelpScreenViewController *helpViewController;
@property (strong, nonatomic) CPInstructionViewController *instructionViewController;
@property (strong, nonatomic) CPAboutViewController *aboutViewController;


@property (nonatomic, strong) NSArray *viewControllers;
@property (weak, nonatomic) IBOutlet UIImageView *menuTab;
- (IBAction)onMenuTap:(UITapGestureRecognizer *)sender;

@property (nonatomic, strong) CPRackMiniDetailViewController *miniDetail;
@property (nonatomic, strong) CPAddParkingViewController *addNew;

@property (nonatomic, assign) int startx;
@property (nonatomic, strong) UIView *panView;

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
        
        self.aboutViewController = [[CPAboutViewController alloc] init];
        self.aboutNavigationController = [[UINavigationController alloc] initWithRootViewController:self.aboutViewController];
        
        self.viewControllers = @[self.mapViewNavigationController, self.userProfileNavigationController, self.aboutNavigationController, self.mapViewNavigationController];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationController.navigationBar.hidden=YES;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	//[defaults setBool:false forKey:@"hasStarted"];
	if (![defaults boolForKey:@"hasStarted"]){
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(onCloseHelpWindow)
													 name:CloseHelpView object:nil];
		
		self.helpViewController = [[CPHelpScreenViewController alloc] init];
		
		[self.contentView addSubview:self.helpViewController.view];
		[self.contentView bringSubviewToFront:self.helpViewController.view];
	}else{
		[self setupViewsAndEvents];
	}
   
}

-(void)onCloseHelpWindow {
	
	[self setupViewsAndEvents];
	[UIView animateWithDuration:0.15 animations:^{
		self.helpViewController.view.alpha = 0;
	} completion:^(BOOL finished) {
		[self.helpViewController.view removeFromSuperview];
	}];
	
}

-(void)setupViewsAndEvents {
	[self.menuView addSubview:self.menuNavigationController.view];
    self.menuViewController.delegate = self;
	
    [self.contentView addSubview:self.mapViewNavigationController.view];
    [self.contentView bringSubviewToFront:self.mapViewNavigationController.view];
	if (self.helpViewController != nil){
		[self.contentView bringSubviewToFront:self.helpViewController.view];
	}
    [self.contentView addSubview:self.menuTab];
	
	self.mapViewNavigationController.view.layer.shadowOffset = CGSizeMake(-5, 0);
    self.mapViewNavigationController.view.layer.shadowRadius = 5;
    self.mapViewNavigationController.view.layer.shadowOpacity = 0.3;
	
	/*add shadow to menu tab too */
	self.menuTab.layer.shadowOffset = CGSizeMake(-5, 0);
    self.menuTab.layer.shadowRadius = 5;
    self.menuTab.layer.shadowOpacity = 0.3;
    self.menuTab.backgroundColor = [UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f];
    
    // round two corners of menu tab
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.menuTab.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(2.0, 2.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.menuTab.bounds;
    maskLayer.path = maskPath.CGPath;
    self.menuTab.layer.mask = maskLayer;
    
    
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
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAddNew:)
                                                 name:AddNewRackNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onShowCamera:)
                                                 name:ShowCameraNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(onPresentLogInView:)
												 name:PresentLogInViewNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onCloseAddNew:)
                                                 name:CloseAddNewNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onShowInstructions:)
                                                 name:ShowInstructionsNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onCloseInstructions:)
                                                 name:CloseInstructionsNotification object:nil];
	
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
    [UIView animateWithDuration:0.5  animations:^{
        [self showMainContentView];
    }];

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
    
    // need to get user again because user could've logged out
    if (index == 0 || ![CPUser currentUser])
    {
        [self.contentView addSubview:self.menuTab];
    }

    // force refresh
    [nvc viewWillAppear:YES];
    
    
}

#pragma mark minidetail methods

-(void)onOpenDetail:(NSNotification *) notification {
	CPRack *rack = (CPRack *)notification.userInfo[@"rack"];
	
	UIView *miniDetailView = self.miniDetail.view;
	miniDetailView.frame = CGRectMake(10, self.view.frame.size.height+10, self.view.frame.size.width-20, 100);
	[self.miniDetail setRack:rack];
	[self.contentView addSubview:miniDetailView];
	
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
		[self removePanView];
	} ];
}

-(void)onShowInstructions:(NSNotification *) notification {
	NSString *title = notification.userInfo[@"title"];
	self.instructionViewController = [[CPInstructionViewController alloc] init];
	self.instructionViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
	self.instructionViewController.view.layer.shadowRadius = 2;
	self.instructionViewController.view.layer.shadowOpacity = 0.3;
	self.instructionViewController.view.layer.shadowOffset = CGSizeMake(0, 0);
	self.instructionViewController.view.layer.cornerRadius = 2;
	
	UIView *miniDetailView = self.instructionViewController.view;
	miniDetailView.frame = CGRectMake(10, self.view.frame.size.height+10, self.view.frame.size.width-20, 100);
	self.instructionViewController.instructionLabel.text = title;
	[self.contentView addSubview:miniDetailView];
	
	[UIView animateWithDuration:0.15 animations:^{
		miniDetailView.frame = CGRectMake(10, self.view.frame.size.height-self.instructionViewController.view.frame.size.height-10, self.view.frame.size.width-20, self.instructionViewController.view.frame.size.height+10);
	} ];
}

-(void)onCloseInstructions:(NSNotification *) notification {
	if (self.instructionViewController != nil){
		UIView *miniDetailView = self.instructionViewController.view;
		
		[UIView animateWithDuration:0.15 animations:^{
			miniDetailView.frame = CGRectMake(10, self.view.frame.size.height+10, self.view.frame.size.width-20, self.instructionViewController.view.frame.size.height);
		} ];
	}
}

-(void)onShowCamera:(NSNotification *) notification {
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self.addParkingViewController;
	picker.allowsEditing = YES;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	
	[self presentViewController:picker animated:YES completion:NULL];
}

-(void)onUpdateWalkingTime:(NSNotification *) notification {
	NSTimeInterval time = [notification.userInfo[@"time"] doubleValue];
	[self.miniDetail setTime:time];
}

-(void)onAddNew:(NSNotification *) notification {
	
	CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([notification.userInfo[@"latitude"] doubleValue], [notification.userInfo[@"longitude"] doubleValue]);
	
	self.addParkingViewController = [[CPAddParkingViewController alloc] initWithLocation:coord];
	UIView *addNewView = self.addParkingViewController.view;
	addNewView.frame = CGRectMake(0, self.view.frame.size.height+10, self.view.frame.size.width, 100);
	//self.addNew.delegate = self;
	
	[self.contentView addSubview:addNewView];
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
	
	[UIView animateWithDuration:0.15 animations:^{
		addNewView.frame = CGRectMake(0, self.view.frame.size.height-400, self.view.frame.size.width, 400);
	}];

}
     
-(void)onPresentLogInView:(NSNotification *) notification {
    CPSignInViewController *logInView = [[CPSignInViewController alloc] initWithHint];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:logInView];
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)onCloseAddNew:(NSNotification *) notification {
	[self.mapViewController onCloseAddNew];
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
	
}


-(void)createPanView:(CGRect)rect {
	self.panView = [[UIView alloc] initWithFrame:rect];
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanDetails:)];
	NSLog(@"create pan view");
	[self.panView addGestureRecognizer:pan];
	[self.contentView addSubview:self.panView];
}

-(void)removePanView{
	[self.panView removeFromSuperview];
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
					
					CPRack *prevRack = [self.mapViewController getPrevRack:[self.miniDetail getRack]];
					[self.miniDetail setRack:prevRack];
					
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
					
					CPRack *nextRack = [self.mapViewController getNextRack:[self.miniDetail getRack]];
					[self.miniDetail setRack:nextRack];
					
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
