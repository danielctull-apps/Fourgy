//
//  DTPlayingScreenViewController.h
//  iPod
//
//  Created by Daniel Tull on 23.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface DTPlayingScreenViewController : UIViewController {
	UILabel *artistLabel, *albumLabel, *trackNameLabel, *trackNumberLabel;
	
	MPMediaItem *nowPlaying;
	MPMusicPlayerController *iPod;
	
}

@property (nonatomic, retain) IBOutlet UILabel *artistLabel, *albumLabel, *trackNameLabel, *trackNumberLabel;
@property (nonatomic, retain) MPMediaItem *nowPlaying;

- (id)initWithMediaItem:(MPMediaItem *)theItem mediaCollection:(MPMediaItemCollection *)aCollection;
- (void)refreshPlaying;
- (void)selected;
- (void)moveUp;
- (void)moveDown;
@end
