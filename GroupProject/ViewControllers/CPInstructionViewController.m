//
//  CPInstructionViewController.m
//  GroupProject
//
//  Created by Alexander Seville on 4/27/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPInstructionViewController.h"

@interface CPInstructionViewController ()



@end

@implementation CPInstructionViewController

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
	self.instructionLabel.textColor = [UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f];

	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
