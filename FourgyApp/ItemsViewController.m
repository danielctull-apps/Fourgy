//
//  ItemsViewController.m
//  Fourgy
//
//  Created by Daniel Tull on 20.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "ItemsViewController.h"
#import <Fourgy/Fourgy.h>

@implementation ItemsViewController {
	__strong NSIndexPath *_selectedIndexPath;
	__strong NSArray *_items;
	__strong NSManagedObjectContext *_managedObjectContext;
}

- (id)initWithItems:(NSArray *)items {
	self = [self init];
	if (!self) return nil;
	_items = [items copy];
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView selectRowAtIndexPath:_selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
	
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.selectedBackgroundView = [UIView new];
	cell.selectedBackgroundView.backgroundColor = [Fourgy foregroundColor];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	_selectedIndexPath = [self.tableView indexPathForSelectedRow];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.rowHeight = [Fourgy rowHeight];
	self.tableView.showsVerticalScrollIndicator = NO;
	self.tableView.showsHorizontalScrollIndicator = NO;
	_selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	
	_dataSource = [DCTArrayTableViewDataSource new];
	_dataSource.array = _items;
	_dataSource.tableView = self.tableView;
	self.tableView.dataSource = _dataSource;
	
	__weak ItemsViewController *weakSelf = self;	
	[_dataSource setCellConfigurer:^(UITableViewCell *cell, NSIndexPath *indexPath, id object) {
		cell.textLabel.font = [Fourgy fontOfSize:12.0f];
		cell.textLabel.textColor = [Fourgy foregroundColor];
		cell.textLabel.backgroundColor = [Fourgy backgroundColor];
		cell.contentView.backgroundColor = [Fourgy backgroundColor];
		cell.backgroundColor = [Fourgy backgroundColor];
		cell.textLabel.highlightedTextColor = [Fourgy backgroundColor];
		cell.textLabel.text = [weakSelf titleForItem:object];
	}];
}

- (NSString *)titleForItem:(id)item {
	return [item description];
}

@end
