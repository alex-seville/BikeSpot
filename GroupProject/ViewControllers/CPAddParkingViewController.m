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

NSString * const ShowCameraNotification = @"ShowCameraNotification";

@interface CPAddParkingViewController ()
@property (assign, nonatomic) BOOL isInGarage;
@property (assign, nonatomic) int selectedSafetyRating;
@property (assign, nonatomic) int numSpots;

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
@property (weak, nonatomic) IBOutlet UIView *fakeNavBar;
@property (weak, nonatomic) IBOutlet UIView *parkingSpotsView;
@property (weak, nonatomic) IBOutlet UIView *safetyRatingView;
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
- (IBAction)onImageViewTapped:(id)sender;
- (IBAction)onAddPhoto:(id)sender;

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
        //_themeColor = [UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f]; // why doesn't this work?
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
    self.isInGarage = NO;
    
    // view that outlines number of parking spots control
    [[self.parkingSpotsView layer] setBorderWidth:1.0f];
    [[self.parkingSpotsView layer] setCornerRadius:2];
    [[self.parkingSpotsView layer] setBorderColor: [UIColor grayColor].CGColor];
    [[self.parkingSpotsView layer] setBackgroundColor:[UIColor clearColor].CGColor];
    
    // view that outlines safety rating selection
    [[self.safetyRatingView layer] setBorderWidth:1.0f];
    [[self.safetyRatingView layer] setCornerRadius:2];
    [[self.safetyRatingView layer] setBorderColor: [UIColor grayColor].CGColor];
    [[self.safetyRatingView layer] setBackgroundColor:[UIColor clearColor].CGColor];
    
    // name field attribues
    [[self.nameField layer] setCornerRadius:2];
    [[self.nameField layer] masksToBounds];
    [[self.nameField layer] setBorderColor:[UIColor grayColor].CGColor];
    
    // description field attributes
    [[self.descriptionField layer] setCornerRadius:2];
    [[self.descriptionField layer] masksToBounds];
    [[self.descriptionField layer] setBorderColor:[UIColor grayColor].CGColor];
    
    self.numSpots = 1;
    [self setParkingSpotsButtons];

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
    
    NSString *imageFileName = @"";
    PFFile *imageFile = nil;
    if (self.imageView.image)
    {
        NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.05f);
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMMMddyyyyHHmmssz"];
        imageFileName = [format stringFromDate:[NSDate date]];
        imageFile = [PFFile fileWithName:imageFileName data:imageData];
        
        // Save PFFile
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error)
            {
                
            }
            else
            {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        } progressBlock:^(int percentDone) {
            // Update your progress spinner here. percentDone will be between 0 and 100.
            //HUD.progress = (float)percentDone/100;
        }];
    }

    
    CPRack *newBikeRack = [[CPRack alloc] initWithDictionary:@{
                                                              @"name": self.nameField.text,
                                                              @"isInGarage": self.isInGarage?@YES:@NO,
                                                              @"isCommercial": @NO,
                                                              @"safetyRating": [NSNumber numberWithInt:self.selectedSafetyRating],
                                                              @"longDescription": self.descriptionField.text,
                                                              @"rackPhotoName": imageFileName,
                                                              @"rackPhoto": imageFile,
                                                              @"longitude": [NSNumber numberWithDouble:self.coordinate.longitude],
                                                              @"latitude": [NSNumber numberWithDouble:self.coordinate.latitude],
                                                              @"createdBy:":[CPUser currentUser],
                                                              @"numSpots": [NSNumber numberWithInt:self.numSpots]
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
    if (self.numSpots <= 1)
    {
        return;
    }
    else
    {
        self.numSpots--;
        [self setParkingSpotsNumber];
        [self setParkingSpotsButtons];
    }
}

- (IBAction)onMoreSpots:(id)sender {
    if (self.numSpots >= 20)
    {
        return;
    }
    else
    {
        self.numSpots++;
        [self setParkingSpotsNumber];
        [self setParkingSpotsButtons];
    }
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

- (IBAction)onImageViewTapped:(id)sender {
    [self openCamera];
}

- (IBAction)onAddPhoto:(id)sender {
    [self openCamera];
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
    
    if (!self.imageView.image) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please take a photo of the bike rack." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
        return false;
    }
    
    return true;
    
}

- (void)setParkingSpotsNumber {
    if (self.numSpots == 1)
    {
        self.parkingNumberField.text = [NSString stringWithFormat:@"%d spot", self.numSpots];
    }
    else
    {
        self.parkingNumberField.text = [NSString stringWithFormat:@"%d spots", self.numSpots];
    }

}

- (void)setParkingSpotsButtons{
    
    if (self.numSpots <= 1)
    {
        [self.lessSpotsButton setBackgroundImage:[UIImage imageNamed:@"gray_less_small"] forState:UIControlStateNormal];
        [self.lessSpotsButton setEnabled:NO];
    }
    else if (self.numSpots >= 20)
    {
        [self.moreSpotsButton setBackgroundImage:[UIImage imageNamed:@"gray_more_small"] forState:UIControlStateNormal];
        [self.moreSpotsButton setEnabled:NO];
    }
    else
    {
        if (!self.lessSpotsButton.enabled)
        {
            [self.lessSpotsButton setBackgroundImage:[UIImage imageNamed:@"green_less_small"] forState:UIControlStateNormal];
            [self.lessSpotsButton setEnabled:YES];
        }

        if (!self.moreSpotsButton.enabled)
        {
            [self.moreSpotsButton setBackgroundImage:[UIImage imageNamed:@"green_more_small"] forState:UIControlStateNormal];
            [self.moreSpotsButton setEnabled:YES];
        }
    }
}

- (void)openCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *cameraAlert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                              message:@"Device has no camera."
                                                             delegate:nil
                                                    cancelButtonTitle:@"Ok"
                                                    otherButtonTitles: nil];
        
        [cameraAlert show];
        
    }
    else
    {
		//let the main view controller present it
		[[NSNotificationCenter defaultCenter] postNotificationName:ShowCameraNotification object:self];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    [self.addPhotoButton setTitle:@"" forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
	   
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
