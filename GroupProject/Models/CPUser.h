//
//  CPUser.h
//  GroupProject
//
//  Created by Eugenia Leong on 4/6/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import <Parse/Parse.h>

@interface CPUser : PFUser

- (id) initWithDictionary:(NSDictionary *)dictionary;

/* username, password, and email are inherited from PFUser */

/* user's first name */
@property (retain) NSString *firstname;

/* user's last name */
@property (retain) NSString *lastname;

@end
