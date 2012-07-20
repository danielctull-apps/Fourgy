//
//  AlbumsViewController.m
//  Fourgy
//
//  Created by Daniel Tull on 20.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "AlbumsViewController.h"
#import <DCTMusicModel/DCTMusicModel.h>
#import "SongsViewController.h"

@implementation AlbumsViewController

- (NSString *)titleForItem:(DCTAlbum *)album {
	return album.title;
}

- (void)clickWheelCenterButtonTapped {
	DCTAlbum *album = [self.dataSource objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
	NSArray *songs = [album.songs allObjects];
	
	NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DCTSongAttributes.trackNumber ascending:YES]];
	NSArray *items = [songs sortedArrayUsingDescriptors:sortDescriptors];
	SongsViewController *vc = [[SongsViewController alloc] initWithItems:items];
	vc.title = album.title;
	[self.fgy_controller pushViewController:vc animated:YES];
}

@end
