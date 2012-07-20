//
//  ArtistsViewController.m
//  Fourgy
//
//  Created by Daniel Tull on 19.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "ArtistsViewController.h"

@implementation ArtistsViewController

- (NSString *)titleForItem:(DCTArtist *)artist {
	return artist.name;
}

@end
