//
//  SongsViewController.m
//  Fourgy
//
//  Created by Daniel Tull on 19.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "SongsViewController.h"
#import "NowPlayingViewController.h"

@implementation SongsViewController

- (NSString *)titleForItem:(DCTSong *)song {
	return song.title;
}

- (void)clickWheelCenterButtonTapped {
	
	NSMutableArray *mediaitems = [[NSMutableArray alloc] init];
	[self.dataSource.array enumerateObjectsUsingBlock:^(DCTSong *song, NSUInteger idx, BOOL *stop) {
		[mediaitems addObject:[song mediaItem]];
	}];
	
	DCTSong *song = [self.dataSource objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
	MPMediaItem *mediaItem = [song mediaItem];
	MPMediaItemCollection *collection = [MPMediaItemCollection collectionWithItems:mediaitems];
	NowPlayingViewController *vc = [[NowPlayingViewController alloc] initWithMediaItem:mediaItem collection:collection];
	[self.fgy_controller pushViewController:vc animated:YES];
}

@end
