//
//  CPViewLocationViewController.m
//  GroupProject
//
//  Created by Alexander Seville on 4/7/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPViewLocationViewController.h"
#import <MapKit/MapKit.h>
#import "CPRack.h"
#include <CoreLocation/CoreLocation.h>
#import "CPRackAnnotation.h"
#import "CPRackMiniDetailViewController.h"

@interface CPViewLocationViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mainMapView;


@end

@implementation CPViewLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        /* this will be moved into mainViewController when it's ready */
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(viewMoreDetails:)
                                                     name:ViewMoreRackDetails
                                                   object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainMapView.delegate = self;
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)importPins
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:fileData options:kNilOptions error:nil];
    
     NSArray *data = [json objectForKey:@"data"];
    
   for (NSArray *row in data) {
       double latitude = [[[row objectAtIndex:22]objectAtIndex:1] doubleValue];
       double longitude = [[[row objectAtIndex:22]objectAtIndex:2] doubleValue];
       
       
       CPRack *rack = [[CPRack alloc] initWithDictionary:@{
                                @"name": [row objectAtIndex:8],
                                @"latitude": [[NSNumber alloc] initWithDouble:latitude],
                                @"longitude": [[NSNumber alloc] initWithDouble:longitude]
                            }];
       
       
       CLLocationCoordinate2D coordinate;
       coordinate.latitude = latitude;
       coordinate.longitude = longitude;
       
       CPRackAnnotation *annotation = [[CPRackAnnotation alloc] initWithTitle:rack.name Location:coordinate];
       [self.mainMapView addAnnotation:annotation];
	}
}

#pragma mark - mapview delegate methods

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    
    CLLocationCoordinate2D coord = self.mainMapView.userLocation.location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
    
    [self.mainMapView setRegion:region animated:YES];
    
    [self importPins];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                     reuseIdentifier:@"RackAnnotation"];
    annotationView.pinColor = MKPinAnnotationColorRed;
    annotationView.canShowCallout = YES;
    annotationView.draggable = YES;
    
    annotationView.animatesDrop = NO;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    CPRackMiniDetailViewController *miniDetail = [[CPRackMiniDetailViewController alloc] init];
    UIView *miniDetailView = miniDetail.view;
    miniDetailView.frame = CGRectMake(0, self.view.frame.size.height+10, self.view.frame.size.width, 100);
    [miniDetail setName:view.annotation.title];
    [self.view addSubview:miniDetailView];

    [UIView animateWithDuration:0.15 animations:^{
        miniDetailView.frame = CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 100);
    } ];
    
    
}

-(void)viewMoreDetails:(NSNotification *) notification {
    NSLog(@"view more details %@", (NSString *)notification.userInfo[@"name"]);
    
   /* do navigating */
}



@end
