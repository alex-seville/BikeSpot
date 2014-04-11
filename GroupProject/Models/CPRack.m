//
//  CPRack.m
//  GroupProject
//
//  Created by Alexander Seville on 4/2/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPRack.h"
#import <Parse/PFObject+Subclass.h>
#import <MapKit/MapKit.h>

@interface CPRack()


@end

@implementation CPRack

/* the main identifying name associated with the rack */
@dynamic name;

/* is this rack in a garage */
@dynamic isInGarage;

/* is this rack owned by a sponsoring business */
@dynamic isCommercial;

/* what is the original safety rating */
@dynamic safetyRating;

/* long description including more details */
@dynamic longDescription;

/* Name of rack photo, used to create PFFile */
@dynamic rackPhotoName;

/* geo location */
@dynamic geoLocation;

/* address */
@dynamic address;

/* number of spots */
@dynamic numSpots;

@dynamic coordinate;


+ (NSString *)parseClassName {
    return @"CPRack";
}

- (id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.name = dictionary[@"name"];
    self.isInGarage = [dictionary[@"isInGarage"] boolValue];
    self.isCommercial = [dictionary[@"isCommercial"] boolValue];
    self.safetyRating = [dictionary[@"safetyRating"] intValue];
    self.longDescription = dictionary[@"longDescription"];
    self.rackPhotoName = dictionary[@"rackPhotoName"];
    
    self.address = dictionary[@"address"];
    self.numSpots = [dictionary[@"numSpots"] intValue];
    
    double latitude = [dictionary[@"latitude"] doubleValue];
    double longitude = [dictionary[@"longitude"] doubleValue];
    
    [self setCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
    
    return self;
}

- (MKMapItem*)mapItem {
    
    
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:coordinate
                              addressDictionary:nil];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.name;
    
    return mapItem;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    [self setGeoLocation:geoPoint];
    
}

@end
