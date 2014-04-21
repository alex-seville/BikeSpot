//
//  CPHamburgerMenuViewController.m
//  GroupProject
//
//  Created by Alexander Seville on 4/7/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPHamburgerMenuViewController.h"
#import "CPUserProfileViewController.h"
#import "CPMenuCell.h"
#import "CPUser.h"

@interface CPHamburgerMenuViewController ()
@property (nonatomic, strong) NSArray *loggedInMenuOptions;
@property (nonatomic, strong) NSArray *loggedOutMenuOptions;
@property (nonatomic, strong) NSArray *menuOptions;
@property (nonatomic, strong) CPUserProfileViewController *userProfileViewController;
@property (nonatomic, strong) UINavigationController *userProfileNavigationController;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@end

@implementation CPHamburgerMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Menu";
        
        self.menuOptions = @[@"Home", @"Profile", @"Settings", @"Log In/Out"];
        
        // user profile view
        self.userProfileViewController = [[CPUserProfileViewController alloc] init];
        self.userProfileNavigationController = [[UINavigationController alloc] initWithRootViewController:self.userProfileViewController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.menuTableView.dataSource = self;
    self.menuTableView.delegate = self;
    self.menuTableView.scrollEnabled = NO;
    
    // register cells
    UINib *menuCellNib = [UINib nibWithNibName:@"CPMenuCell" bundle:nil];
    [self.menuTableView registerNib:menuCellNib forCellReuseIdentifier:@"CPMenuCell"];
    
    self.menuTableView.dataSource = self;
    self.menuTableView.delegate = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CPMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CPMenuCell" forIndexPath:indexPath];
    
    // Log in/ log out option if this is the last cell
    BOOL userLoggedIn = [CPUser currentUser]?YES:NO;
    
    if (indexPath.row == [self.menuOptions count]-1)
    {
        if (!userLoggedIn)
        {
            cell.optionLabel.text = @"Log In";
        }
        else
        {
            cell.optionLabel.text = @"Log Out";
        }
    }
    else
    {
        cell.optionLabel.text = self.menuOptions[indexPath.row];
        if (indexPath.row > 0 && !userLoggedIn)
        {
            [cell.optionLabel setTextColor:[UIColor grayColor]];
            cell.userInteractionEnabled = NO;
        }
    }
    
    return cell;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.menuOptions count];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.menuTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.delegate sender:self menuTapped:indexPath.row];
    
    [self.menuTableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


@end
