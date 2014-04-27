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

@end

@implementation CPHelpScreenViewController

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
	self.navigationController.navigationBar.hidden=YES;
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
@end
