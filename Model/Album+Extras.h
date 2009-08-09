//
//  Album+Extras.h
//  iPod
//
//  Created by Daniel Tull on 09.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "Album.h"

@interface Album (Extras)
- (NSComparisonResult)compare:(Album *)album;
@end
