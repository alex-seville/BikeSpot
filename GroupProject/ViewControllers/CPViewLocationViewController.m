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
NSString * const AddNewRackNotification = @"AddNewRackNotification";
NSString * const PresentLogInViewNotification = @"PresentLogInViewNotification";
NSString * const ShowInstructionsNotification = @"ShowInstructionsNotification";
NSString * const CloseInstructionsNotification = @"CloseInstructionsNotification";

@interface CPViewLocationViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mainMapView;

@property (nonatomic, strong) NSMutableArray *racks;
@property (nonatomic, strong) NSArray *sortedAnnotations;

@property (weak, nonatomic) IBOutlet UIView *searchBarView;


@property (nonatomic, strong) CPRackAnnotation *selectedAnnotation;
@property (nonatomic, strong) CPRackAnnotation *searchResultAnnotation;
@property (nonatomic, strong) CPRackAnnotation *addAnnotation;

@property (weak, nonatomic) IBOutlet UISearchBar *locationSearchBar;
- (IBAction)onLongPress:(UILongPressGestureRecognizer *)sender;
- (IBAction)onMenuTapped:(UITapGestureRecognizer *)sender;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UITapGestureRecognizer *tapWhenAnnotationOpen;

@property (nonatomic, strong) CPAddParkingViewController *addNew;

@property (nonatomic, assign) double searchLayerX;
@property (nonatomic, assign) double searchLayerY;
@property (nonatomic, assign) double searchBarX;
@property (nonatomic, assign) double searchBarY;

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
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
	[self.locationManager startUpdatingLocation];
	
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

}

- (IBAction)onTap:(UIPanGestureRecognizer *)gesture {
	[self.mainMapView removeGestureRecognizer:self.tap];
	[self.locationSearchBar resignFirstResponder];
	//[self.mainMapView setUserInteractionEnabled:true];
}

- (IBAction)onTapWhenAnnotationOpen:(UIPanGestureRecognizer *)gesture {
	
	[self.mainMapView removeGestureRecognizer:self.tapWhenAnnotationOpen];
	
	if (self.selectedAnnotation != nil){
		[self.mainMapView deselectAnnotation:self.selectedAnnotation animated:NO];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:CloseDetailNotification object:self userInfo:[NSDictionary dictionaryWithObject:self.selectedAnnotation.rack forKey:@"rack"]];
		
		self.selectedAnnotation = nil;
	}
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	[searchBar resignFirstResponder];
	searchBar.showsCancelButton=false;
	
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
			[[NSNotificationCenter defaultCenter] postNotificationName:CloseInstructionsNotification object:self];
			
			
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
				
				span.latitudeDelta = radius / 112.0;
				
				region.span = span;
				
				CPRackAnnotation *newAnnot = [[CPRackAnnotation alloc] initWithLocation:region.center];
				[newAnnot setTitle:searchBar.text];
				self.searchResultAnnotation = newAnnot;
				
				[self.mainMapView addAnnotation:newAnnot];
				
				
				[self.mainMapView setCenterCoordinate:region.center animated:YES];
				
				[self.mainMapView setRegion:region animated:YES];
				[self findRacksWithLocation:region.center];
			}
			
		}
		
    }];
    

}

- (void)createSortedAnnotations{
	CLLocation *currentLocation;
	
	if (self.searchResultAnnotation){
		currentLocation = [[CLLocation alloc] initWithLatitude:self.searchResultAnnotation.coordinate.latitude longitude:self.searchResultAnnotation.coordinate.longitude];
	} else {
		currentLocation = [[CLLocation alloc] initWithLatitude:self.mainMapView.userLocation.coordinate.latitude longitude:self.mainMapView.userLocation.coordinate.longitude];
	}
	
    
	
	NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [CPRackAnnotation class]];
	NSArray *mapAnnots = [self.mainMapView.annotations filteredArrayUsingPredicate:sPredicate];

	NSArray *sorted = [mapAnnots sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
		
        CLLocationDistance first = [((CPRackAnnotation *)a).location distanceFromLocation:currentLocation];
        CLLocationDistance second = [((CPRackAnnotation *)b).location distanceFromLocation:currentLocation];

        return first > second;
    }];

	self.sortedAnnotations = sorted;
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

}



- (void) findRacksWithLocation:(CLLocationCoordinate2D)location {
	PFQuery *query = [PFQuery queryWithClassName:@"CPRack"];
	
    
    //only if we need to import
    //[self importPins];
	// User's location
	
	PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:location.latitude longitude:location.longitude];
	[query whereKey:@"geoLocation" nearGeoPoint:point withinKilometers:5];
	
	query.limit = 30;
	
	[self.annotations removeAllObjects];
	
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error) {
			[TSMessage showNotificationWithTitle:@"No bike racks found"
										subtitle:@"There may be a problem with your connection."
											type:TSMessageNotificationTypeError];
		} else {
			
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
			[self createSortedAnnotations];
			
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
	annotationView.canShowCallout = NO;
    annotationView.draggable = NO;
	
	if (self.addAnnotation != nil && self.addAnnotation.coordinate.latitude == annotation.coordinate.latitude && self.addAnnotation.coordinate.longitude == annotation.coordinate.longitude){
		annotationView.annotationType = ZSPinAnnotationTypeStandard;
		annotationView.annotationColor = [UIColor blackColor];
	}
	
	else if (self.searchResultAnnotation != nil && self.searchResultAnnotation.coordinate.latitude == annotation.coordinate.latitude && self.searchResultAnnotation.coordinate.longitude == annotation.coordinate.longitude)
	{
			
		annotationView.annotationType = ZSPinAnnotationTypeDisc;
		annotationView.annotationColor = [UIColor blueColor];
	}

	else if (self.selectedAnnotation != nil){
		
		if (self.selectedAnnotation.coordinate.latitude == annotation.coordinate.latitude && self.selectedAnnotation.coordinate.longitude == annotation.coordinate.longitude){
			
			annotationView.annotationType = ZSPinAnnotationTypeStandard;
			annotationView.annotationColor = [UIColor darkGrayColor];
		}
	}
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(ZSPinAnnotation *)view {
	
	if ([self.searchResultAnnotation isEqual:view.annotation]){
		NSString *title = self.searchResultAnnotation.title;
		[[NSNotificationCenter defaultCenter] postNotificationName:ShowInstructionsNotification object:self
		 userInfo:[NSDictionary dictionaryWithObject:title forKey:@"title"]];
	}else if(![view.annotation isKindOfClass:[MKUserLocation class]] && ((CPRackAnnotation *)view.annotation).rack != nil){
		
		[[NSNotificationCenter defaultCenter] postNotificationName:CloseInstructionsNotification object:self];
		
		CPRackAnnotation *rackAnnot = (CPRackAnnotation *)view.annotation;
		CPRack *rack = rackAnnot.rack;
		
		if ([self.selectedAnnotation isEqual:view.annotation]){
			/* this condition is never hit, we can't deselect for now */
			NSLog(@"clicking the same annotation again");
			[self.mainMapView deselectAnnotation:self.selectedAnnotation animated:NO];
			self.selectedAnnotation = nil;
			
			[self.mainMapView removeGestureRecognizer:self.tapWhenAnnotationOpen];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:CloseDetailNotification object:self userInfo:[NSDictionary dictionaryWithObject:rack forKey:@"rack"]];
		}else{
			view.annotationColor = [UIColor darkGrayColor];
			[self.mainMapView setCenterCoordinate:rackAnnot.coordinate animated:YES];
			
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
	if(![view.annotation isKindOfClass:[MKUserLocation class]]){
		view.annotationColor = [UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f];
	}
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
	if (self.addAnnotation == nil){
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


- (IBAction)onLongPress:(UILongPressGestureRecognizer *)sender {
	
    // user not logged in
	[[NSNotificationCenter defaultCenter] postNotificationName:CloseInstructionsNotification object:self];
	/*
    if (![CPUser currentUser])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:PresentLogInViewNotification object:self];
        return;
    }
    */
    if (sender.state == UIGestureRecognizerStateBegan){
    
		CGPoint location = [sender locationInView:self.mainMapView];
		CLLocationCoordinate2D coord = [self.mainMapView convertPoint:location toCoordinateFromView:self.mainMapView];
		CPRackAnnotation *newAnnot = [[CPRackAnnotation alloc] initWithLocation:coord];
		
		self.addAnnotation = newAnnot;
        // TODO only add if user actually added a bike rack
		[self.mainMapView addAnnotation:newAnnot];
		[self.mainMapView setCenterCoordinate:coord];
		
		/* move up */
		
		[[NSNotificationCenter defaultCenter] postNotificationName:AddNewRackNotification object:self
			userInfo:@{
				   @"latitude": @(coord.latitude),
				   @"longitude": @(coord.longitude)
			}
		];
		
		
		/* disable search too */
		[self.searchBarView resignFirstResponder];
		
		[self.searchDisplayController setActive:NO animated:YES ];
		[UIView animateWithDuration:0.15 animations:^{
			[self.mainMapView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-400)];
			self.searchLayerX = self.searchBarView.frame.origin.x;
			self.searchLayerY = self.searchBarView.frame.origin.y;
			self.searchBarX = self.locationSearchBar.frame.origin.x;
			self.searchBarX = self.locationSearchBar.frame.origin.y;
			
			[self.searchBarView setFrame:CGRectMake(0, -self.searchBarView.frame.size.height, self.searchBarView.frame.size.width, self.searchBarView.frame.size.height)];
			
			[self.locationSearchBar setFrame:CGRectMake(0, -self.searchBarView.frame.size.height, self.searchBarView.frame.size.width, self.searchBarView.frame.size.height)];
			
						
		} completion:^(BOOL finished) {
			
			/* disable map interactions until save or cancel are pressed */
			[self.mainMapView setUserInteractionEnabled:false];
			
			// TODO only add if user actually added a bike rack
			[self.mainMapView addAnnotation:newAnnot];
			
			
		} ];
		
	}
}

- (void) onCloseAddNew {
	self.addAnnotation = nil;
	[self.mainMapView removeAnnotations:self.mainMapView.annotations];
	[self.searchDisplayController setActive:YES animated:YES ];
	[UIView animateWithDuration:0.15 animations:^{
		[self.mainMapView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		[self.searchBarView setFrame:CGRectMake(self.searchLayerX, self.searchLayerY, self.searchBarView.frame.size.width, self.searchBarView.frame.size.height)];
		NSLog(@"layer, bar %f %f", self.searchLayerX, self.searchBarX);
		[self.locationSearchBar setFrame:CGRectMake(self.searchBarX-self.searchLayerX, self.searchLayerY + self.searchBarY, self.searchBarView.frame.size.width, self.searchBarView.frame.size.height)];
		
		
	} completion:^(BOOL finished) {
		
		/* disable map interactions until save or cancel are pressed */
		[self.mainMapView setUserInteractionEnabled:true];
		
		
	} ];
}

- (IBAction)onMenuTapped:(UITapGestureRecognizer *)sender {
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	CLLocationCoordinate2D coord = ((CLLocation *)locations[0]).coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 10, 10);
    
    [self.mainMapView setRegion:region animated:YES];
	
	[self findRacksWithLocation:coord];
	[self.locationManager stopUpdatingLocation];
}

- (int)getRackIndex:(CPRack *)rack annotations:(NSArray *)annotations {
	NSArray *annots = annotations;
	int rackIndex = [annots indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		CPRackAnnotation *rackAnnot = (CPRackAnnotation *)obj;
		if ([rackAnnot isKindOfClass:[MKUserLocation class]]){
			return false;
		}
		BOOL found = (rackAnnot.rack == rack);
		stop = &found;
		return found;
	}];

	return rackIndex;
}

- (CPRack *)getNextRack:(CPRack *)rack {
	NSArray *annots = self.sortedAnnotations;
	int rackIndex = [self getRackIndex:rack annotations:annots];
	[self.mainMapView deselectAnnotation:annots[rackIndex] animated:NO];
	if (rackIndex+1 >= annots.count){
		rackIndex = 0;
	}else{
		rackIndex++;
	}
	CPRackAnnotation *rackAnnot = annots[rackIndex];
	[self.mainMapView selectAnnotation:rackAnnot animated:NO];
	[self.mainMapView setCenterCoordinate:rackAnnot.coordinate animated:YES];
	return rackAnnot.rack;
}

- (CPRack *)getPrevRack:(CPRack *)rack {
	NSArray *annots = self.sortedAnnotations;
	int rackIndex = [self getRackIndex:rack annotations:annots];
	[self.mainMapView deselectAnnotation:annots[rackIndex] animated:NO];
	if (rackIndex-1 <= 0){
		rackIndex = annots.count-1;
	}else{
		rackIndex--;
	}
	CPRackAnnotation *rackAnnot = annots[rackIndex];
	[self.mainMapView selectAnnotation:rackAnnot animated:NO];
	[self.mainMapView setCenterCoordinate:rackAnnot.coordinate animated:YES];
	return rackAnnot.rack;
}

#pragma mark - CPAddParkingViewControllerDelegate methods
-(void)didAddParkingViewClose:(CPAddParkingViewController *)sender
{
    [self.mainMapView setUserInteractionEnabled:YES];
}
@end
