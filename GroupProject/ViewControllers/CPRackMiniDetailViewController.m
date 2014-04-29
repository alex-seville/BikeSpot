//
//  CPRackMiniDetailViewController.m
//  GroupProject
//
//  Created by Alexander Seville on 4/12/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPRackMiniDetailViewController.h"
#import "CPRack.h"



@interface CPRackMiniDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rackNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) CPRack *rack;

@property (weak, nonatomic) IBOutlet UILabel *extraDetails;

@end

@implementation CPRackMiniDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.view.layer.cornerRadius = 2;
	self.rackNameLabel.textColor = [UIColor colorWithRed:0.f green:180/255.0f blue:108/255.0f alpha:1.0f];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setRack:(CPRack *)rack {
	_rack = rack;
    self.rackNameLabel.text = [[[rack.name substringToIndex:1] uppercaseString ] stringByAppendingString:[rack.name substringFromIndex:1]];
	if ([[rack.address uppercaseString]  isEqual: @"NONE"]){
		self.rackDescriptionLabel.text = @"";
	}else{
		self.rackDescriptionLabel.text = rack.address;
	}
	self.timeLabel.text = @"";
	NSString *extras = @"";
	if (rack.numSpots > 0){
		if (rack.numSpots > 99){
			extras = [extras stringByAppendingString:@"99+ spots, "];
		}else{
			extras = [extras stringByAppendingString:[NSString stringWithFormat:@"%i spots, ",rack.numSpots]];
		}
	}
	if (rack.safetyRating > 0){
		NSArray *safetyStrings = [NSArray arrayWithObjects:@"\u2605", @"\u2605\u2605", @"\u2605\u2605\u2605", @"\u2605\u2605\u2605\u2605", @"\u2605\u2605\u2605\u2605\u2605",nil];
		
		extras = [extras stringByAppendingString:safetyStrings[rack.safetyRating-1]];
	}
	self.extraDetails.text = extras;
}

- (void) setTime:(NSTimeInterval)time {
	if (time < 60){
		self.timeLabel.text = [NSString stringWithFormat:@"Walk time from destination: %.0f secs", time];
	}else if (time >= 60 && time < 6000){
		self.timeLabel.text = [NSString stringWithFormat:@"Walk time from destination: %.0f mins", time / 60];
	}else {
		self.timeLabel.text = @"Walk time from destination: 99+ mins";
	}
}

- (CPRack *) getRack{
	return _rack;
}


@end
