//
//  CPParseClient.m
//  GroupProject
//
//  Created by Alexander Seville on 4/6/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPParseClient.h"
#import <Parse/Parse.h>
#import "CPRack.h"

@implementation CPParseClient

+ (CPParseClient *)instance {
    static CPParseClient *instance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        
        /* read in api config from plist */
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSString *plistPath;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        plistPath = [rootPath stringByAppendingPathComponent:@"ParseClient.plist"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"ParseClient" ofType:@"plist"];
        }
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                              propertyListFromData:plistXML
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              format:&format
                                              errorDescription:&errorDesc];
        if (!temp) {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        
        [Parse setApplicationId:[temp objectForKey:@"ApplicationKey"] clientKey:[temp objectForKey:@"ClientKey"]];
        
        
        /*  register CPRack model with parse */
        [CPRack registerSubclass];
        
        /* register CPUser model with parse */
        [CPUser registerSubclass];

        
        /* now create the instance */
        
        instance = [[CPParseClient alloc] init];
        
    });
    
    return instance;
}

- (void) save:(PFObject *)objectToSave {
    [objectToSave saveInBackground];
}

- (void) signUpWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email {
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"User %@ signed up!", username);
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            NSLog(@"Error signing user %@ up: %@", username, errorString);
        }
    }];
}

- (void) signUpWithUser:(CPUser *)user {
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"User %@ signed up!", user.username);
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            NSLog(@"Error signing user %@ up: %@", user.username, errorString);
        }
    }];
}

- (void) logInWithUsername:(NSString *)username password:(NSString *)password {
    
    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"User %@ logged in!", user.username);
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSLog(@"Log in failed: %@", [error userInfo][@"error"]);
                                        }
                                    }];
}

@end
