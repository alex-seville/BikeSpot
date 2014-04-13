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

#define iphoneScaleFactorLatitude   9.0
#define iphoneScaleFactorLongitude  11.0

@interface CPViewLocationViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mainMapView;
@property (nonatomic, strong) NSMutableArray *annotations;


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
    
    self.mainMapView.delegate = self;
    self.annotations = [[NSMutableArray alloc] init];
		
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
    [self.annotations removeAllObjects];
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
       //[self.mainMapView addAnnotation:annotation];
	   [self.annotations addObject:annotation];
	}
	[self.mainMapView addAnnotations:[self filterAnnotations:self.annotations modifyMap:false]];
}

#pragma mark - mapview delegate methods

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    
    CLLocationCoordinate2D coord = self.mainMapView.userLocation.location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
    
    [self.mainMapView setRegion:region animated:YES];
    
    [self importPins];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"RackAnnotation"];
	
	if(!annotationView){
		annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"RackAnnotation"];
	}
	
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

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
	[self filterAnnotations:self.annotations modifyMap:true];
}


/* from: https://github.com/kviksilver/MKMapview-annotation-grouping/blob/master/mapView/mapViewViewController.m */
-(NSArray *)filterAnnotations:(NSArray *)racksToFilter modifyMap:(BOOL)modifyMap{
    float latDelta=self.mainMapView.region.span.latitudeDelta/iphoneScaleFactorLatitude;
    float longDelta=self.mainMapView.region.span.longitudeDelta/iphoneScaleFactorLongitude;
	
    NSMutableArray *racksToShow=[[NSMutableArray alloc] initWithCapacity:0];
	
    for (int i=0; i<[racksToFilter count]; i++) {
        CPRackAnnotation *checkingLocation=[racksToFilter objectAtIndex:i];
        CLLocationDegrees latitude = checkingLocation.coordinate.latitude;
        CLLocationDegrees longitude = checkingLocation.coordinate.longitude;
		
        bool found=FALSE;
        for (CPRackAnnotation *tempPlacemark in racksToShow) {
            if(fabs(tempPlacemark.coordinate.latitude-latitude) < latDelta &&
               fabs(tempPlacemark.coordinate.longitude-longitude) <longDelta ){
                found=TRUE;
				if (modifyMap){
					[self.mainMapView removeAnnotation:checkingLocation];
				}
                break;
            }
        }
        if (!found) {
            [racksToShow addObject:checkingLocation];
            if (modifyMap){
				[self.mainMapView addAnnotation:checkingLocation];
			}
        }
		
    }
    return racksToShow;
}





@end
