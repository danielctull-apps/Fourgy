//
//  UITableViewController+_FGYClickWheelDelegate.m
//  Fourgy
//
//  Created by Daniel Tull on 18.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "UITableViewController+_FGYClickWheelDelegate.h"
#import "FGYController.h"

@implementation UITableViewController (_FGYClickWheelDelegate)

- (void)clickWheelTouchesBegan {
	
}

- (void)clickWheelCenterButtonTapped {
	
	UITableView *tableView = self.tableView;
	id<UITableViewDelegate> delegate = tableView.delegate;
		
	if ([delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
		[delegate tableView:tableView didSelectRowAtIndexPath:[tableView indexPathForSelectedRow]];
}

- (void)clickWheelMenuButtonTapped {
	[self.fgy_controller popViewControllerAnimated:YES];
}

- (void)clickWheelTouchesMovedToAngle:(CGFloat)angle distance:(CGFloat)distance {
	
	[self performSelector:@selector(moveDown) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES modes:@[UITrackingRunLoopMode]];
	
	[self.fgy_controller click];
}

- (void)moveDown {
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	indexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
	[self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
}


@end
