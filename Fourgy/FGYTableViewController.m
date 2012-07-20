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
#import "_FGYScroller.h"

@interface FGYTableViewController ()
@property (nonatomic, weak) IBOutlet _FGYScroller *scroller;
@end

@implementation FGYTableViewController {
	__strong NSIndexPath *_selectedIndexPath;
	__strong _FGYTableViewScrollHandler *_scrollHandler;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	NSBundle *bundle = [Fourgy bundle];
	self = [super initWithNibName:@"FGYTableViewController" bundle:bundle];
    if (!self) return nil;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.rowHeight = [Fourgy rowHeight];
	self.tableView.backgroundColor = [Fourgy backgroundColor];
	self.view.backgroundColor = [Fourgy backgroundColor];
	_selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	_scrollHandler = [[_FGYTableViewScrollHandler alloc] initWithTableView:self.tableView];
	
	[self.tableView selectRowAtIndexPath:_selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
	
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.selectedBackgroundView = [UIView new];
	cell.selectedBackgroundView.backgroundColor = [Fourgy foregroundColor];
	
	NSInteger numberOfitems = 0;
	NSInteger numberOfSections = [self.tableView numberOfSections];
	for (NSInteger i = 0; i < numberOfSections; i++)
		numberOfitems += [self.tableView numberOfRowsInSection:i];
	
	if (numberOfitems > 6) {
		CGRect frame = self.view.bounds;
		frame.size.width -= 20.0f;
		self.tableView.frame = frame;
	} else {
		self.scroller.hidden = YES;
	}
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
	if ([_scrollHandler clickWheelTouchesMovedToAngle:angle distance:distance]) {
		[self.fgy_controller click];
		[self.scroller setNeedsDisplay];
	}
}

@end
