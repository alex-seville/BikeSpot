//
//  CPHelpScreenViewController.m
//  GroupProject
//
//  Created by Alexander Seville on 4/27/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPHelpScreenViewController.h"
#import "CPMainViewController.h"

NSString * const CloseHelpView = @"CloseHelpView";

@interface CPHelpScreenViewController ()
- (IBAction)getStartedClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *getStartedBorder;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *texts;
@property (nonatomic, strong) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewControl;
@property (weak, nonatomic) IBOutlet UIPageControl *pageChangeControl;
@property (weak, nonatomic) IBOutlet UILabel *infoTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *getStartedButton;
- (IBAction)getStartedClick2:(id)sender;

@end

@implementation CPHelpScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.images = [[NSArray alloc] initWithObjects:@"help_screen2.png", @"help_screen3.png", nil];
		self.texts = [[NSArray alloc] initWithObjects:@"Search and find bike parking near you, add your favorite spots, and never worry about hunting for the perfect place for your bike!", @"Start by searching for the destination of your bike ride.  Click on the green pins to see nearby bike racks and the walking distance.", nil];
		self.buttons = [[NSArray alloc] initWithObjects:self.buttonTextLabel, self.getStartedButton, nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.buttonTextLabel.titleLabel.frame = CGRectMake(self.buttonTextLabel.titleLabel.frame.origin.x, self.buttonTextLabel.titleLabel.frame.origin.y, 100, self.buttonTextLabel.titleLabel.frame.size.height);
	
	self.view.backgroundColor = [UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f];
	self.getStartedBorder.layer.cornerRadius = 15;
	self.getStartedBorder.layer.borderColor = [UIColor whiteColor].CGColor;
	self.getStartedBorder.layer.borderWidth = 3;
	
	
    // Do any additional setup after loading the view from its nib.
	self.navigationController.navigationBar.hidden=YES;
	
	self.scrollViewControl.delegate = self;
	
	/* with help from http://iosmadesimple.blogspot.com/2013/01/page-control-for-switching-between-views.html */
	for (int i = 0; i < self.images.count; i++) {
		//We'll create an imageView object in every 'page' of our scrollView.
        CGRect frame;
        frame.origin.x = self.scrollViewControl.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollViewControl.frame.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:[self.images objectAtIndex:i]];
        [self.scrollViewControl addSubview:imageView];
    }
	[self.view sendSubviewToBack:self.scrollViewControl];
	//Set the content size of our scrollview according to the total width of our imageView objects.
    self.scrollViewControl.contentSize = CGSizeMake(self.scrollViewControl.frame.size.width * self.images.count, self.scrollViewControl.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getStartedClick:(id)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:true forKey:@"hasStarted"];
	NSLog(@"default get started: %hhd", [defaults boolForKey:@"hasStarted"]);
	[[NSNotificationCenter defaultCenter] postNotificationName:CloseHelpView object:self];
	
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollViewControl.frame.size.width;
    int page = floor((self.scrollViewControl.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageChangeControl.currentPage = page;
	if (page == 0){
		self.buttonTextLabel.hidden = false;
		self.getStartedButton.hidden = true;
	} else {
		self.buttonTextLabel.hidden = true;
		self.getStartedButton.hidden = false;
	}
	
	self.infoTextLabel.text = self.texts[page];
}


- (IBAction)getStartedClick2:(id)sender {
	[self getStartedClick:sender];
}
@end
