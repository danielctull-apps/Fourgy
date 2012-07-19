//
//  DTPlayingScreenViewController.m
//  iPod
//
//  Created by Daniel Tull on 23.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "NowPlayingViewController.h"
#import <Fourgy/Fourgy.h>

@interface NowPlayingViewController ()
@property (nonatomic, weak) IBOutlet FGYTickingLabel *trackNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistLabel;
@property (nonatomic, weak) IBOutlet UILabel *albumLabel;
@property (nonatomic, weak) IBOutlet UILabel *trackNumberLabel;
@end

@implementation NowPlayingViewController {
	MPMusicPlayerController *_iPod;
	MPMediaItemCollection *_musicQueue;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
												  object:_iPod];
}


- (id)initWithMediaItem:(MPMediaItem *)theItem mediaCollection:(MPMediaItemCollection *)aCollection {
	
	self = [self init];
	if (!self) return nil;
	
	_iPod = [MPMusicPlayerController iPodMusicPlayer];
	
	if (_iPod.playbackState == MPMusicPlaybackStatePlaying) {
		if (![[theItem valueForProperty:MPMediaItemPropertyPersistentID] isEqualToNumber:[[_iPod nowPlayingItem] valueForProperty:MPMediaItemPropertyPersistentID]]) {
			[_iPod stop];
			[_iPod setQueueWithItemCollection:aCollection];
			_iPod.nowPlayingItem = theItem;
			[_iPod play];
		}
	} else {
		[_iPod stop];
		[_iPod setQueueWithItemCollection:aCollection];
		_iPod.nowPlayingItem = theItem;
		[_iPod play];
	}
	
	_musicQueue = aCollection;
	
	[_iPod beginGeneratingPlaybackNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(trackChanged:)
												 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
											   object:_iPod];
	
	
	
	return self;
}

- (void)viewDidLoad {
	self.trackNameLabel.speed = 30.0;
	self.trackNameLabel.delay = 5.0;
    [super viewDidLoad];
	[self refreshPlaying];
}

- (void)trackChanged:(NSNotification *)notification {
	[self refreshPlaying];
}

- (void)refreshPlaying {
	if (_iPod.playbackState == MPMusicPlaybackStateStopped) {
		[self.navigationController popToRootViewControllerAnimated:YES];
		return;
	}
	
	self.nowPlaying = _iPod.nowPlayingItem;
	self.artistLabel.text = [self.nowPlaying valueForProperty:MPMediaItemPropertyArtist];
	self.trackNameLabel.text = [self.nowPlaying valueForProperty:MPMediaItemPropertyTitle];
	self.albumLabel.text = [self.nowPlaying valueForProperty:MPMediaItemPropertyAlbumTitle];
	
	NSInteger trackNumber = 0;
	for (NSInteger i = 0; i < _musicQueue.count; i++)
		if ([[_musicQueue.items objectAtIndex:i] isEqual:self.nowPlaying])
			trackNumber = i+1;
	
	self.trackNumberLabel.text = [NSString stringWithFormat:@"%i of %i", trackNumber, [_musicQueue count]];
}

@end
