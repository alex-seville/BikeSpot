//
//  CPAppDelegate.m
//  GroupProject
//
//  Created by Alexander Seville on 4/2/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPAppDelegate.h"
#import <Parse/Parse.h>
#import "CPRack.h"
#import "CPParseClient.h"
#import "CPSignInViewController.h"

@implementation CPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [CPParseClient instance];
    
    [PFFacebookUtils initializeFacebook];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRootViewController) name:UserLogOutNotification object:nil];
    
    /*
    CPRack *testObject = [[CPRack alloc] initWithDictionary:@{
                            @"name": @"Test Bike Rack",
                            @"isInGarage": @NO,
                            @"isCommercial": @YES,
                            @"safetyRating": @3,
                            @"longDescription": @"This is a long description",
                            @"rackPhotoName": @"test.png",
                            @"geoLocation": [[PFGeoPoint alloc] init]
                        }];
    
    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        NSString *objectId = testObject.objectId;
        PFQuery *query = [PFQuery queryWithClassName:@"CPRack"];
        [query getObjectInBackgroundWithId:objectId block:^(PFObject *bikeRack, NSError *error) {
            // Do something with the returned PFObject in the bikeRack variable.
            NSLog(@"%@", (CPRack *)bikeRack);
        }];
    }];
    */
    
    
   
    
    /* end parse test */
    
    /* test sign up and logging in */
    /*
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMMddyyyyHHmmssz"];
    NSString *temp = [format stringFromDate:[NSDate date]];
    NSString *newUsername = [NSString stringWithFormat:@"user%@", temp];
    NSString *newPassword = @"myPassword";
    NSString *newEmail = [NSString stringWithFormat:@"user%@@eugenialeong.com", temp];
    CPUser *testUser = [[CPUser alloc] initWithDictionary:@{
                                                              @"username": newUsername,
                                                              @"firstname": @"Eugenia",
                                                              @"lastname": @"Leong",
                                                              @"password": newPassword,
                                                              @"email": newEmail
                                                              }];

    [testUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"User %@ signed up!", newUsername);
            
            // try loggin in
            [PFUser logInWithUsernameInBackground:newUsername password:newPassword
                                            block:^(PFUser *user, NSError *error) {
                                                if (user) {
                                                    // get current user info
                                                    CPUser *currentUser = [CPUser currentUser];
                                                    if (currentUser) {
                                                        NSLog(@"User %@ has real name: %@ %@", currentUser.username, currentUser.firstname, currentUser.lastname);
                                                    } else {
                                                        NSLog(@"User not signed in");
                                                    }
                                                } else {
                                                    // The login failed. Check error to see why.
                                                    NSLog(@"Log in failed: %@", [error userInfo][@"error"]);
                                                }
                                            }];
            
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            NSLog(@"Error signing user %@ up: %@", newUsername, errorString);
        }
    }];
    */
    
    //CPViewLocationViewController *vc = [[CPViewLocationViewController alloc] init];
    CPSignInViewController *vc = [[CPSignInViewController alloc] init];

    //CPViewLocationViewController *vc = [[CPViewLocationViewController alloc] init];
    //CPSignInViewController *vc = [[CPSignInViewController alloc] init];

    self.window.rootViewController = vc;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
