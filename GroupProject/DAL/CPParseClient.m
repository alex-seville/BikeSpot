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

        
        /* now create the instance */
        
        instance = [[CPParseClient alloc] init];
        
    });
    
    return instance;
}

- (void) save:(PFObject *)objectToSave {
    [objectToSave saveInBackground];
}

@end
