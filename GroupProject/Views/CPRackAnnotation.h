//
//  CPRackAnnotation.h
//  GroupProject
//
//  Created by Alexander Seville on 4/12/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CPRackAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;

-(id)initWithTitle:(NSString *)title Location:(CLLocationCoordinate2D)location;
- (MKAnnotationView *)annotationView;

@end
