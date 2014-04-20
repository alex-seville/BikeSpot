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
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UIStepper *parkingNumberControl;
@property (weak, nonatomic) IBOutlet UILabel *parkingNumberField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *garageControl;
- (IBAction)onSubmit:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onTap:(UITapGestureRecognizer *)sender;
- (IBAction)onStepperValueChanged:(id)sender;



@end

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

- (IBAction)onSubmit:(id)sender {

    if (![self validateFields]) {
        return;
    }

    
    CPRack *newBikeRack = [[CPRack alloc] initWithDictionary:@{
                                                              @"name": self.nameField.text,
                                                              @"isInGarage": self.garageControl.selectedSegmentIndex == 0?@YES:@NO,
                                                              @"isCommercial": @NO,
                                                              @"safetyRating": @3,
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
        }
    }];
}

- (IBAction)onCancel:(id)sender {
    
    /* enable map interactions */
    //[self.view.superview setUserInteractionEnabled:true];
    
    [UIView animateWithDuration:0.15 animations:^{
        [self.view removeFromSuperview];

    } ];
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)onStepperValueChanged:(id)sender {
    self.parkingNumberField.text = [NSString stringWithFormat:@"%d", (int)self.parkingNumberControl.value];
}

- (BOOL)validateFields {
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
