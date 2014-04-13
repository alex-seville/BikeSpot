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
        
        self.loggedInMenuOptions = @[@"Home", @"Profile", @"Add New Parking Spot", @"Settings", @"Log out"];
        self.loggedOutMenuOptions = @[@"Home", @"Log In"];
        
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
    
    // display user profile cell
    
    CPMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CPMenuCell" forIndexPath:indexPath];
    if ([CPUser currentUser])
    {
        cell.optionLabel.text = self.loggedInMenuOptions[indexPath.row];
    }
    else
    {
        cell.optionLabel.text = self.loggedOutMenuOptions[indexPath.row];
    }
    
    return cell;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([CPUser currentUser])
    {
        return [self.loggedInMenuOptions count];
    }
    else
    {
        return [self.loggedOutMenuOptions count];
    }

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
