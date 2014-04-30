//
//  CPSwipeInstructionsViewController.m
//  GroupProject
//
//  Created by Alexander Seville on 4/29/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPSwipeInstructionsViewController.h"

NSString * const CloseHelpDetailNotification = @"CloseHelpDetailNotification";

@interface CPSwipeInstructionsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
- (IBAction)closeBtnAction:(id)sender;



@end

@implementation CPSwipeInstructionsViewController

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
	self.view.layer.shadowColor = [UIColor blackColor].CGColor;
	self.view.layer.shadowRadius = 2;
	self.view.layer.shadowOpacity = 0.3;
	self.view.layer.shadowOffset = CGSizeMake(0, 0);
	self.view.layer.cornerRadius = 2;
	
	self.closeBtn.titleLabel.textColor = [UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeBtnAction:(id)sender {
	NSLog(@"button clicked");
	[[NSNotificationCenter defaultCenter] postNotificationName:CloseHelpDetailNotification object:self];
	
}
@end
