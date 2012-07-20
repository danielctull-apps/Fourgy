//
//  PlaylistsViewController.m
//  Fourgy
//
//  Created by Daniel Tull on 20.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "PlaylistsViewController.h"

@implementation PlaylistsViewController

- (NSString *)titleForItem:(DCTPlaylist *)playlist {
	return playlist.name;
}

@end
