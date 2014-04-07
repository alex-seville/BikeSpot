//
//  CPUser.m
//  GroupProject
//
//  Created by Eugenia Leong on 4/6/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPUser.h"

@implementation CPUser

/* username associated with the user */
@dynamic username;

/* user's first name */
@dynamic firstname;

/* user's last name */
@dynamic lastname;

/* password */
@dynamic password;

/* email */
@dynamic email;

- (id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.username = dictionary[@"username"];
        self.firstname = dictionary[@"firstname"];
        self.lastname = dictionary[@"lastname"];
        self.password = dictionary[@"password"];
        self.email = dictionary[@"email"];
    }
  
    return self;
}

@end
