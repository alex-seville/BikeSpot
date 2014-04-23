//
//  CPRackMiniDetailViewController.m
//  GroupProject
//
//  Created by Alexander Seville on 4/12/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPRackMiniDetailViewController.h"
#import "CPRack.h"



@interface CPRackMiniDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rackNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *rackDescriptionLabel;

- (IBAction)onPan:(UIPanGestureRecognizer *)sender;
@property (nonatomic, assign) double startPan;
@property (nonatomic, assign) double startHeight;
@property (nonatomic, assign) double startY;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


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

- (void) setRack:(CPRack *)rack {
    self.rackNameLabel.text = rack.name;
	self.rackDescriptionLabel.text = rack.address;
}

- (void) setTime:(NSTimeInterval)time {
	if (time < 60){
		self.timeLabel.text = [NSString stringWithFormat:@"Walking time: %.0f seconds", time];
	}else{
		self.timeLabel.text = [NSString stringWithFormat:@"Walking time: %.0f minutes", time / 60];
	}
}

- (IBAction)onPan:(UIPanGestureRecognizer *)sender {
	CGPoint point = [sender locationInView:self.view];
	CGPoint velocity = [sender velocityInView:self.view];
	
	
	if (sender.state == UIGestureRecognizerStateBegan){
		//CGRect viewFrame = self.view.frame;
		//self.startHeight =viewFrame.size.height;
		//self.startY =viewFrame.origin.y;
	}
	else if (sender.state == UIGestureRecognizerStateChanged){
		CGRect viewFrame = self.view.frame;
		
		//double increase = self.startPan-point.y;
		
		NSLog(@"origin, height: %f %f", point.y, self.view.frame.size.height);
		
		//if (viewFrame.origin.y  > 300 ){
		
			viewFrame.origin.y += point.y;
			viewFrame.size.height -= point.y;
			
			
			
			self.view.frame = viewFrame;
		//}
	}else if (sender.state == UIGestureRecognizerStateEnded){
		CGRect viewFrame = self.view.frame;
		if (velocity.y > 0){
			
			viewFrame.origin.y = 0;
			viewFrame.size.height = 0;
		}else{
			viewFrame.origin.y = 300;
			viewFrame.size.height = self.view.frame.size.height-300;
		}
	}
	
}
@end
