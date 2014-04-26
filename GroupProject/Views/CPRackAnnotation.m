//
//  CPRackAnnotation.m
//  GroupProject
//
//  Created by Alexander Seville on 4/12/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPRackAnnotation.h"
#import "CPRack.h"

@interface CPRackAnnotation()

@end

@implementation CPRackAnnotation

-(id)initWithRack:(CPRack *)rack Location:(CLLocationCoordinate2D)location{
    self = [super init];
    if (self){
        _coordinate = location;
		_rack = rack;
		
		_location = [[CLLocation alloc]
					 initWithLatitude:location.latitude
					 longitude:location.longitude];
    }
    return self;
}

-(id)initWithLocation:(CLLocationCoordinate2D)location{
    self = [super init];
    if (self){
        _coordinate = location;
		_location = [[CLLocation alloc]
								   initWithLatitude:location.latitude
								   longitude:location.longitude];
		
    }
    return self;
}

- (MKAnnotationView *)annotationView{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"RackAnnotation"];
    annotationView.enabled = true;
    annotationView.canShowCallout = true;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:nil  action:nil forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = rightButton;
    
    return annotationView;
}


- (NSString *)title{
    
    return ((CPRack *)_rack).name;
}



@end
