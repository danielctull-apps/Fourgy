//
//  DTListViewController.m
//  iPod
//
//  Created by Daniel Tull on 09.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTListViewController.h"
#import "DTiPodBlockScroller.h"

@implementation DTListViewController

@synthesize itemsView, items;

- (id)initWithItems:(NSArray *)someItems {
	
	if (!(self = [self initWithNibName:@"DTScreenView" bundle:nil])) return nil;
	
	items = [[someItems sortedArrayUsingSelector:@selector(compare:)] retain];
	
	return self;
}

- (id)initWithComparedItems:(NSArray *)someItems {
	
	if (!(self = [super init])) return nil;
	
	items = [someItems retain];
	
	return self;
}

- (void)dealloc {
	[items release];
	[itemsView release];
	[super dealloc];	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	DTiPodBlockScroller *scroller = [[DTiPodBlockScroller alloc] init];
	itemsView.scroller = scroller;
	[scroller release];
	itemsView.scroller.knobInsets = UIEdgeInsetsMake(2.0, 4.0, 4.0, 4.0);
	itemsView.itemsInsets = UIEdgeInsetsMake(1.0, 0.0, 0.0, 2.0);
	itemsView.backgroundColor = [UIColor colorWithRed:0.8 green:0.867 blue:0.937 alpha:1.0];
	itemsView.scrollerWidth = 18.0;
	if ([self.items count] <= 6) {
		itemsView.shouldShowScroller = NO;
		itemsView.itemsInsets = UIEdgeInsetsMake(1.0, 0.0, 0.0, 0.0);
	}
}

#pragma mark -
- (void)selected {}

- (BOOL)moveDown {
	if (itemsView.selectedIndex < [self.items count] - 1) {
		[itemsView moveToRow:itemsView.selectedIndex + 1];
		return YES;
	}
	return NO;
}

- (BOOL)moveUp {
	if (itemsView.selectedIndex > 0) {
		[itemsView moveToRow:itemsView.selectedIndex - 1];
		return YES;
	}
	return NO;
}

#pragma mark -
#pragma mark Block View DataSource Methods

- (NSInteger)numberOfRowsForBlockView:(DTBlockView *)blockView {
	return [self.items count];
}

- (NSInteger)numberOfRowsToDisplayInBlockView:(DTBlockView *)blockView {
	return 6;
}

- (UIView<DTBlockViewCellProtocol> *)blockView:(DTBlockView *)blockView blockViewCellForRow:(NSInteger)rowIndex {
	return nil;
}


@end
