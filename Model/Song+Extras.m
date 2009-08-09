//
//  Song+MPMediaItemExtras.m
//  iPod
//
//  Created by Daniel Tull on 08.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "Song+Extras.h"


@implementation Song (Extras)

- (UIImage *)artworkImageWithSize:(CGSize)imageSize {
	return [[[self mediaItem] valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:imageSize];
}

- (MPMediaItem *)mediaItem {
	
	MPMediaQuery *mediaQuery = [[MPMediaQuery alloc] init];
	MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:self.identifier forProperty:MPMediaItemPropertyPersistentID];
	[mediaQuery addFilterPredicate:predicate];
	
	if ([mediaQuery.items count] == 0) {
		[mediaQuery release];
		return nil;
	}
	
	MPMediaItem *mediaItem = [mediaQuery.items objectAtIndex:0];
	
	[mediaQuery release];
	
	return mediaItem;
}

- (NSComparisonResult)compare:(Song *)song {
	return [self.title compare:song.title];
}

- (NSComparisonResult)compareTrackNumber:(Song *)song {
	return [self.title compare:song.title];
}

@end
