//
//  CPHamburgerMenuViewController.h
//  GroupProject
//
//  Created by Alexander Seville on 4/7/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPHamburgerMenuViewController;
@protocol CPHamburgerMenuViewControllerDelegate <NSObject>

-(void)sender:(CPHamburgerMenuViewController *)sender menuTapped:(int) index;
@end

@interface CPHamburgerMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) id<CPHamburgerMenuViewControllerDelegate> delegate;
@end
