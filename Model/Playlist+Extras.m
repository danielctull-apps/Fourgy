//
//  Playlist+Extras.m
//  iPod
//
//  Created by Daniel Tull on 09.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "Playlist+Extras.h"


@implementation Playlist (Extras)

- (NSComparisonResult)compare:(Playlist *)playlist {
	return [self.name compare:playlist.name];
}

@end
