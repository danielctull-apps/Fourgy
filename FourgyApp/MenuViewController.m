//
//  MenuViewController.m
//  Fourgy
//
//  Created by Daniel Tull on 19.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "MenuViewController.h"
#import <Fourgy/Fourgy.h>
#import <DCTTableViewDataSources/DCTTableViewDataSources.h>

#import "SongsViewController.h"
#import "ArtistsViewController.h"
#import "AlbumsViewController.h"
#import "PlaylistsViewController.h"
#import "GenresViewController.h"
#import "ComposersViewController.h"

#import "NowPlayingViewController.h"

@implementation MenuViewController {
	__strong NSIndexPath *_selectedIndexPath;
	__strong NSManagedObjectContext *_managedObjectContext;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	self = [super initWithItems:@[@"Artists", @"Albums", @"Songs", @"Playlists", @"Genres", @"Composers"]];
	if (!self) return nil;
	_managedObjectContext = managedObjectContext;
	self.title = @"Fourgy";
	return self;
}

- (NSString *)titleForItem:(NSString *)title {
	return title;
}

- (void)clickWheelCenterButtonTapped {
	_selectedIndexPath = [self.tableView indexPathForSelectedRow];
	NSString *title = [self.dataSource objectAtIndexPath:_selectedIndexPath];
	
	Class viewControllerClass = NULL;
	NSFetchRequest *fetchRequest = [NSFetchRequest new];
	fetchRequest.fetchBatchSize = 6;
	
	if ([title isEqualToString:@"Artists"]) {
		fetchRequest.entity = [DCTArtist entityInManagedObjectContext:_managedObjectContext];
		fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DCTArtistAttributes.name ascending:YES]];
		viewControllerClass = [ArtistsViewController class];
		
	} else if ([title isEqualToString:@"Songs"]) {
		fetchRequest.entity = [DCTSong entityInManagedObjectContext:_managedObjectContext];
		fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DCTSongAttributes.title ascending:YES]];
		viewControllerClass = [SongsViewController class];
	
	} else if ([title isEqualToString:@"Albums"]) {
		fetchRequest.entity = [DCTAlbum entityInManagedObjectContext:_managedObjectContext];
		fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DCTAlbumAttributes.title ascending:YES]];
		viewControllerClass = [AlbumsViewController class];
	
	} else if ([title isEqualToString:@"Playlists"]) {
		fetchRequest.entity = [DCTPlaylist entityInManagedObjectContext:_managedObjectContext];
		fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DCTPlaylistAttributes.name ascending:YES]];
		viewControllerClass = [PlaylistsViewController class];
	
	} else if ([title isEqualToString:@"Genres"]) {
		fetchRequest.entity = [DCTGenre entityInManagedObjectContext:_managedObjectContext];
		fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DCTGenreAttributes.name ascending:YES]];
		viewControllerClass = [GenresViewController class];
	
	} else if ([title isEqualToString:@"Composers"]) {
		fetchRequest.entity = [DCTComposer entityInManagedObjectContext:_managedObjectContext];
		fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DCTComposerAttributes.name ascending:YES]];
		viewControllerClass = [ComposersViewController class];
	}
	
	if (viewControllerClass) {
		NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:nil];
		UIViewController *vc = [[viewControllerClass alloc] initWithItems:items];
		vc.title = title;
		[self.fgy_controller pushViewController:vc animated:YES];
	}
}

@end
