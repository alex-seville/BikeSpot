//
//  CPAddParkingViewController.m
//  GroupProject
//
//  Created by Eugenia Leong on 4/19/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPAddParkingViewController.h"
#import "CPRack.h"
#import "CPUser.h"

@interface CPAddParkingViewController ()
@property (weak, nonatomic) UIColor *themeColor;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UILabel *parkingNumberField;
@property (weak, nonatomic) IBOutlet UIButton *lessSpotsButton;
@property (weak, nonatomic) IBOutlet UIButton *moreSpotsButton;
@property (weak, nonatomic) IBOutlet UILabel *viewTitle;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *garageButton;
@property (assign, nonatomic) BOOL isInGarage;
@property (assign, nonatomic) int selectedSafetyRating;
@property (weak, nonatomic) IBOutlet UIView *fakeNavBar;
@property (weak, nonatomic) IBOutlet UIView *parkingSpotsView;
- (IBAction)onSubmit:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onTap:(UITapGestureRecognizer *)sender;
- (IBAction)onLessSpots:(id)sender;
- (IBAction)onMoreSpots:(id)sender;
- (IBAction)onGarage:(id)sender;
- (IBAction)onSafety1:(id)sender;
- (IBAction)onSafety2:(id)sender;
- (IBAction)onSafety3:(id)sender;
- (IBAction)onSafety4:(id)sender;
- (IBAction)onSafety5:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *safety1;
@property (strong, nonatomic) IBOutlet UIButton *safety2;
@property (strong, nonatomic) IBOutlet UIButton *safety3;
@property (strong, nonatomic) IBOutlet UIButton *safety4;
@property (strong, nonatomic) IBOutlet UIButton *safety5;
@property (strong, nonatomic) NSArray *safetyRatingButtons;

@end

NSString const *IN_GARAGE = @"In garage";
NSString const *NOT_IN_GARAGE = @"Not in garage";

@implementation CPAddParkingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithLocation:(CLLocationCoordinate2D)location{
    self = [super init];
    if (self){
        _coordinate = location;
        _themeColor = [UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f]; // why doesn't this work?
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.safetyRatingButtons = @[self.safety1, self.safety2, self.safety3, self.safety4, self.safety5];
    
    self.viewTitle.textColor = [UIColor whiteColor];
    self.fakeNavBar.backgroundColor = [UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f];
    
    [self.addPhotoButton setTitleColor:[UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.garageButton setTitleColor:[UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    // set garage button attributes
    [[self.garageButton layer] setBorderWidth:1.0f];
    [[self.garageButton layer] setCornerRadius:2];
    [[self.garageButton layer] setBorderColor:[UIColor grayColor].CGColor];
    self.isInGarage = YES;
    
    // view that outlines number of parking spots control
    [[self.parkingSpotsView layer] setBorderWidth:1.0f];
    [[self.parkingSpotsView layer] setCornerRadius:2];
    [[self.parkingSpotsView layer] setBorderColor: [UIColor grayColor].CGColor];
    [[self.parkingSpotsView layer] setBackgroundColor:[UIColor clearColor].CGColor];
    
    // name field attribues
    [[self.nameField layer] setCornerRadius:2];
    [[self.nameField layer] masksToBounds];
    [[self.nameField layer] setBorderColor:[UIColor grayColor].CGColor];
    
    // description field attributes
    [[self.descriptionField layer] setCornerRadius:2];
    [[self.descriptionField layer] masksToBounds];
    [[self.descriptionField layer] setBorderColor:[UIColor grayColor].CGColor];
    

    for (int i = 0; i < [self.safetyRatingButtons count]; i++)
    {
        UIButton *button = self.safetyRatingButtons[i];
        [button setBackgroundImage:[UIImage imageNamed:@"gray_lock_small.png"] forState:UIControlStateNormal];
        [button setTitle:@"" forState:UIControlStateNormal];
    }
    
    // set add photo image view attributes
    [[self.imageView layer] setBorderWidth: 1.0f];
    [[self.imageView layer] setCornerRadius:2];
    [[self.imageView layer] setBorderColor:[UIColor grayColor].CGColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSubmit:(id)sender {

    if (![self validateFields]) {
        return;
    }

    
    CPRack *newBikeRack = [[CPRack alloc] initWithDictionary:@{
                                                              @"name": self.nameField.text,
                                                              @"isInGarage": self.isInGarage?@YES:@NO,
                                                              @"isCommercial": @NO,
                                                              @"safetyRating": [NSNumber numberWithInt:self.selectedSafetyRating],
                                                              @"longDescription": self.descriptionField.text,
                                                              @"rackPhotoName": @"test.png",
                                                              @"longitude": [NSNumber numberWithDouble:self.coordinate.longitude],
                                                              @"latitude": [NSNumber numberWithDouble:self.coordinate.latitude],
                                                              @"createdBy:":[[CPUser currentUser] username],
                                                              @"numSpots": [NSNumber numberWithInt:[self.parkingNumberField.text intValue]]
                                                              }];
    
    [newBikeRack saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"You've added a new bike rack." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [successAlert show];
            // change to close after alert 
            [self closeView];
            
        }
    }];
}

- (IBAction)onCancel:(id)sender {
    
    [self closeView];

}

- (void) closeView {
    [UIView animateWithDuration:0.15 animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.size.height+100, self.view.frame.size.width, 100);
        
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self.delegate didAddParkingViewClose:self];
    }];
}
- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)onLessSpots:(id)sender {
}

- (IBAction)onMoreSpots:(id)sender {
}

- (IBAction)onGarage:(id)sender {
    if (self.isInGarage)
    {
        [self.garageButton setTitle:@"Not in garage" forState:UIControlStateNormal];
        self.isInGarage = NO;
    }
    else
    {
        [self.garageButton setTitle:@"In garage" forState:UIControlStateNormal];
        self.isInGarage = YES;
    }
}

- (IBAction)onSafety1:(id)sender {
    [self setSafetyRating:1];
}

- (IBAction)onSafety2:(id)sender {
    [self setSafetyRating:2];
}

- (IBAction)onSafety3:(id)sender {
    [self setSafetyRating:3];
}

- (IBAction)onSafety4:(id)sender {
    [self setSafetyRating:4];
}

- (IBAction)onSafety5:(id)sender {
    [self setSafetyRating:5];
}

- (void)setSafetyRating:(int)value {
    // TODO animate?
    int i = 0;
    for (i = 0; i < [self.safetyRatingButtons count]; i++)
    {
        UIButton *button = self.safetyRatingButtons[i];
        if (i < value)
        {
            [button setBackgroundImage:[UIImage imageNamed:@"green_lock_small.png"] forState:UIControlStateNormal];
        }
        else
        {
            [button setBackgroundImage:[UIImage imageNamed:@"gray_lock_small.png"] forState:UIControlStateNormal];
        }

    }
    self.selectedSafetyRating = value;
}

- (BOOL)validateFields {
    // TODO or just grey out submit button
    // replace with log in vc
    if (![CPUser currentUser]) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Log In!" message:@"Please log in to add a new bike rack." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
        return false;
    }
    
    NSString *trimmedName = [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([trimmedName length] == 0) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill in a bike rack name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
        return false;
    }
    
    NSString *trimmedDescription = [self.descriptionField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([trimmedDescription length] == 0) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill in a bike rack description." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
        return false;
    }
    
    return true;
    
}

@end
