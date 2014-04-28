//
//  CPViewLocationViewController.h
//  GroupProject
//
//  Created by Alexander Seville on 4/7/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CPAddParkingViewController.h"
#import "CPRack.h"

extern NSString * const ViewMoreRackDetails;
extern NSString * const UpdateMiniDetailNotification;
extern NSString * const CloseDetailNotification;
extern NSString * const UpdateWalkingDistanceDetailNotification;
extern NSString * const AddNewRackNotification;
extern NSString * const PresentLogInViewNotification;

@interface CPViewLocationViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, CPAddParkingViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *annotations;

- (CPRack *)getNextRack:(CPRack *)rack;
- (CPRack *)getPrevRack:(CPRack *)rack;
- (void) onCloseAddNew;

@end
