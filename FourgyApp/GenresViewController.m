//
//  GenresViewController.m
//  Fourgy
//
//  Created by Daniel Tull on 20.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "GenresViewController.h"
#import "SongsViewController.h"

@implementation GenresViewController

- (NSString *)titleForItem:(DCTGenre *)genre {
	return genre.name;
}

- (void)clickWheelCenterButtonTapped {
	DCTGenre *genre = [self.dataSource objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
	NSArray *songs = [genre.songs allObjects];
	SongsViewController *vc = [[SongsViewController alloc] initWithItems:songs];
	vc.title = genre.name;
	[self.fgy_controller pushViewController:vc animated:YES];
}

@end
