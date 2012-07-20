//
//  AlbumsViewController.m
//  Fourgy
//
//  Created by Daniel Tull on 20.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "AlbumsViewController.h"
#import <DCTMusicModel/DCTMusicModel.h>

@implementation AlbumsViewController

- (NSString *)titleForItem:(DCTAlbum *)album {
	return album.title;
}

@end
