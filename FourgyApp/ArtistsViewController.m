//
//  ArtistsViewController.m
//  Fourgy
//
//  Created by Daniel Tull on 19.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "ArtistsViewController.h"
#import "SongsViewController.h"
#import "AlbumsViewController.h"

@implementation ArtistsViewController

- (NSString *)titleForItem:(DCTArtist *)artist {
	return artist.name;
}

- (void)clickWheelCenterButtonTapped {
	DCTArtist *artist = [self.dataSource objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
	NSArray *albums = [artist.albums allObjects];
	
	if ([albums count] <= 1) {
		
		NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DCTSongAttributes.trackNumber ascending:YES]];
		NSArray *items = [[artist.songs allObjects] sortedArrayUsingDescriptors:sortDescriptors];
		SongsViewController *vc = [[SongsViewController alloc] initWithItems:items];
		
		DCTAlbum *album = [albums lastObject];
		NSString *title = album.title;
		if ([title length] == 0) title = artist.name;
		vc.title = title;
		
		[self.fgy_controller pushViewController:vc animated:YES];
	} else {
		NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DCTAlbumAttributes.title ascending:YES]];
		NSArray *items = [albums sortedArrayUsingDescriptors:sortDescriptors];
		AlbumsViewController *vc = [[AlbumsViewController alloc] initWithItems:items];
		vc.title = artist.name;
		[self.fgy_controller pushViewController:vc animated:YES];
		
	}
	
}

@end
