//
//  CPRackMiniDetailViewController.h
//  GroupProject
//
//  Created by Alexander Seville on 4/12/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPRack.h"

extern NSString * const ViewMoreRackDetails;

@interface CPRackMiniDetailViewController : UIViewController

- (void) setRack:(CPRack *)rack;
- (void) setTime:(NSTimeInterval)time;

- (CPRack *) getRack;

/* just for now */
@property (weak, nonatomic) IBOutlet UILabel *rackDescriptionLabel;

@end
