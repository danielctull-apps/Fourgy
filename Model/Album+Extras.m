//
//  Album+Extras.m
//  iPod
//
//  Created by Daniel Tull on 09.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "Album+Extras.h"


@implementation Album (Extras)

- (NSComparisonResult)compare:(Album *)album {
	return [self.title compare:album.title];
}

@end
