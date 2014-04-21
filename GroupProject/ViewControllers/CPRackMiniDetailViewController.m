//
//  CPRackMiniDetailViewController.m
//  GroupProject
//
//  Created by Alexander Seville on 4/12/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPRackMiniDetailViewController.h"

NSString * const ViewMoreRackDetails = @"ViewMoreRackDetails";

@interface CPRackMiniDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rackNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rackDescriptionLabel;

- (IBAction)onPan:(UIPanGestureRecognizer *)sender;
@property (nonatomic, assign) double startPan;
@property (nonatomic, assign) double startHeight;
@property (nonatomic, assign) double startY;



@end

@implementation CPRackMiniDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.view.layer.cornerRadius = 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setName:(NSString *)name {
    self.rackNameLabel.text = name;
}



- (IBAction)onPan:(UIPanGestureRecognizer *)sender {
	CGPoint point = [sender locationInView:self.view];
	CGPoint velocity = [sender velocityInView:self.view];
	
	
	if (sender.state == UIGestureRecognizerStateBegan){
		CGRect viewFrame = self.view.frame;
		self.startHeight =viewFrame.size.height;
		self.startY =viewFrame.origin.y;
	}
	else if (sender.state == UIGestureRecognizerStateChanged){
		CGRect viewFrame = self.view.frame;
		
		double increase = self.startPan-point.y;
		
		NSLog(@"origin, height: %d %d", (viewFrame.origin.y-increase), (viewFrame.size.height+increase));
		
		if (viewFrame.origin.y-increase  > 300 &&
			viewFrame.size.height+increase > 100){
		
			viewFrame.origin.y -= increase;
			
			viewFrame.size.height += increase;
			self.view.frame = viewFrame;
		}
	}else if (sender.state == UIGestureRecognizerStateEnded){
		CGRect viewFrame = self.view.frame;
		if (velocity.y > 0){
			
			viewFrame.origin.y = self.startY;
			viewFrame.size.height = self.startHeight;
		}else{
			viewFrame.origin.y = self.startY/2;
			viewFrame.size.height = 2 * self.startHeight;
		}
	}
	self.startPan = point.y;
}
@end
