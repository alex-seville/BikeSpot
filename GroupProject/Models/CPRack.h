//
//  CPRack.h
//  GroupProject
//
//  Created by Alexander Seville on 4/2/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface CPRack : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

- (id) initWithDictionary:(NSDictionary *)dictionary;

/* the main identifying name associated with the rack */
@property (retain) NSString *name;

/* is this rack in a garage */
@property BOOL isInGarage;

/* is this rack owned by a sponsoring business */
@property BOOL isCommercial;

/* what is the original safety rating */
@property int safetyRating;

/* long description including more details */
@property (retain) NSString *longDescription;

/* Name of rack photo, used to create PFFile */
@property (retain) NSString *rackPhotoName;

/* geo location */
@property (retain) PFGeoPoint *geoLocation;

/* geo location */
@property (retain) NSString *address;

/* number of spots */
@property int numSpots;

@end
