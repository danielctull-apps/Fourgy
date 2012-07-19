//
//  UITableViewController+_FGYClickWheelDelegate.m
//  Fourgy
//
//  Created by Daniel Tull on 18.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "UITableViewController+_FGYClickWheelDelegate.h"
#import "FGYController.h"
#import <objc/runtime.h>

@interface FGYTableViewControllerScrollHandler : NSObject
- (id)initWithTableViewController:(UITableViewController *)tableViewController;
- (void)clickWheelTouchesMovedToAngle:(CGFloat)angle distance:(CGFloat)distance;
@end

@implementation UITableViewController (_FGYClickWheelDelegate)

- (FGYTableViewControllerScrollHandler *)fgy_scrollHandler {
	
	FGYTableViewControllerScrollHandler *handler = objc_getAssociatedObject(self, _cmd);
	
	if (!handler) {
		handler = [[FGYTableViewControllerScrollHandler alloc] initWithTableViewController:self];
		objc_setAssociatedObject(self, _cmd, handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return handler;
}

- (void)clickWheelMenuButtonTapped {
	[self.fgy_controller popViewControllerAnimated:YES];
}

- (void)clickWheelTouchesMovedToAngle:(CGFloat)angle distance:(CGFloat)distance {
	[[self fgy_scrollHandler] clickWheelTouchesMovedToAngle:angle distance:distance];
}

@end

@implementation FGYTableViewControllerScrollHandler {
	__weak UITableViewController *_tableViewController;
	
	
	CGFloat oldAngle;
	CGFloat difference;
	NSInteger rotations;
	CGFloat rotation360check;
}

- (id)initWithTableViewController:(UITableViewController *)tableViewController {
	self = [self init];
	if (!self) return nil;
	_tableViewController = tableViewController;
	return self;
}


- (void)clickWheelTouchesMovedToAngle:(CGFloat)angle distance:(CGFloat)distance {
	
	if (oldAngle == 500.0) {
		rotations = 0;
		rotation360check = 0;
		//DTScreenTableViewController *tableController = (DTScreenTableViewController *)nav.visibleViewController;
		//[tableController.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
		oldAngle = angle;
		return;
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
		
		if([self moveDown])
			[_tableViewController.fgy_controller click];
		
		difference = 0.0;
		
	} else if (difference < -22.5) {
		
		for (NSInteger i = 1; i < rotations; i++)
			[self moveUp];
		
		if ([self moveUp])
			[_tableViewController.fgy_controller click];
		
		difference = 0.0;
		
	}
	
}

- (BOOL)moveSelectionFromOldIndexPath:(NSIndexPath *)oldIndexPath newIndexPath:(NSIndexPath *)newIndexPath {
	
	if (!newIndexPath) return NO;
	if (!oldIndexPath) return NO;
	if ([oldIndexPath isEqual:newIndexPath]) return NO;
	
	if ([newIndexPath compare:[NSIndexPath indexPathForRow:0 inSection:0]] == NSOrderedAscending)
		return NO;
	
	NSInteger lastSection = [_tableViewController.tableView numberOfSections] - 1;
	if (lastSection < 0) lastSection = 0;
	NSInteger lastRow = [_tableViewController.tableView numberOfRowsInSection:lastSection] - 1;
	if (lastRow < 0) lastRow = 0;
	if ([newIndexPath compare:[NSIndexPath indexPathForRow:lastRow inSection:lastSection]] == NSOrderedDescending)
		return NO;
	
	UITableViewScrollPosition position = UITableViewScrollPositionNone;
	NSArray *visibleIndexPaths = [_tableViewController.tableView indexPathsForVisibleRows];
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
	
	UITableViewCell *oldCell = [_tableViewController.tableView cellForRowAtIndexPath:oldIndexPath];
	UIView *bg = oldCell.selectedBackgroundView;
	oldCell.selectionStyle = UITableViewCellSelectionStyleNone;
	oldCell.selectedBackgroundView = nil;
	
	[_tableViewController.tableView selectRowAtIndexPath:newIndexPath animated:NO scrollPosition:position];
	
	UITableViewCell *newCell = [_tableViewController.tableView cellForRowAtIndexPath:newIndexPath];
	newCell.selectionStyle = UITableViewCellSelectionStyleBlue;
	newCell.selectedBackgroundView = bg;
	
	return YES;
}

- (BOOL)moveDown {
	NSIndexPath *oldIndexPath = [_tableViewController.tableView indexPathForSelectedRow];
	NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:oldIndexPath.row+1 inSection:oldIndexPath.section];
	return [self moveSelectionFromOldIndexPath:oldIndexPath newIndexPath:newIndexPath];
}

- (BOOL)moveUp {
	NSIndexPath *oldIndexPath = [_tableViewController.tableView indexPathForSelectedRow];
	NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:oldIndexPath.row-1 inSection:oldIndexPath.section];
	return [self moveSelectionFromOldIndexPath:oldIndexPath newIndexPath:newIndexPath];
}

@end
