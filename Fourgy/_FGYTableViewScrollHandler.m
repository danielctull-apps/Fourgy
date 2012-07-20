//
//  UITableViewController+_FGYClickWheelDelegate.m
//  Fourgy
//
//  Created by Daniel Tull on 18.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "_FGYTableViewScrollHandler.h"
#import <objc/runtime.h>

@implementation _FGYTableViewScrollHandler {
	__strong UITableView *_tableView;
	
	CGFloat oldAngle;
	CGFloat difference;
	NSInteger rotations;
	CGFloat rotation360check;
}

- (id)initWithTableView:(UITableView *)tableView {
	self = [self init];
	if (!self) return nil;
	_tableView = tableView;
	return self;
}


- (BOOL)clickWheelTouchesMovedToAngle:(CGFloat)angle distance:(CGFloat)distance {
	
	if (oldAngle == 500.0) {
		rotations = 0;
		rotation360check = 0;
		//DTScreenTableViewController *tableController = (DTScreenTableViewController *)nav.visibleViewController;
		//[tableController.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
		oldAngle = angle;
		return NO;
	}
	
	CGFloat diff = angle - oldAngle;
	
	if ((rotation360check > 0 && diff < 0) || (rotation360check < 0 && diff > 0)) {
		rotation360check = 0;
		rotations = 0;
	}
	
	oldAngle = angle;
	
	if (diff < -180)
		diff += 360;
	else if (diff > 180)
		diff -= 360;
	
	if ((difference < 0 && diff > 0) || (difference > 0 && diff < 0))
		difference = 0.0;
	
	
	difference += diff;
	
	rotation360check += difference;
	
	if (rotation360check > 360 || rotation360check < -360) {
		rotations++;
		
		//if (rotations > 4)
		//	rotations = 4;
		
		rotation360check = 0;
	}
		
	if (difference > 22.5) {
		
		for (NSInteger i = 1; i < rotations; i++)
			[self moveDown];
		
		difference = 0.0;
		
		return [self moveDown];
		
	} else if (difference < -22.5) {
		
		for (NSInteger i = 1; i < rotations; i++)
			[self moveUp];
		
		difference = 0.0;
		
		return [self moveUp];
	}
	
	return NO;
}

- (BOOL)moveSelectionFromOldIndexPath:(NSIndexPath *)oldIndexPath newIndexPath:(NSIndexPath *)newIndexPath {
	
	if (!newIndexPath) return NO;
	if (!oldIndexPath) return NO;
	if ([oldIndexPath isEqual:newIndexPath]) return NO;
	
	if ([newIndexPath compare:[NSIndexPath indexPathForRow:0 inSection:0]] == NSOrderedAscending)
		return NO;
	
	NSInteger lastSection = [_tableView numberOfSections] - 1;
	if (lastSection < 0) lastSection = 0;
	NSInteger lastRow = [_tableView numberOfRowsInSection:lastSection] - 1;
	if (lastRow < 0) lastRow = 0;
	if ([newIndexPath compare:[NSIndexPath indexPathForRow:lastRow inSection:lastSection]] == NSOrderedDescending)
		return NO;
	
	UITableViewScrollPosition position = UITableViewScrollPositionNone;
	NSArray *visibleIndexPaths = [_tableView indexPathsForVisibleRows];
	if (![visibleIndexPaths containsObject:newIndexPath]) {
		
		NSComparisonResult result = [oldIndexPath compare:newIndexPath];
		
		switch (result) {
			case NSOrderedAscending:
				position = UITableViewScrollPositionBottom;
				break;
				
			case NSOrderedDescending:
				position = UITableViewScrollPositionTop;
				break;
			
			default:
				break;
		}
	}
	
	UITableViewCell *oldCell = [_tableView cellForRowAtIndexPath:oldIndexPath];
	UIView *bg = oldCell.selectedBackgroundView;
	oldCell.selectionStyle = UITableViewCellSelectionStyleNone;
	oldCell.selectedBackgroundView = nil;
	
	[_tableView selectRowAtIndexPath:newIndexPath animated:NO scrollPosition:position];
	
	UITableViewCell *newCell = [_tableView cellForRowAtIndexPath:newIndexPath];
	newCell.selectionStyle = UITableViewCellSelectionStyleBlue;
	newCell.selectedBackgroundView = bg;
	
	return YES;
}

- (BOOL)moveDown {
	NSIndexPath *oldIndexPath = [_tableView indexPathForSelectedRow];
	NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:oldIndexPath.row+1 inSection:oldIndexPath.section];
	return [self moveSelectionFromOldIndexPath:oldIndexPath newIndexPath:newIndexPath];
}

- (BOOL)moveUp {
	NSIndexPath *oldIndexPath = [_tableView indexPathForSelectedRow];
	NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:oldIndexPath.row-1 inSection:oldIndexPath.section];
	return [self moveSelectionFromOldIndexPath:oldIndexPath newIndexPath:newIndexPath];
}

@end
