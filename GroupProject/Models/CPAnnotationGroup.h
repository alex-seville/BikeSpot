//
//  CPAnnotationGroup.h
//  GroupProject
//
//  Created by Alexander Seville on 4/13/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CPAnnotationGroup : NSObject <MKAnnotation> {
	NSString *currentTitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id)initWithLocation:(CLLocationCoordinate2D)location;

@end
