//
//  AppDelegate.m
//  FourgyApp
//
//  Created by Daniel Tull on 18.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "AppDelegate.h"
#import <Fourgy/Fourgy.h>

@implementation AppDelegate {
	__strong FGYController *fourgyController;
}

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	UIViewController *vc = [UIViewController new];
	vc.view.backgroundColor = [UIColor greenColor];
	
	fourgyController = [[FGYController alloc] initWithRootViewController:vc];
	
	self.window.rootViewController = fourgyController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end