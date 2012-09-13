//
//  AppDelegate.m
//  FourgyApp
//
//  Created by Daniel Tull on 18.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "AppDelegate.h"
#import <Fourgy/Fourgy.h>
#import <DCTMusicModel/DCTMusicModel.h>
#import "MenuViewController.h"
#import "ImportingViewController.h"

@implementation AppDelegate {
	__strong DCTMusicModel *_musicModel;
	__strong FGYController *fourgyController;
}

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	if ([[UIScreen mainScreen] bounds].size.height > 480.0f)
		[application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

	_musicModel = [DCTMusicModel new];
	
	MenuViewController *vc = [[MenuViewController alloc] initWithManagedObjectContext:_musicModel.managedObjectContext];
	fourgyController = [[FGYController alloc] initWithRootViewController:vc];
	
	if (_musicModel.importing) {
		ImportingViewController *importingVC = [[ImportingViewController alloc] initWithMusicModel:_musicModel];
		[fourgyController pushViewController:importingVC animated:NO];
	}
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = fourgyController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end