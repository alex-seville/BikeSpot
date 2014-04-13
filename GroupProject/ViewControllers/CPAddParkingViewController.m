//
//  CPAddParkingViewController.m
//  GroupProject
//
//  Created by Eugenia Leong on 4/12/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPAddParkingViewController.h"

@interface CPAddParkingViewController ()

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

- (void)addNewParking
{
    /*
     CPRack *testObject = [[CPRack alloc] initWithDictionary:@{
     @"name": @"Test Bike Rack",
     @"isInGarage": @NO,
     @"isCommercial": @YES,
     @"safetyRating": @3,
     @"longDescription": @"This is a long description",
     @"rackPhotoName": @"test.png",
     @"geoLocation": [[PFGeoPoint alloc] init]
     }];
     
     [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
     NSString *objectId = testObject.objectId;
     PFQuery *query = [PFQuery queryWithClassName:@"CPRack"];
     [query getObjectInBackgroundWithId:objectId block:^(PFObject *bikeRack, NSError *error) {
     // Do something with the returned PFObject in the bikeRack variable.
     NSLog(@"%@", (CPRack *)bikeRack);
     }];
     }];
     */
}

@end
