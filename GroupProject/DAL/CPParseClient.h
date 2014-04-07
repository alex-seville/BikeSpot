//
//  CPParseClient.h
//  GroupProject
//
//  Created by Alexander Seville on 4/6/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface CPParseClient : NSObject

+ (CPParseClient *)instance;

- (void) save:(PFObject *)objectToSave;


@end
