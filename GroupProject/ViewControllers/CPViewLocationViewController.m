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
#import "TSMessage.h"
#import "ZSPinAnnotation.h"

#define iphoneScaleFactorLatitude   9.0
#define iphoneScaleFactorLongitude  11.0

NSString * const ViewMoreRackDetails = @"ViewMoreRackDetails";
NSString * const UpdateMiniDetailNotification = @"UpdateMiniDetailNotification";
NSString * const CloseDetailNotification = @"CloseDetailNotification";
NSString * const UpdateWalkingDistanceDetailNotification = @"UpdateWalkingDistanceDetailNotification";

@interface CPViewLocationViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mainMapView;

@property (nonatomic, strong) NSMutableArray *racks;

@property (weak, nonatomic) IBOutlet UIView *searchBarView;


@property (nonatomic, strong) CPRackAnnotation *selectedAnnotation;
@property (nonatomic, strong) CPRackAnnotation *searchResultAnnotation;

@property (weak, nonatomic) IBOutlet UISearchBar *locationSearchBar;
- (IBAction)onLongPress:(UILongPressGestureRecognizer *)sender;
- (IBAction)onMenuTapped:(UITapGestureRecognizer *)sender;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UITapGestureRecognizer *tapWhenAnnotationOpen;

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

- (IBAction)onTapWhenAnnotationOpen:(UIPanGestureRecognizer *)gesture {
	NSLog(@"on tap");
	[self.mainMapView removeGestureRecognizer:self.tapWhenAnnotationOpen];
	[self.mainMapView deselectAnnotation:self.selectedAnnotation animated:NO];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:CloseDetailNotification object:self userInfo:[NSDictionary dictionaryWithObject:self.selectedAnnotation.rack forKey:@"rack"]];
	
	self.selectedAnnotation = nil;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	[searchBar resignFirstResponder];
	searchBar.showsCancelButton=false;
	
	
	/*CLRegion *newRegion = [[CLRegion alloc] init];
	newRegion
    newRegion.latitude = 37.783333;
    newRegion.longitude = -122.416667;
    */
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressDictionary:@{
				@"Street": searchBar.text,
				@"City": @"San Francisco",
				@"State": @"California"
		}  completionHandler:^(NSArray *placemarks, NSError *error) {
    
		
        if (error != nil )
        {
            [TSMessage showNotificationWithTitle:@"No destination found"
										subtitle:@"Please search for an address with San Francisco"
											type:TSMessageNotificationTypeError];
        }
        else
        {
			
			
			int index = 0;
			bool keepChecking = true;
			
			//find the first placemark in SF
			CLPlacemark *placemark = [placemarks objectAtIndex:index];
			while (keepChecking && (![placemark.country  isEqual: @"United States"] || ![placemark.administrativeArea  isEqual: @"CA"] || ![placemark.locality  isEqual: @"San Francisco"])){
				index++;
				if (index >= placemarks.count){
					keepChecking = false;
				}else{
					placemark = [placemarks objectAtIndex:index];
				}
			}
			
			//check that the placemark is in SF
			if (![placemark.country  isEqual: @"United States"] || ![placemark.administrativeArea  isEqual: @"CA"] || ![placemark.locality  isEqual: @"San Francisco"]){
				[TSMessage showNotificationWithTitle:@"No destination found"
											subtitle:@"Please search for an address with San Francisco"
												type:TSMessageNotificationTypeError];
			}else{
				
				[self clearSelectedAnnotation];
				
				[self resetSearchAnnotation];
				
				
				if (placemark.addressDictionary[@"FormattedAddressLines"] == nil || [placemark.addressDictionary[@"FormattedAddressLines"][0]  isEqual: @"San Francisco, CA"]){
					//address is vague, should warn user somehow
					[TSMessage showNotificationWithTitle:@"Unspecific Address"
												subtitle:@"We were unable to find the exact address.  Your destination may or may not be near this location."
													type:TSMessageNotificationTypeWarning];
				}
			
				MKCoordinateRegion region;
				region.center.latitude = placemark.region.center.latitude;
				region.center.longitude = placemark.region.center.longitude;
				MKCoordinateSpan span;
				double radius = placemark.region.radius / 10000; // convert to km
				
				NSLog(@"[searchBarSearchButtonClicked] Radius is %f", radius);
				span.latitudeDelta = radius / 112.0;
				
				region.span = span;
				
				CPRackAnnotation *newAnnot = [[CPRackAnnotation alloc] initWithLocation:region.center];
				
				self.searchResultAnnotation = newAnnot;
				[self.mainMapView addAnnotation:newAnnot];
				
				
				[self.mainMapView setCenterCoordinate:region.center animated:YES];
				
				[self.mainMapView setRegion:region animated:YES];
				[self findRacksWithLocation:region.center];
			}
			
		}
		
    }];
    

}

- (void) resetSearchAnnotation {
	if (self.searchResultAnnotation != nil){
		[self.mainMapView removeAnnotation:self.searchResultAnnotation];
		self.searchResultAnnotation = nil;
		
	}
}

- (void) clearSelectedAnnotation {
	if (self.selectedAnnotation != nil){
		[[NSNotificationCenter defaultCenter] postNotificationName:CloseDetailNotification object:self userInfo:[NSDictionary dictionaryWithObject:self.selectedAnnotation.rack forKey:@"rack"]];
	}
	[self.mainMapView deselectAnnotation:self.selectedAnnotation animated:NO];
	self.selectedAnnotation = nil;
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
	ZSPinAnnotation *annotationView = (ZSPinAnnotation *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"RackAnnotation"];
	
	if(!annotationView){
		annotationView = [[ZSPinAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:@"RackAnnotation"];
	}
	
	annotationView.annotationType = ZSPinAnnotationTypeStandard;
	annotationView.annotationColor = [UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f];
	
		
	if (self.searchResultAnnotation != nil && self.searchResultAnnotation.coordinate.latitude == annotation.coordinate.latitude && self.searchResultAnnotation.coordinate.longitude == annotation.coordinate.longitude)
	{
			
		annotationView.annotationType = ZSPinAnnotationTypeDisc;
		annotationView.annotationColor = [UIColor blueColor];
		[annotationView setUserInteractionEnabled:false];
		annotationView.enabled = false;
		
	}

	else if (self.selectedAnnotation != nil){
		
		if (self.selectedAnnotation.coordinate.latitude == annotation.coordinate.latitude && self.selectedAnnotation.coordinate.longitude == annotation.coordinate.longitude){
			
			annotationView.annotationType = ZSPinAnnotationTypeStandard;
			annotationView.annotationColor = [UIColor darkGrayColor];
		}
	}

    annotationView.canShowCallout = NO;
    annotationView.draggable = NO;
    

    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(ZSPinAnnotation *)view {
	
	
	
	if(![view.annotation isKindOfClass:[MKUserLocation class]] && ((CPRackAnnotation *)view.annotation).rack != nil){
		CPRack *rack = ((CPRackAnnotation *)view.annotation).rack;
		
		if ([self.selectedAnnotation isEqual:view.annotation]){
			/* this condition is never hit, we can't deselect for now */
			NSLog(@"clicking the same annotation again");
			[self.mainMapView deselectAnnotation:self.selectedAnnotation animated:NO];
			self.selectedAnnotation = nil;
			
			[self.mainMapView removeGestureRecognizer:self.tapWhenAnnotationOpen];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:CloseDetailNotification object:self userInfo:[NSDictionary dictionaryWithObject:rack forKey:@"rack"]];
		}else{
			view.annotationColor = [UIColor darkGrayColor];
			
			
			if (self.selectedAnnotation != nil){
				NSLog(@"clicking different annotation");
				
				//to reset the pin we remove and re-add the annotation to the map
				[self.mainMapView deselectAnnotation:self.selectedAnnotation animated:NO];
				
				
				[[NSNotificationCenter defaultCenter] postNotificationName:UpdateMiniDetailNotification object:self userInfo:[NSDictionary dictionaryWithObject:rack forKey:@"rack"]];
				
			}else{
				NSLog(@"clicking annotation");
							
				
				
				CPRack *rack = ((CPRackAnnotation *)view.annotation).rack;
				
				[[NSNotificationCenter defaultCenter] postNotificationName:ViewMoreRackDetails object:self userInfo:[NSDictionary dictionaryWithObject:rack forKey:@"rack"]];
				
				self.tapWhenAnnotationOpen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapWhenAnnotationOpen:)];
				
				//[self.mainMapView setUserInteractionEnabled:false];
				[self.mainMapView addGestureRecognizer:self.tapWhenAnnotationOpen];
				
				
			}
			self.selectedAnnotation = view.annotation;
			
			CLLocationCoordinate2D sourceCoord;
			
			if (self.searchResultAnnotation != nil){
				sourceCoord = self.searchResultAnnotation.coordinate;
			}else{
				sourceCoord = self.locationManager.location.coordinate;
			}
						
			MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:sourceCoord addressDictionary:nil]];
			MKMapItem *dest = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:((CPRackAnnotation *)view.annotation).coordinate addressDictionary:nil]];
			
			MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
			request.transportType = MKDirectionsTransportTypeWalking;
			request.source = source;
			request.destination = dest;
			
			MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
			[directions calculateETAWithCompletionHandler:^(MKETAResponse *response, NSError *error) {
				
				[[NSNotificationCenter defaultCenter] postNotificationName:UpdateWalkingDistanceDetailNotification object:self userInfo:[NSDictionary dictionaryWithObject:@(response.expectedTravelTime) forKey:@"time"]];
			}];
								 
		}
    }
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(ZSPinAnnotation *)view {
	NSLog(@"deselect");
	if(![view.annotation isKindOfClass:[MKUserLocation class]]){
		view.annotationColor = [UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f];
	}
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
	
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
