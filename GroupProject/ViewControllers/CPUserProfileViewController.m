//
//  CPUserProfileViewController.m
//  GroupProject
//
//  Created by Eugenia Leong on 4/12/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPUserProfileViewController.h"
#import "CPUser.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>


@interface CPUserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *currentcity;
@property (weak, nonatomic) IBOutlet UILabel *memberSince;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *dividerBar;

@end

@implementation CPUserProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Me";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CPUser *currentUser = [CPUser currentUser];
    BOOL isLinkedToFacebook = [PFFacebookUtils isLinkedWithUser:currentUser];
    
    self.name.textColor = [UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f];
    self.name.text = @"";
    self.currentcity.text = @"";
    self.memberSince.text = @"";
    
    // round user profile image
    self.profileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 2;
    self.profileImage.layer.borderColor = [[UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f] CGColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f];
    
    //self.dividerBar.backgroundColor = [UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f];
    self.dividerBar.layer.shadowColor = [UIColor blackColor].CGColor;
	self.dividerBar.layer.shadowRadius = 2;
	self.dividerBar.layer.shadowOpacity = 0.3;
	self.dividerBar.layer.shadowOffset = CGSizeMake(0, 0);
	self.dividerBar.layer.cornerRadius = 2;
    
    if (isLinkedToFacebook)
    {
        // Create request for user's Facebook data
        FBRequest *request = [FBRequest requestForMe];
        
        // Send request to Facebook
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                NSLog(@"%@", userData);
                NSString *facebookID = userData[@"id"];
                self.name.text = userData[@"name"];
                self.currentcity.text = userData[@"location"][@"name"];
                                
                NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                
                [self.profileImage setImageWithURL:pictureURL placeholderImage:nil];

            }
        }];
        
        // Get createdAt from Parse
        NSString *dateString = [NSDateFormatter localizedStringFromDate: [CPUser currentUser].createdAt
                                                              dateStyle:NSDateFormatterLongStyle
                                                              timeStyle:NSDateFormatterNoStyle];
        self.memberSince.text = dateString;
        
    }
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onEdit:(id)sender
{
    
}

@end
