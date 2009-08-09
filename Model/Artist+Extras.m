//
//  Artist+Sorting.m
//  iPod
//
//  Created by Daniel Tull on 09.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "Artist+Extras.h"

@implementation Artist (Extras)
- (NSComparisonResult)compare:(Artist *)artist {
	return [self.name compare:artist.name];
}
@end
