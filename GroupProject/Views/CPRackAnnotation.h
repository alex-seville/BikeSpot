//
//  CPRackAnnotation.h
//  GroupProject
//
//  Created by Alexander Seville on 4/12/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "CPRack.h"

@interface CPRackAnnotation : NSObject <MKAnnotation>{
	NSString *currentTitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (nonatomic, strong) CPRack *rack;
@property (nonatomic, assign) bool selected;

-(id)initWithRack:(CPRack *)rack Location:(CLLocationCoordinate2D)location;
-(id)initWithLocation:(CLLocationCoordinate2D)location;
- (MKAnnotationView *)annotationView;

@end
