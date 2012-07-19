//
//  DTPlayingScreenViewController.h
//  iPod
//
//  Created by Daniel Tull on 23.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface NowPlayingViewController : UIViewController
- (id)initWithMediaItem:(MPMediaItem *)theItem mediaCollection:(MPMediaItemCollection *)aCollection;
@property (nonatomic, strong) MPMediaItem *nowPlaying;
@end
