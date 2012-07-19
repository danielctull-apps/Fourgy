//
//  MediaItemsViewController.m
//  Fourgy
//
//  Created by Daniel Tull on 19.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "MediaItemsViewController.h"

@implementation MediaItemsViewController {
	__strong MPMediaQuery *_query;
	__strong NSString *_property;
}

- (id)initWithMediaQuery:(MPMediaQuery *)query property:(NSString *)property {
	self = [self init];
	if (!self) return nil;
	_query = query;
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [Fourgy rowHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1000;//[_query.collections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
		cell.textLabel.font = [Fourgy fontOfSize:12.0f];
		cell.textLabel.textColor = [Fourgy foregroundColor];
		cell.textLabel.backgroundColor = [Fourgy backgroundColor];
		cell.contentView.backgroundColor = [Fourgy backgroundColor];
		cell.backgroundColor = [Fourgy backgroundColor];
		cell.selectedBackgroundView = [UIView new];
		cell.selectedBackgroundView.backgroundColor = [Fourgy foregroundColor];
		cell.textLabel.highlightedTextColor = [Fourgy backgroundColor];
	}
	
	/*MPMediaItemCollection *collection = [_query.collections objectAtIndex:indexPath.row];
	MPMediaItem *item = collection.representativeItem;
	NSString *property = [MPMediaItem titlePropertyForGroupingType:_query.groupingType];
	cell.textLabel.text = [item valueForProperty:property];*/
	
	cell.textLabel.text = [NSString stringWithFormat:@"Cell number %i", indexPath.row];	
	
	return cell;
}


@end
