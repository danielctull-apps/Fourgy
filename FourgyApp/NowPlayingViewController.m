//
//  DTPlayingScreenViewController.m
//  iPod
//
//  Created by Daniel Tull on 23.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "NowPlayingViewController.h"

@interface NowPlayingViewController ()
@property (weak, nonatomic) IBOutlet FGYTickingLabel *trackNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackNumberLabel;
@property (weak, nonatomic) IBOutlet FGYProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *timeRemainingLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

void* NowPlayingViewControllerCurrentPlaybackTimeObservingContext = &NowPlayingViewControllerCurrentPlaybackTimeObservingContext;

@implementation NowPlayingViewController {
	NSTimer *_timer;
	MPMusicPlayerController *_iPod;
	MPMediaItemCollection *_musicQueue;
}
@synthesize timeRemainingLabel = _timeRemainingLabel;
@synthesize timeLabel = _timeLabel;

- (void)dealloc {
	[_timer invalidate];
	[_iPod endGeneratingPlaybackNotifications];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
												  object:_iPod];
}


- (id)init {
	self = [super init];
	if (!self) return nil;
	self.title = @"Now Playing";
		
	_iPod = [MPMusicPlayerController iPodMusicPlayer];
	_timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(_updatePositionTimer:) userInfo:nil repeats:YES];
		
	[_iPod beginGeneratingPlaybackNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(_trackDidChange:)
												 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
											   object:_iPod];
	
	return self;
}

- (id)initWithMediaItem:(MPMediaItem *)item collection:(MPMediaItemCollection *)collection {
	
	self = [self init];
	if (!self) return nil;
	
	NSNumber *itemID = [item valueForProperty:MPMediaItemPropertyPersistentID];
	NSNumber *nowPlayingID = [[_iPod nowPlayingItem] valueForProperty:MPMediaItemPropertyPersistentID];
	
	if (![nowPlayingID isEqualToNumber:itemID]) {
		[_iPod stop];
		[_iPod setQueueWithItemCollection:collection];
		_iPod.nowPlayingItem = item;
		[_iPod play];
	}
	
	_musicQueue = collection;
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.trackNameLabel.speed = 30.0;
	self.trackNameLabel.delay = 5.0;
	
	self.trackNameLabel.font = [Fourgy fontOfSize:12.0f];
	self.trackNumberLabel.font = [Fourgy fontOfSize:8.0f];
	self.artistLabel.font = [Fourgy fontOfSize:12.0f];
	self.albumLabel.font = [Fourgy fontOfSize:12.0f];
	self.timeLabel.font = [Fourgy fontOfSize:12.0f];
	self.timeRemainingLabel.font = [Fourgy fontOfSize:12.0f];
	
	[self _trackDidChange:nil];
}

- (void)_trackDidChange:(NSNotification *)notification {	
	self.artistLabel.text = [_iPod.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
	self.trackNameLabel.text = [_iPod.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
	self.albumLabel.text = [_iPod.nowPlayingItem valueForProperty:MPMediaItemPropertyAlbumTitle];
	self.trackNumberLabel.text = [NSString stringWithFormat:@"%i of %i", _iPod.indexOfNowPlayingItem+1, [_musicQueue count]];
	[self _updatePositionTimer:nil];
}

- (void)_updatePositionTimer:(NSTimer *)timer {
	NSInteger time = (NSInteger)_iPod.currentPlaybackTime;
	CGFloat duration = [[_iPod.nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue];
	NSInteger remaining = (NSInteger)duration - time;
	self.timeLabel.text = [self _timeStringForSeconds:time];
	self.timeRemainingLabel.text = [NSString stringWithFormat:@"-%@", [self _timeStringForSeconds:remaining]];
	self.progressView.progress = time/duration;
}

- (NSString *)_timeStringForSeconds:(NSInteger)time {
	
	NSString *hoursString = @"";
	NSString *minutesString = @"";
	NSString *secondsString = @"";
	
	NSInteger minutes = (NSInteger)(time / 60);
	NSInteger hours = 0;
	NSInteger seconds = time % 60;
	
	minutesString = [NSString stringWithFormat:@"%@:", [NSString stringWithFormat:@"%i", minutes]];
	
	if (minutes > 59) {
		hours = (NSInteger)(minutes / 60);
		hoursString = [NSString stringWithFormat:@"%@:", [NSString stringWithFormat:@"%i", hours]];
		minutes = minutes % 60;
		NSString *zero = (minutes < 10) ? @"0" : @"";
		minutesString = [NSString stringWithFormat:@"%@%i:", zero, minutes];
	}
	
	NSString *zero = (seconds < 10) ? @"0" : @"";
	secondsString = [NSString stringWithFormat:@"%@%i", zero, seconds];
	
	return [NSString stringWithFormat:@"%@%@%@", hoursString, minutesString, secondsString];
}

- (void)clickWheelMenuButtonTapped {
	[self.fgy_controller popViewControllerAnimated:YES];
}

- (void)clickWheelPreviousButtonTapped {
	if (_iPod.currentPlaybackTime < 5)
		[_iPod skipToPreviousItem];
	else
		[_iPod skipToBeginning];
}

- (void)clickWheelNextButtonTapped {
	[_iPod skipToNextItem];
}

- (void)clickWheelPlayButtonTapped {
	if (_iPod.playbackState == MPMusicPlaybackStatePlaying)
		[_iPod pause];
	else
		[_iPod play];
}

@end
