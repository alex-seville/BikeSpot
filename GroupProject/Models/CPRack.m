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
#import "CPUser.h"

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

/* username of user who added this rack */
@dynamic createdBy;

/* photo of the bike rack */
@dynamic rackPhoto;





+ (NSString *)parseClassName {
    return @"CPRack";
}

- (id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.name = dictionary[@"name"];
	if (!self.name || [self.name isEqual:@"_undetermined"]){
		self.name = @"Bike Rack";
	}
    self.isInGarage = [dictionary[@"isInGarage"] boolValue];
    self.isCommercial = [dictionary[@"isCommercial"] boolValue];
    self.safetyRating = [dictionary[@"safetyRating"] intValue];
    self.longDescription = dictionary[@"longDescription"];
    self.rackPhotoName = dictionary[@"rackPhotoName"];
    self.rackPhoto = dictionary[@"rackPhoto"];

    
    self.address = dictionary[@"address"];
    self.numSpots = [dictionary[@"numSpots"] intValue];
    self.createdBy = (CPUser *)dictionary[@"createdBy"];
	
	self.geoLocation = [[PFGeoPoint alloc] init];
	self.geoLocation.latitude = [dictionary[@"latitude"] doubleValue];
	self.geoLocation.longitude = [dictionary[@"longitude"] doubleValue];
   
    
    return self;
}




@end
