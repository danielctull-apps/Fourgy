//
//  SongsViewController.m
//  Fourgy
//
//  Created by Daniel Tull on 19.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "SongsViewController.h"
#import "NowPlayingViewController.h"

@implementation SongsViewController

- (NSString *)titleForItem:(DCTSong *)song {
	return song.title;
}

- (void)clickWheelCenterButtonTapped {
	NowPlayingViewController *vc = [NowPlayingViewController new];
	[self.fgy_controller pushViewController:vc animated:YES];
}

@end
