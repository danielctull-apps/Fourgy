//
//  Genre+Extras.m
//  iPod
//
//  Created by Daniel Tull on 09.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "Genre+Extras.h"


@implementation Genre (Extras)

- (NSComparisonResult)compare:(Genre *)genre {
	return [self.name compare:genre.name];
}

@end
