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
#import "CPAnnotationGroup.h"
#import <Parse/Parse.h>
#import "CPParseClient.h"
#import "CPAddParkingViewController.h"

#define iphoneScaleFactorLatitude   9.0
#define iphoneScaleFactorLongitude  11.0

@interface CPViewLocationViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mainMapView;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) NSMutableArray *racks;

/* this may have to be refactored */
@property (nonatomic, strong) CPRackMiniDetailViewController *miniDetail;
@property (nonatomic, strong) CPAddParkingViewController *addNew;

@property (weak, nonatomic) IBOutlet UIView *searchBarView;


@property (nonatomic, strong) MKPinAnnotationView *selectedAnnotationView;
@property (weak, nonatomic) IBOutlet UISearchBar *locationSearchBar;
- (IBAction)onLongPress:(UILongPressGestureRecognizer *)sender;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation CPViewLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[CPParseClient instance];
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
		[self.locationManager startUpdatingLocation];
		
				
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationController.navigationBar.hidden=YES;
	
    self.locationSearchBar.delegate = self;
	
    self.mainMapView.delegate = self;
    self.annotations = [[NSMutableArray alloc] init];
	self.racks = [[NSMutableArray alloc] init];
	
	self.searchBarView.layer.borderWidth = 1;
	self.searchBarView.layer.borderColor = [UIColor lightGrayColor].CGColor;

	 
		
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)importPins
{
	
	/* uncomment only if we need to re-import data */
	/*
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
       
       CPRackAnnotation *annotation = [[CPRackAnnotation alloc] initWithRack:rack Location:coordinate];
	   
	   [self.racks addObject:rack];
	   [self.annotations addObject:annotation];
	   
	   [rack saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
		   NSString *objectId = rack.objectId;
		   PFQuery *query = [PFQuery queryWithClassName:@"CPRack"];
		   [query getObjectInBackgroundWithId:objectId block:^(PFObject *bikeRack, NSError *error) {
			   // Do something with the returned PFObject in the bikeRack variable.
			   NSLog(@"%@", (CPRack *)bikeRack);
		   }];
	   }];
	   
	}
	[self.mainMapView addAnnotations:[self filterAnnotations:self.annotations modifyMap:false]];
	*/
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	[searchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
		
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        MKCoordinateRegion region;
        region.center.latitude = placemark.region.center.latitude;
        region.center.longitude = placemark.region.center.longitude;
        MKCoordinateSpan span;
        double radius = placemark.region.radius / 10000; // convert to km
		
        NSLog(@"[searchBarSearchButtonClicked] Radius is %f", radius);
        span.latitudeDelta = radius / 112.0;
		
        region.span = span;
		
		
		CPRackAnnotation *newAnnot = [[CPRackAnnotation alloc] initWithLocation:placemark.location.coordinate];
		
		
		[self.mainMapView addAnnotation:newAnnot];
		
		
        [self.mainMapView setRegion:region animated:YES];
    }];
}

#pragma mark - mapview delegate methods



- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
	/*
	CLLocationCoordinate2D coord = self.mainMapView.userLocation.location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
    
    [self.mainMapView setRegion:region animated:YES];
	
	[self findRacksWithLocation:coord];
	 */
}



- (void) findRacksWithLocation:(CLLocationCoordinate2D)location {
	PFQuery *query = [PFQuery queryWithClassName:@"CPRack"];
	
    
    //only if we need to import
    //[self importPins];
	// User's location
	
	PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:location.latitude longitude:location.longitude];
	[query whereKey:@"geoLocation" nearGeoPoint:point withinKilometers:5];
	//[query includeKey:kPAWParseUserKey];
	query.limit = 30;
	
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error) {
			NSLog(@"error in geo query!"); // todo why is this ever happening?
		} else {
			// We need to make new post objects from objects,
			// and update allPosts and the map to reflect this new array.
			// But we don't want to remove all annotations from the mapview blindly,
			// so let's do some work to figure out what's new and what needs removing.
			
			// 1. Find genuinely new posts:
			NSLog(@"object count %lu", (unsigned long)objects.count);
			[self.mainMapView removeAnnotations:self.mainMapView.annotations];
			for (PFObject *object in objects) {
				CPRack *rack = (CPRack *)object;
				CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(rack.geoLocation.latitude, rack.geoLocation.longitude);
				CPRackAnnotation *annotation = [[CPRackAnnotation alloc] initWithRack:rack Location:coord];
				[self.mainMapView addAnnotation:annotation];
				
			}
		}
	}];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
	//show current location as default blue dot
	if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
	//for our racks, create an annotationview
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

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKPinAnnotationView *)view {
	
	[self.mainMapView deselectAnnotation:view.annotation animated:NO];
	
	if(![view.annotation isKindOfClass:[MKUserLocation class]]){
		
		if ([self.selectedAnnotationView isEqual:view]){
			NSLog(@"clicking the same annotation again");
			self.selectedAnnotationView = nil;
			view.pinColor = MKPinAnnotationColorRed;
			UIView *miniDetailView = self.view.subviews.lastObject;
			[UIView animateWithDuration:0.15 animations:^{
				miniDetailView.frame = CGRectMake(10, self.view.frame.size.height+10, self.view.frame.size.width-20, 100);
			} ];
		}else{
			view.pinColor = MKPinAnnotationColorGreen;
			
			if (self.selectedAnnotationView != nil){
				NSLog(@"clicking different annotation");
				self.selectedAnnotationView.pinColor =MKPinAnnotationColorRed;
				
				
				[self.miniDetail setName:view.annotation.title];
				
			}else{
				NSLog(@"clicking annotation");
								
				self.miniDetail = [[CPRackMiniDetailViewController alloc] init];
				UIView *miniDetailView = self.miniDetail.view;
				miniDetailView.frame = CGRectMake(10, self.view.frame.size.height+10, self.view.frame.size.width-20, 100);
				[self.miniDetail setName:view.annotation.title];
				[self.view addSubview:miniDetailView];

				[UIView animateWithDuration:0.15 animations:^{
					miniDetailView.frame = CGRectMake(10, self.view.frame.size.height-100, self.view.frame.size.width-20, 100);
				} ];
				
				
			}
			self.selectedAnnotationView = view;
		}
    }
    
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
	//[self filterAnnotations:self.annotations modifyMap:true];
	[self findRacksWithLocation:mapView.centerCoordinate];
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
					//CPAnnotationGroup *group
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
	 
	//return racksToFilter;
	
}





- (IBAction)onLongPress:(UILongPressGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateBegan){
		

		CGPoint location = [sender locationInView:self.mainMapView];
		CLLocationCoordinate2D coord = [self.mainMapView convertPoint:location toCoordinateFromView:self.mainMapView];
		CPRackAnnotation *newAnnot = [[CPRackAnnotation alloc] initWithLocation:coord];
		
		
        // TODO only add if user actually added a bike rack
		[self.mainMapView addAnnotation:newAnnot];
		
		
		
		self.addNew = [[CPAddParkingViewController alloc] initWithLocation:coord];
		UIView *addNewView = self.addNew.view;
		addNewView.frame = CGRectMake(0, self.view.frame.size.height+10, self.view.frame.size.width, 100);
		
		[self.view addSubview:addNewView];
		
		/* disable map interactions until save or cancel are pressed */
		[self.mainMapView setUserInteractionEnabled:false];
		
		[UIView animateWithDuration:0.15 animations:^{
			addNewView.frame = CGRectMake(0, self.view.frame.size.height-400, self.view.frame.size.width, 400);
            self.locationSearchBar.hidden = TRUE;
			/* the map needs to recenter somehow...*/
		} ];

		
	}
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	CLLocationCoordinate2D coord = ((CLLocation *)locations[0]).coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
    
    [self.mainMapView setRegion:region animated:YES];
	
	[self findRacksWithLocation:coord];
	[self.locationManager stopUpdatingLocation];
}
@end
