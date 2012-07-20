//
//  GenresViewController.m
//  Fourgy
//
//  Created by Daniel Tull on 20.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "GenresViewController.h"

@implementation GenresViewController

- (NSString *)titleForItem:(DCTGenre *)genre {
	return genre.name;
}

@end
