//
//  DTPlaybackTimeView.h
//  iPod
//
//  Created by Daniel Tull on 23.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface DTPlaybackTimeView : UIView {
	NSTimer *timer;
	MPMusicPlayerController *iPod;
	
	UILabel *playedLabel, *remainingLabel;
}

- (NSString *)timeStringForSeconds:(NSInteger)time;

@end
