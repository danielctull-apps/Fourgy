//
//  iPodAppDelegate.m
//  iPod
//
//  Created by Daniel Tull on 13.07.2009.
//  Copyright Daniel Tull 2009. All rights reserved.
//

#import "iPodAppDelegate.h"

#import "DTiPodViewController.h"

#import "DTMusicModelController.h"


@implementation iPodAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicModelUpdateProgress:) name:DTMusicModelUpdatingProgressNotification object:nil];
	
	
	DTiPodViewController *iPodVC = [[DTiPodViewController alloc] init];
	[window addSubview:iPodVC.view];
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
	
	//DTMusicModelController *model = [[DTMusicModelController alloc] init];
	
	//NSLog(@"%@:%s BEFORE GET ALL ARTISTS", self, _cmd);
	//NSArray *albums = [model allArtists];
	//NSLog(@"%@:%s %@", self, _cmd, [[albums objectAtIndex:0] name]);
}

- (void)musicModelUpdateProgress:(NSNotification *)notification {
	
	NSLog(@"%@/%@ %@/%@",
		  [[notification userInfo] objectForKey:DTMusicModelAmountOfTracksFinishedProcessingKey],
		  [[notification userInfo] objectForKey:DTMusicModelAmountOfTracksToProcessKey],
		  [[notification userInfo] objectForKey:DTMusicModelAmountOfPlaylistsFinishedProcessingKey],
		  [[notification userInfo] objectForKey:DTMusicModelAmountOfPlaylistsToProcessKey]);
	
}

- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
