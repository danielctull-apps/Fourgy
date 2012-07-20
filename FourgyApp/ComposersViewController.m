//
//  ComposersViewController.m
//  Fourgy
//
//  Created by Daniel Tull on 20.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "ComposersViewController.h"
#import "SongsViewController.h"

@implementation ComposersViewController

- (NSString *)titleForItem:(DCTComposer *)composer {
	return composer.name;
}

- (void)clickWheelCenterButtonTapped {
	DCTComposer *composer = [self.dataSource objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
	NSArray *songs = [composer.songs allObjects];
	SongsViewController *vc = [[SongsViewController alloc] initWithItems:songs];
	vc.title = composer.name;
	[self.fgy_controller pushViewController:vc animated:YES];
}

@end
