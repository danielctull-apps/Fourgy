//
//  Song+MPMediaItemExtras.h
//  iPod
//
//  Created by Daniel Tull on 08.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "Song.h"
#import <MediaPlayer/MediaPlayer.h>

@interface Song (MPMediaItemExtras)
- (UIImage *)artworkImageWithSize:(CGSize)imageSize;
- (MPMediaItem *)mediaItem;

- (NSComparisonResult)compare:(Song *)song;
@end
