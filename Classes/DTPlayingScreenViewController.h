//
//  DTPlayingScreenViewController.h
//  iPod
//
//  Created by Daniel Tull on 23.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DTTickingLabel.h"

@interface DTPlayingScreenViewController : UIViewController {
	DTTickingLabel *trackNameLabel;
	UILabel *artistLabel, *albumLabel, *trackNumberLabel;
	
	MPMediaItem *nowPlaying;
	MPMusicPlayerController *iPod;
	
}

@property (nonatomic, retain) IBOutlet DTTickingLabel *trackNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *artistLabel, *albumLabel, *trackNumberLabel;
@property (nonatomic, retain) MPMediaItem *nowPlaying;

- (id)initWithMediaItem:(MPMediaItem *)theItem mediaCollection:(MPMediaItemCollection *)aCollection;
- (void)refreshPlaying;
- (void)selected;
- (void)moveUp;
- (void)moveDown;
@end
