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

- (IBAction)onPan:(UIPanGestureRecognizer *)sender;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) CPRack *rack;


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
	self.rackNameLabel.textColor = [UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setRack:(CPRack *)rack {
	_rack = rack;
    self.rackNameLabel.text = rack.name;
	self.rackDescriptionLabel.text = rack.address;
	self.timeLabel.text = @"";
}

- (void) setTime:(NSTimeInterval)time {
	if (time < 60){
		self.timeLabel.text = [NSString stringWithFormat:@"Walking time: %.0f seconds", time];
	}else{
		self.timeLabel.text = [NSString stringWithFormat:@"Walking time: %.0f minutes", time / 60];
	}
}

- (CPRack *) getRack{
	return _rack;
}

/* panning upwards reveals more details */
/* panning side-to-side should show another point */
/*
- (IBAction)onPan:(UIPanGestureRecognizer *)sender {
	CGPoint point = [sender locationInView:self.view];
	CGPoint velocity = [sender velocityInView:self.view];
	
	
	if (sender.state == UIGestureRecognizerStateChanged){
		CGRect viewFrame = self.view.frame;
		
		if (viewFrame.size.height-point.y >= 100 ){
		
			viewFrame.origin.y += point.y;
			viewFrame.size.height -= point.y;
			self.view.frame = viewFrame;
			
		}else{
			
			viewFrame.origin.x += point.x;
			
			
		}
		
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
 */

@end
