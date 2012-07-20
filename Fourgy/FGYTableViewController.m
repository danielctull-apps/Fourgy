//
//  FGYTableViewController.m
//  Fourgy
//
//  Created by Daniel Tull on 20.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "FGYTableViewController.h"
#import "Fourgy.h"
#import "_FGYTableViewScrollHandler.h"

@implementation FGYTableViewController {
	__strong NSIndexPath *_selectedIndexPath;
	__strong _FGYTableViewScrollHandler *_scrollHandler;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	NSBundle *bundle = [Fourgy bundle];
	self = [super initWithNibName:@"FGYTableViewController" bundle:bundle];
    if (!self) return nil;
	
	NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
	
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.rowHeight = [Fourgy rowHeight];
	_selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	_scrollHandler = [[_FGYTableViewScrollHandler alloc] initWithTableView:self.tableView fourgyController:self.fgy_controller];
	
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

#pragma mark - FGYClickWheelDelegate

- (void)clickWheelMenuButtonTapped {
	[self.fgy_controller popViewControllerAnimated:YES];
}

- (void)clickWheelTouchesMovedToAngle:(CGFloat)angle distance:(CGFloat)distance {
	[_scrollHandler clickWheelTouchesMovedToAngle:angle distance:distance];
}

@end
