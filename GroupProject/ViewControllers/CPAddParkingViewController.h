//
//  CPAddParkingViewController.h
//  GroupProject
//
//  Created by Eugenia Leong on 4/19/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class CPAddParkingViewController;

@protocol CPAddParkingViewControllerDelegate <NSObject>
@required
-(void)didAddParkingViewClose:(CPAddParkingViewController *)sender;
@end

@interface CPAddParkingViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, weak) id<CPAddParkingViewControllerDelegate> delegate;

extern NSString * const ShowCameraNotification;
extern NSString * const CloseAddNewNotification;

-(id)initWithLocation:(CLLocationCoordinate2D)location;
@end
