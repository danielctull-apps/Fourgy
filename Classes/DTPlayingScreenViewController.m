//
//  DTPlayingScreenViewController.m
//  iPod
//
//  Created by Daniel Tull on 23.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTPlayingScreenViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation DTPlayingScreenViewController

@synthesize artistLabel, albumLabel, trackNameLabel, trackNumberLabel, nowPlaying;

- (id)initWithMediaItem:(MPMediaItem *)theItem mediaCollection:(MPMediaItemCollection *)aCollection {
	if (!(self = [self initWithNibName:@"DTPlayingScreenView" bundle:nil])) return nil;
	
	iPod = [[MPMusicPlayerController iPodMusicPlayer] retain];	
	nowPlaying = nil;
	
	if (iPod.playbackState == MPMusicPlaybackStatePlaying) {
		if (![[theItem valueForProperty:MPMediaItemPropertyPersistentID] isEqualToNumber:[[iPod nowPlayingItem] valueForProperty:MPMediaItemPropertyPersistentID]]) {
			[iPod stop];
			[iPod setQueueWithItemCollection:aCollection];
			iPod.nowPlayingItem = theItem;
			[iPod play];
		}
	} else {
		[iPod stop];
		[iPod setQueueWithItemCollection:aCollection];
		iPod.nowPlayingItem = theItem;
		[iPod play];
	}
	
	[iPod beginGeneratingPlaybackNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trackChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:iPod];
	
	
	
	return self;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[iPod release];
	[nowPlaying release];
    [super dealloc];
}



/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	trackNameLabel.speed = 30.0;
	trackNameLabel.delay = 5.0;
    [super viewDidLoad];
	[self refreshPlaying];
}

- (void)trackChanged:(NSNotification *)notification {
	[self refreshPlaying];
}

- (void)selected {
}
- (void)moveUp {
}
- (void)moveDown {
}

- (void)refreshPlaying {
	self.nowPlaying = iPod.nowPlayingItem;
	self.artistLabel.text = [nowPlaying valueForProperty:MPMediaItemPropertyArtist];
	self.trackNameLabel.text = [nowPlaying valueForProperty:MPMediaItemPropertyTitle];
	self.albumLabel.text = [nowPlaying valueForProperty:MPMediaItemPropertyAlbumTitle];
	self.trackNumberLabel.text = [NSString stringWithFormat:@"%@ of %@", [nowPlaying valueForProperty:MPMediaItemPropertyAlbumTrackNumber], [nowPlaying valueForProperty:MPMediaItemPropertyAlbumTrackCount]];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}





@end
