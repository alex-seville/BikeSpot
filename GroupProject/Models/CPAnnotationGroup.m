//
//  CPAnnotationGroup.m
//  GroupProject
//
//  Created by Alexander Seville on 4/13/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPAnnotationGroup.h"
#import <MapKit/MapKit.h>

@implementation CPAnnotationGroup

-(id)initWithLocation:(CLLocationCoordinate2D)location{
    self = [super init];
    if (self){
        _coordinate = location;
    }
    return self;
}

- (MKAnnotationView *)annotationView{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"RackGroupAnnotation"];
    annotationView.enabled = true;
    annotationView.canShowCallout = true;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:nil  action:nil forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = rightButton;
    
    return annotationView;
}


- (NSString *)title{
    
    return @"Group racks";
}

@end
