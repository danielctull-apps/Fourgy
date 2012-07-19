//
//  ArtistsViewController.m
//  Fourgy
//
//  Created by Daniel Tull on 19.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "ArtistsViewController.h"
#import <DCTTableViewDataSources/DCTTableViewDataSources.h>
#import <Fourgy/Fourgy.h>
#import <DCTMusicModel/DCTMusicModel.h>

@implementation ArtistsViewController {
	__strong DCTFetchedResultsTableViewDataSource *_dataSource;
}

- (id)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController {
	self = [self init];
	if (!self) return nil;
	_fetchedResultsController = fetchedResultsController;
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.rowHeight = [Fourgy rowHeight];
	
	_dataSource = [DCTFetchedResultsTableViewDataSource new];
	_dataSource.fetchedResultsController = self.fetchedResultsController;
	_dataSource.tableView = self.tableView;
	self.tableView.dataSource = _dataSource;
	
	[_dataSource setCellConfigurer:^(UITableViewCell *cell, NSIndexPath *indexPath, DCTArtist *artist) {
		cell.textLabel.font = [Fourgy fontOfSize:12.0f];
		cell.textLabel.textColor = [Fourgy foregroundColor];
		cell.textLabel.backgroundColor = [Fourgy backgroundColor];
		cell.contentView.backgroundColor = [Fourgy backgroundColor];
		cell.backgroundColor = [Fourgy backgroundColor];
		cell.selectedBackgroundView = [UIView new];
		cell.selectedBackgroundView.backgroundColor = [Fourgy foregroundColor];
		cell.textLabel.highlightedTextColor = [Fourgy backgroundColor];
		cell.textLabel.text = artist.name;
	}];
}

@end
