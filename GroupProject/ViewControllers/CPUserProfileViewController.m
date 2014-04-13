//
//  CPUserProfileViewController.m
//  GroupProject
//
//  Created by Eugenia Leong on 4/12/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPUserProfileViewController.h"
#import <Parse/Parse.h>

@interface CPUserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *firstname;
@property (weak, nonatomic) IBOutlet UILabel *lastname;
@property (weak, nonatomic) IBOutlet UILabel *currentcity;

@end

@implementation CPUserProfileViewController

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
    BOOL isLinkedToFacebook = [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]];
    NSLog(@"islinkedtofb: %d", isLinkedToFacebook);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
