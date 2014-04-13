//
//  CPRackAnnotation.m
//  GroupProject
//
//  Created by Alexander Seville on 4/12/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPRackAnnotation.h"

@implementation CPRackAnnotation

-(id)initWithTitle:(NSString *)title Location:(CLLocationCoordinate2D)location{
    self = [super init];
    if (self){
        _title = title;
        _coordinate = location;
    }
    return self;
}

- (MKAnnotationView *)annotationView{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"RackAnnotation"];
    annotationView.enabled = true;
    annotationView.canShowCallout = true;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:nil  action:@selector(clickAnnotation) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = rightButton;
    
    return annotationView;
}

- (void) clickAnnotation {
    NSLog(@"click");
}

@end
