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
@property (nonatomic, strong) NSArray *icons;
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
        
        self.menuOptions = @[@"Home", @"Profile", @"About", @"Help", @"Log In/Out"];
        self.icons = @[@"green_home_small.png", @"green_profile_small.png", @"green_help.png", @"green_about.png", @"green_key_small.png"];
        
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
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f];
    
    // register cells
    UINib *menuCellNib = [UINib nibWithNibName:@"CPMenuCell" bundle:nil];
    [self.menuTableView registerNib:menuCellNib forCellReuseIdentifier:@"CPMenuCell"];
    
    self.menuTableView.dataSource = self;
    self.menuTableView.delegate = self;
    
    // This will remove extra separators from tableview
    self.menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

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
        // gray out profile option
        if (indexPath.row == 1 && !userLoggedIn)
        {
            [cell.optionLabel setTextColor:[UIColor grayColor]];
            cell.icon.image = [UIImage imageNamed:@"gray_profile_small.png"];
            cell.userInteractionEnabled = NO;
            
            return cell;
        }
    }
    
    cell.icon.image = [UIImage imageNamed:self.icons[indexPath.row]];
    return cell;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.menuOptions count];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.menuTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.delegate sender:self menuTapped:(int)indexPath.row];
    
    [self.menuTableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


@end
