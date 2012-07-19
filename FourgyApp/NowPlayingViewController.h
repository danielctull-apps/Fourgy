//
//  DTPlayingScreenViewController.h
//  iPod
//
//  Created by Daniel Tull on 23.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Fourgy/Fourgy.h>

@interface NowPlayingViewController : UIViewController <FGYClickWheelDelegate>
- (id)initWithMediaItem:(MPMediaItem *)item collection:(MPMediaItemCollection *)collection;
@end
