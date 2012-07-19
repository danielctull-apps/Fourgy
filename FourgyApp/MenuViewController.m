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

@implementation MenuViewController {
	__strong DCTArrayTableViewDataSource *_dataSource;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	self = [self init];
	if (!self) return nil;
	_managedObjectContext = managedObjectContext;
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.rowHeight = [Fourgy rowHeight];
	
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
		cell.selectedBackgroundView = [UIView new];
		cell.selectedBackgroundView.backgroundColor = [Fourgy foregroundColor];
		cell.textLabel.highlightedTextColor = [Fourgy backgroundColor];
		cell.textLabel.text = title;
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

@end
