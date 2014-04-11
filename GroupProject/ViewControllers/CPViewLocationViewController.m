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

@interface CPViewLocationViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mainMapView;

@end

@implementation CPViewLocationViewController

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
    
    self.mainMapView.showsUserLocation = YES;
    self.mainMapView.delegate = self;
    
   
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)stuff
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:fileData options:kNilOptions error:nil];
    
     NSArray *data = [json objectForKey:@"data"];
    
   for (NSArray *row in data) {
       double latitude = [[[row objectAtIndex:22]objectAtIndex:1] doubleValue];
       double longitude = [[[row objectAtIndex:22]objectAtIndex:2] doubleValue];
       
       
       CPRack *annotation = [[CPRack alloc] initWithDictionary:@{
                                @"name": [row objectAtIndex:8],
                                @"latitude": [[NSNumber alloc] initWithDouble:latitude],
                                @"longitude": [[NSNumber alloc] initWithDouble:longitude]
                            }];
       CLLocationCoordinate2D coordinate;
       coordinate.latitude = latitude;
       coordinate.longitude = longitude;
       MKPointAnnotation* pointAnnotation = [[MKPointAnnotation alloc] init];
       pointAnnotation.coordinate = coordinate;
       
       [self.mainMapView addAnnotation:pointAnnotation];
	}
}

#pragma mark - mapview delegate methods

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [self.mainMapView setRegion:region animated:YES];
    [self stuff];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    static NSString *GeoPointAnnotationIdentifier = @"RedPin";
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                     reuseIdentifier:GeoPointAnnotationIdentifier];
    annotationView.pinColor = MKPinAnnotationColorRed;
    annotationView.canShowCallout = YES;
    annotationView.draggable = YES;
    annotationView.animatesDrop = YES;
    
    return annotationView;
}

@end
