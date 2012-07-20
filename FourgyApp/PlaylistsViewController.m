//
//  PlaylistsViewController.m
//  Fourgy
//
//  Created by Daniel Tull on 20.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "PlaylistsViewController.h"
#import "SongsViewController.h"

@implementation PlaylistsViewController

- (NSString *)titleForItem:(DCTPlaylist *)playlist {
	return playlist.name;
}

- (void)clickWheelCenterButtonTapped {
	DCTPlaylist *playlist = [self.dataSource objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
	NSArray *songs = [playlist.songs allObjects];
	SongsViewController *vc = [[SongsViewController alloc] initWithItems:songs];
	vc.title = playlist.name;
	[self.fgy_controller pushViewController:vc animated:YES];
}

@end
