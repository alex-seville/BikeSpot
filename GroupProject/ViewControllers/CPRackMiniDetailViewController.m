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
- (IBAction)viewMoreButton:(id)sender;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setName:(NSString *)name {
    self.rackNameLabel.text = name;
}

- (IBAction)viewMoreButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:ViewMoreRackDetails object:self userInfo:@{@"name": self.rackNameLabel.text}];
}
@end
