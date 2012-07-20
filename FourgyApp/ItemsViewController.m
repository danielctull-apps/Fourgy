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
	__strong NSArray *_items;
	__strong NSManagedObjectContext *_managedObjectContext;
}

- (id)initWithItems:(NSArray *)items {
	self = [self init];
	if (!self) return nil;
	_items = [items copy];
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_dataSource = [DCTArrayTableViewDataSource new];
	_dataSource.array = _items;
	_dataSource.cellClass = [FGYTableViewCell class];
	_dataSource.tableView = self.tableView;
	self.tableView.dataSource = _dataSource;
	
	__weak ItemsViewController *weakSelf = self;	
	[_dataSource setCellConfigurer:^(FGYTableViewCell *cell, NSIndexPath *indexPath, id object) {
		cell.text = [weakSelf titleForItem:object];
	}];
}

- (NSString *)titleForItem:(id)item {
	return [item description];
}

@end
