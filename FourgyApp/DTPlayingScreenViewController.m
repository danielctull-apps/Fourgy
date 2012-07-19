//
//  DTPlayingScreenViewController.m
//  iPod
//
//  Created by Daniel Tull on 23.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTPlayingScreenViewController.h"
#import <Fourgy/Fourgy.h>

@interface DTPlayingScreenViewController ()
@property (nonatomic, weak) IBOutlet FGYTickingLabel *trackNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistLabel;
@property (nonatomic, weak) IBOutlet UILabel *albumLabel;
@property (nonatomic, weak) IBOutlet UILabel *trackNumberLabel;
@end

@implementation DTPlayingScreenViewController {
	
	MPMediaItem *nowPlaying;
	MPMusicPlayerController *iPod;
	MPMediaItemCollection *musicQueue;
	
}

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
	
	musicQueue = [aCollection retain];
	
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
- (BOOL)moveUp {
	return NO;
}
- (BOOL)moveDown {
	return NO;
}

- (void)refreshPlaying {
	if (iPod.playbackState == MPMusicPlaybackStateStopped) {
		[self.navigationController popToRootViewControllerAnimated:YES];
		return;
	}
	
	self.nowPlaying = iPod.nowPlayingItem;
	self.artistLabel.text = [self.nowPlaying valueForProperty:MPMediaItemPropertyArtist];
	self.trackNameLabel.text = [self.nowPlaying valueForProperty:MPMediaItemPropertyTitle];
	self.albumLabel.text = [self.nowPlaying valueForProperty:MPMediaItemPropertyAlbumTitle];
	
	NSInteger trackNumber = 0;
	for (NSInteger i = 0; i < musicQueue.count; i++)
		if ([[musicQueue.items objectAtIndex:i] isEqual:self.nowPlaying])
			trackNumber = i+1;
	
	self.trackNumberLabel.text = [NSString stringWithFormat:@"%i of %i", trackNumber, [musicQueue count]];
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
