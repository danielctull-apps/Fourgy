//
//  iPodAppDelegate.m
//  iPod
//
//  Created by Daniel Tull on 13.07.2009.
//  Copyright Daniel Tull 2009. All rights reserved.
//

#import "iPodAppDelegate.h"
#import "DTiPodViewController.h"

@implementation iPodAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	DTiPodViewController *iPodVC = [[DTiPodViewController alloc] init];
	[window addSubview:iPodVC.view];
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
