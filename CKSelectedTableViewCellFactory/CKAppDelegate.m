//
//  CKAppDelegate.m
//  CKSelectedTableViewCellFactory
//
//  Created by Cody Kimberling on 7/28/13.
//  Copyright (c) 2013 Cody Kimberling. All rights reserved.
//

#import "CKAppDelegate.h"

@implementation CKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end