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
#import "CPAnnotationGroup.h"
#import <Parse/Parse.h>
#import "CPParseClient.h"

#define iphoneScaleFactorLatitude   9.0
#define iphoneScaleFactorLongitude  11.0

NSString * const ViewMoreRackDetails = @"ViewMoreRackDetails";
NSString * const UpdateMiniDetailNotification = @"UpdateMiniDetailNotification";
NSString * const CloseDetailNotification = @"CloseDetailNotification";
NSString * const UpdateWalkingDistanceDetailNotification = @"UpdateWalkingDistanceDetailNotification";

@interface CPViewLocationViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mainMapView;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) NSMutableArray *racks;

@property (weak, nonatomic) IBOutlet UIView *searchBarView;


@property (nonatomic, strong) CPRackAnnotation *selectedAnnotation;
@property (nonatomic, strong) CPRackAnnotation *searchResultAnnotation;

@property (weak, nonatomic) IBOutlet UISearchBar *locationSearchBar;
- (IBAction)onLongPress:(UILongPressGestureRecognizer *)sender;
- (IBAction)onMenuTapped:(UITapGestureRecognizer *)sender;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

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
	
	self.searchBarView.layer.shadowColor = [UIColor blackColor].CGColor;
	self.searchBarView.layer.shadowRadius = 2;
	self.searchBarView.layer.shadowOpacity = 0.3;
	self.searchBarView.layer.shadowOffset = CGSizeMake(0, 0);
	self.searchBarView.layer.cornerRadius = 2;
		
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
								@"address": [row objectAtIndex:9],
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
	 */
	//[self.mainMapView addAnnotations:[self filterAnnotations:self.annotations modifyMap:false]];
	
}



- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	
	self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
	
	//[self.mainMapView setUserInteractionEnabled:false];
	[self.mainMapView addGestureRecognizer:self.tap];
	
	NSLog(@"begin editing and add gestrue recog");
}

- (IBAction)onTap:(UIPanGestureRecognizer *)gesture {
	NSLog(@"on tap");
	[self.mainMapView removeGestureRecognizer:self.tap];
	[self.locationSearchBar resignFirstResponder];
	//[self.mainMapView setUserInteractionEnabled:true];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	[searchBar resignFirstResponder];
	searchBar.showsCancelButton=false;
	
	
	MKCoordinateRegion newRegion;
    newRegion.center.latitude = 37.783333;
    newRegion.center.longitude = -122.416667;
    
    // setup the area spanned by the map region:
    // we use the delta values to indicate the desired zoom level of the map,
    //      (smaller delta values corresponding to a higher zoom level)
    //
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
	
	MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = searchBar.text;
    request.region = newRegion;
    
    MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error)
    {
        if (error != nil)
        {
            NSString *errorStr = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not find places"
                                                            message:errorStr
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            
			CPRackAnnotation *newAnnot = [[CPRackAnnotation alloc] initWithLocation:response.boundingRegion.center];
			
			self.searchResultAnnotation = newAnnot;
			[self.mainMapView addAnnotation:newAnnot];
			
			
			[self.mainMapView setCenterCoordinate:response.boundingRegion.center animated:YES];
			
			[self.mainMapView setRegion:response.boundingRegion animated:YES];
			[self findRacksWithLocation:response.boundingRegion.center];
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		}
    };
    
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [localSearch startWithCompletionHandler:completionHandler];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

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
	
	[self.annotations removeAllObjects];
	
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error) {
			NSLog(@"error in geo query!"); // todo why is this ever happening?
		} else {
			
			NSLog(@"object count %lu", (unsigned long)objects.count);
			//[self.mainMapView removeAnnotations:self.mainMapView.annotations];
			for (PFObject *object in objects) {
				CPRack *rack = (CPRack *)object;
				CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(rack.geoLocation.latitude, rack.geoLocation.longitude);
				
				if ([self.mainMapView.annotations indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
					BOOL test = (((CPRackAnnotation *)obj).coordinate.latitude == coord.latitude &&
								 ((CPRackAnnotation *)obj).coordinate.longitude == coord.longitude);
					*stop = test;
					
					return test;
				}] == NSNotFound){
					CPRackAnnotation *annotation = [[CPRackAnnotation alloc] initWithRack:rack Location:coord];
					[self.mainMapView addAnnotation:annotation];
					[self.annotations addObject:annotation];
				}
				
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
	
	if (self.searchResultAnnotation != nil){
		if (self.searchResultAnnotation.coordinate.latitude == annotation.coordinate.latitude && self.searchResultAnnotation.coordinate.longitude == annotation.coordinate.longitude){
			
			annotationView.pinColor = MKPinAnnotationColorPurple;
			[annotationView setUserInteractionEnabled:false];
		}
		
	}

	else if (self.selectedAnnotation != nil){
		
		if (self.selectedAnnotation.coordinate.latitude == annotation.coordinate.latitude && self.selectedAnnotation.coordinate.longitude == annotation.coordinate.longitude){
			NSLog(@"%f %f %f %f", self.selectedAnnotation.coordinate.latitude , annotation.coordinate.latitude ,self.selectedAnnotation.coordinate.longitude, annotation.coordinate.longitude);
			annotationView.pinColor = MKPinAnnotationColorGreen;
		}
	}

    annotationView.canShowCallout = YES;
    annotationView.draggable = YES;
    
    annotationView.animatesDrop = NO;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKPinAnnotationView *)view {
	
	[self.mainMapView deselectAnnotation:view.annotation animated:NO];
	
	if(![view.annotation isKindOfClass:[MKUserLocation class]] && ((CPRackAnnotation *)view.annotation).rack != nil){
		CPRack *rack = ((CPRackAnnotation *)view.annotation).rack;
		
		if ([self.selectedAnnotation isEqual:view.annotation]){
			NSLog(@"clicking the same annotation again");
			
			self.selectedAnnotation = nil;
			view.pinColor = MKPinAnnotationColorRed;
			
			[[NSNotificationCenter defaultCenter] postNotificationName:CloseDetailNotification object:self userInfo:[NSDictionary dictionaryWithObject:rack forKey:@"rack"]];
		}else{
			view.pinColor = MKPinAnnotationColorGreen;
			
			if (self.selectedAnnotation != nil){
				NSLog(@"clicking different annotation");
				
				MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"RackAnnotation"];
				
				if(!annotationView){
					annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:self.selectedAnnotation reuseIdentifier:@"RackAnnotation"];
				}

				
				annotationView.pinColor =MKPinAnnotationColorRed;
				
				/* update minitdetailview info */
				//[self.miniDetail setName:view.annotation.title];
				[[NSNotificationCenter defaultCenter] postNotificationName:UpdateMiniDetailNotification object:self userInfo:[NSDictionary dictionaryWithObject:rack forKey:@"rack"]];
				
			}else{
				NSLog(@"clicking annotation");
							
				
				
				CPRack *rack = ((CPRackAnnotation *)view.annotation).rack;
				
				[[NSNotificationCenter defaultCenter] postNotificationName:ViewMoreRackDetails object:self userInfo:[NSDictionary dictionaryWithObject:rack forKey:@"rack"]];
				
				
			}
			self.selectedAnnotation = view.annotation;
						
			MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.mainMapView.centerCoordinate addressDictionary:nil]];
			MKMapItem *dest = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:((CPRackAnnotation *)view.annotation).coordinate addressDictionary:nil]];
			
			MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
			request.transportType = MKDirectionsTransportTypeWalking;
			request.source = source;
			request.destination = dest;
			
			MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
			[directions calculateETAWithCompletionHandler:^(MKETAResponse *response, NSError *error) {
				NSLog(@"distance: %.2f minutes", response.expectedTravelTime / 60);
				
				[[NSNotificationCenter defaultCenter] postNotificationName:UpdateWalkingDistanceDetailNotification object:self userInfo:[NSDictionary dictionaryWithObject:@(response.expectedTravelTime) forKey:@"time"]];
			}];
								 
		}
    }
    
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
	//[self filterAnnotations:self.annotations modifyMap:true];
	
	if (self.searchResultAnnotation == nil){
		[self findRacksWithLocation:mapView.centerCoordinate];
	}
	
	
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
		
		
		/* move up */
		/*
		self.addNew = [[CPAddParkingViewController alloc] initWithLocation:coord];
		UIView *addNewView = self.addNew.view;
		addNewView.frame = CGRectMake(0, self.view.frame.size.height+10, self.view.frame.size.width, 100);
        self.addNew.delegate = self;
		
		[self.view addSubview:addNewView];
		*/
		/* disable map interactions until save or cancel are pressed */
		[self.mainMapView setUserInteractionEnabled:false];
		
		[UIView animateWithDuration:0.15 animations:^{
			//addNewView.frame = CGRectMake(0, self.view.frame.size.height-400, self.view.frame.size.width, 400);
			/* the map needs to recenter somehow...*/
		} ];

		
	}
}

- (IBAction)onMenuTapped:(UITapGestureRecognizer *)sender {
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	CLLocationCoordinate2D coord = ((CLLocation *)locations[0]).coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
    
    [self.mainMapView setRegion:region animated:YES];
	
	[self findRacksWithLocation:coord];
	[self.locationManager stopUpdatingLocation];
}

#pragma mark - CPAddParkingViewControllerDelegate methods
-(void)didAddParkingViewClose:(CPAddParkingViewController *)sender
{
    [self.mainMapView setUserInteractionEnabled:YES];
}
@end
