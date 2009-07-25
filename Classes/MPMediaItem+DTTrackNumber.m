//
//  MPMediaItem+DTTrackNumber.m
//  iPod
//
//  Created by Daniel Tull on 25.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "MPMediaItem+DTTrackNumber.h"


@implementation MPMediaItem (DTTrackNumber)


- (NSNumber *)albumTrackNumber {
	return [self valueForProperty:MPMediaItemPropertyAlbumTrackNumber];
}

@end
