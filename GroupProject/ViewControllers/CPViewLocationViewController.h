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

extern NSString * const ViewMoreRackDetails;
extern NSString * const UpdateMiniDetailNotification;
extern NSString * const CloseDetailNotification;
extern NSString * const UpdateWalkingDistanceDetailNotification;

@interface CPViewLocationViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, CPAddParkingViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *annotations;

@end
