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
#import <DCTMusicModel/DCTMusicModel.h>
#import "SongsViewController.h"
#import "ArtistsViewController.h"

#import "NowPlayingViewController.h"

@implementation MenuViewController {
	__strong DCTArrayTableViewDataSource *_dataSource;
	__strong NSIndexPath *_selectedIndexPath;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	self = [self init];
	if (!self) return nil;
	_managedObjectContext = managedObjectContext;
	self.title = @"Fourgy";
	return self;
}

- (void)clickWheelCenterButtonTapped {
		
	_selectedIndexPath = [self.tableView indexPathForSelectedRow];
	NSString *title = [_dataSource objectAtIndexPath:_selectedIndexPath];
	
	Class viewControllerClass = NULL;
	NSFetchRequest *fetchRequest = [NSFetchRequest new];
	
	if ([title isEqualToString:@"Artists"]) {
		fetchRequest.entity = [DCTArtist entityInManagedObjectContext:self.managedObjectContext];
		fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DCTArtistAttributes.name ascending:YES]];
		viewControllerClass = [ArtistsViewController class];
	} else if ([title isEqualToString:@"Songs"]) {
		fetchRequest.entity = [DCTSong entityInManagedObjectContext:self.managedObjectContext];
		fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DCTSongAttributes.title ascending:YES]];
		viewControllerClass = [SongsViewController class];
	}
	
	if (viewControllerClass) {
		fetchRequest.fetchBatchSize = 6;
		NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																			  managedObjectContext:self.managedObjectContext
																				sectionNameKeyPath:nil
																						 cacheName:nil];
		
		UIViewController *vc = [[viewControllerClass alloc] initWithFetchedResultsController:frc];
		[self.fgy_controller pushViewController:vc animated:YES];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView selectRowAtIndexPath:_selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
	
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.selectedBackgroundView = [UIView new];
	cell.selectedBackgroundView.backgroundColor = [Fourgy foregroundColor];
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.rowHeight = [Fourgy rowHeight];
	_selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	
	_dataSource = [DCTArrayTableViewDataSource new];
	_dataSource.array = @[@"Artists", @"Albums", @"Songs", @"Playlists", @"Genres", @"Composers"];
	_dataSource.tableView = self.tableView;
	self.tableView.dataSource = _dataSource;
	
	[_dataSource setCellConfigurer:^(UITableViewCell *cell, NSIndexPath *indexPath, NSString *title) {
		cell.textLabel.font = [Fourgy fontOfSize:12.0f];
		cell.textLabel.textColor = [Fourgy foregroundColor];
		cell.textLabel.backgroundColor = [Fourgy backgroundColor];
		cell.contentView.backgroundColor = [Fourgy backgroundColor];
		cell.backgroundColor = [Fourgy backgroundColor];
		cell.textLabel.highlightedTextColor = [Fourgy backgroundColor];
		cell.textLabel.text = title;
	}];
}

@end
