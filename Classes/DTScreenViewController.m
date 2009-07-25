//
//  DTScreenViewController.m
//  iPod
//
//  Created by Daniel Tull on 16.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTScreenViewController.h"
#import "DTiPodBlockViewCell.h"
#import "DTPlayingScreenViewController.h"
#import "MPMediaItem+DTTrackNumber.h"

@implementation DTScreenViewController

@synthesize itemsView;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)init {
    return [self initWithNibName:@"DTScreenView" bundle:nil];
}

- (id)initWithQuery:(MPMediaQuery *)aQuery property:(NSString *)aProperty lastPredicate:(MPMediaPropertyPredicate *)theLastPredicate lastGroupingType:(MPMediaGrouping)thelastGroupingType {
	
	if (!(self = [self initWithNibName:@"DTScreenView" bundle:nil])) return nil;
	
	NSLog(@"%@:%s 1", self, _cmd);
	
	predicateToRemoveFromQueryWhenPopped = [theLastPredicate retain];
	groupingTypeToRevertToWhenPopped = thelastGroupingType;
	items = nil;
	query = [aQuery retain];
	collections = [[query collections] copy];
	property = [aProperty copy];
	amount = [collections count];
	
	NSLog(@"%@:%s 2", self, _cmd);
	
	return self;
	
}

- (void)dealloc {
	[query release];
	[items release];
	[collections release];
	[property release];
	[predicateToRemoveFromQueryWhenPopped release];
    [super dealloc];
}

- (id)initWithArray:(NSArray *)array {
	
	if (!(self = [self init])) return nil;
	
	items = [array copy];
	amount = [items count];
	collections = nil;
	property = nil;
	
    return self;
}

- (void)willPopFromNavigationController {
	if (predicateToRemoveFromQueryWhenPopped) {
		[query removeFilterPredicate:predicateToRemoveFromQueryWhenPopped];
		query.groupingType = groupingTypeToRevertToWhenPopped;
	}
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
/*- (void)loadView {
	self.view = [[DTBlockView alloc] initWithFrame:CGRectZero];
	((DTBlockView *)self.view).dataSource = self;
	itemsView = self.view;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	itemsView.backgroundColor = [UIColor colorWithRed:0.8 green:0.867 blue:0.937 alpha:1.0];
	
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




- (NSInteger)numberOfRowsForBlockView:(DTBlockView *)blockView {
	return amount;
}

- (NSInteger)numberOfRowsToDisplayInBlockView:(DTBlockView *)blockView {
	return 6;
}

- (UIView<DTBlockViewCellProtocol> *)blockView:(DTBlockView *)blockView blockViewCellForRow:(NSInteger)rowIndex {
	
	DTiPodBlockViewCell *cell = (DTiPodBlockViewCell *)[blockView dequeueReusableCell];
	
	if (!cell) {
		cell = [[[DTiPodBlockViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, blockView.frame.size.width, 27.0)] autorelease];
	}
	
	if (items)
		cell.titleLabel.text = [items objectAtIndex:rowIndex];
	else if (collections)
		cell.titleLabel.text = [((MPMediaItemCollection *)[collections objectAtIndex:rowIndex]).representativeItem valueForProperty:property];
	
	return cell;
}

- (void)selected {

	if (collections) {
		
		NSString *text = [((MPMediaItemCollection *)[collections objectAtIndex:itemsView.selectedIndex]).representativeItem valueForProperty:property];
		
		if (query.groupingType == MPMediaGroupingArtist) {
			
			MPMediaGrouping group = query.groupingType;
			MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:text forProperty:property];
			
			[query addFilterPredicate:predicate];
			[query setGroupingType:MPMediaGroupingAlbum];
			DTScreenViewController *table = [[DTScreenViewController alloc] initWithQuery:query
																				 property:MPMediaItemPropertyAlbumTitle
																			lastPredicate:predicate
																		 lastGroupingType:group];
			[self.navigationController pushViewController:table animated:YES];
			[table release];
			 
		} else if (query.groupingType == MPMediaGroupingTitle) {
			
			NSArray *queryitems = query.items;
			
			if ([property isEqualToString:MPMediaItemPropertyAlbumTrackNumber]) {
			
				queryitems = [query.items sortedArrayUsingSelector:@selector(albumTrackNumber)];
			}
			
			DTPlayingScreenViewController *playing = [[DTPlayingScreenViewController alloc] initWithMediaItem:((MPMediaItemCollection *)[collections objectAtIndex:itemsView.selectedIndex]).representativeItem
																							  mediaCollection:[MPMediaItemCollection collectionWithItems:queryitems]];
			
			[self.navigationController pushViewController:playing animated:YES];
			[playing release];
			
		} else if (query.groupingType == MPMediaGroupingGenre) {
			
			MPMediaGrouping group = query.groupingType;
			MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:text forProperty:property];
			[query addFilterPredicate:predicate];
			
			[query setGroupingType:MPMediaGroupingArtist];
			
			DTScreenViewController *table = [[DTScreenViewController alloc] initWithQuery:query
																				 property:MPMediaItemPropertyArtist
																			lastPredicate:predicate
																		 lastGroupingType:group];
			
			[self.navigationController pushViewController:table animated:YES];
			[table release];
			
			
			// LOAD THAT GENRE'S ARTISTS
			
		} else if (query.groupingType == MPMediaGroupingComposer) {
	
			MPMediaGrouping group = query.groupingType;
			MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:text forProperty:property];
			[query addFilterPredicate:predicate];
			[query setGroupingType:MPMediaGroupingAlbum];
			DTScreenViewController *table = [[DTScreenViewController alloc] initWithQuery:query
																				 property:MPMediaItemPropertyAlbumTitle
																			lastPredicate:predicate
																		 lastGroupingType:group];
			[self.navigationController pushViewController:table animated:YES];
			[table release];
	
		} else if (query.groupingType == MPMediaGroupingPodcastTitle || query.groupingType == MPMediaGroupingPlaylist || query.groupingType == MPMediaGroupingAlbum) {
			
			MPMediaGrouping group = query.groupingType;
			MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:text forProperty:property];
			[query addFilterPredicate:predicate];
			[query setGroupingType:MPMediaGroupingTitle];
			
			NSString *tempProperty = nil;
			
			if (query.groupingType == MPMediaGroupingAlbum)
				tempProperty = MPMediaItemPropertyAlbumTrackNumber;
			else
				tempProperty = MPMediaItemPropertyTitle;
			
			DTScreenViewController *table = [[DTScreenViewController alloc] initWithQuery:query
																				 property:tempProperty
																			lastPredicate:predicate
																		 lastGroupingType:group];
			[self.navigationController pushViewController:table animated:YES];
			[table release];
			
		}
	} else if (items) {
		
		NSString *text = [items objectAtIndex:itemsView.selectedIndex];
		
		if ([text isEqualToString:@"Music"]) {
			DTScreenViewController *table = [[DTScreenViewController alloc] initWithArray:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MusicMenu" ofType:@"plist"]]];
			[self.navigationController pushViewController:table animated:YES];
			[table release];
		} else if ([text isEqualToString:@"Playlists"]) {
			MPMediaQuery *aQuery = [MPMediaQuery playlistsQuery];
			[aQuery setGroupingType:MPMediaGroupingPlaylist];
			DTScreenViewController *table = [[DTScreenViewController alloc] initWithQuery:aQuery property:MPMediaPlaylistPropertyName lastPredicate:nil lastGroupingType:MPMediaGroupingPlaylist];
			[self.navigationController pushViewController:table animated:YES];
			[table release];
		} else if ([text isEqualToString:@"Artists"]) {
			MPMediaQuery *aQuery = [MPMediaQuery artistsQuery];
			[aQuery setGroupingType:MPMediaGroupingArtist];
			DTScreenViewController *table = [[DTScreenViewController alloc] initWithQuery:aQuery property:MPMediaItemPropertyArtist lastPredicate:nil lastGroupingType:MPMediaGroupingArtist];
			[self.navigationController pushViewController:table animated:YES];
			[table release];
		} else if ([text isEqualToString:@"Albums"]) {
			MPMediaQuery *aQuery = [MPMediaQuery albumsQuery];
			[aQuery setGroupingType:MPMediaGroupingAlbum];
			DTScreenViewController *table = [[DTScreenViewController alloc] initWithQuery:aQuery property:MPMediaItemPropertyAlbumTitle lastPredicate:nil lastGroupingType:MPMediaGroupingArtist];
			[self.navigationController pushViewController:table animated:YES];
			[table release];
		} else if ([text isEqualToString:@"Genres"]) {
			MPMediaQuery *aQuery = [MPMediaQuery genresQuery];
			[aQuery setGroupingType:MPMediaGroupingGenre];
			DTScreenViewController *table = [[DTScreenViewController alloc] initWithQuery:aQuery property:MPMediaItemPropertyGenre lastPredicate:nil lastGroupingType:MPMediaGroupingArtist];
			[self.navigationController pushViewController:table animated:YES];
			[table release];
		} else if ([text isEqualToString:@"Songs"]) {
			MPMediaQuery *aQuery = [MPMediaQuery songsQuery];
			DTScreenViewController *table = [[DTScreenViewController alloc] initWithQuery:aQuery property:MPMediaItemPropertyTitle lastPredicate:nil lastGroupingType:MPMediaGroupingArtist];
			[self.navigationController pushViewController:table animated:YES];
			[table release];
		} else if ([text isEqualToString:@"Podcasts"]) {
			MPMediaQuery *aQuery = [MPMediaQuery podcastsQuery];
			DTScreenViewController *table = [[DTScreenViewController alloc] initWithQuery:aQuery property:MPMediaItemPropertyPodcastTitle lastPredicate:nil lastGroupingType:MPMediaGroupingArtist];
			[self.navigationController pushViewController:table animated:YES];
			[table release];
		} else if ([text isEqualToString:@"Audiobooks"]) {
			MPMediaQuery *aQuery = [MPMediaQuery audiobooksQuery];
			DTScreenViewController *table = [[DTScreenViewController alloc] initWithQuery:aQuery property:MPMediaItemPropertyTitle lastPredicate:nil lastGroupingType:MPMediaGroupingArtist];
			[self.navigationController pushViewController:table animated:YES];
			[table release];
		} else if ([text isEqualToString:@"Composers"]) {
			MPMediaQuery *aQuery = [MPMediaQuery composersQuery];
			DTScreenViewController *table = [[DTScreenViewController alloc] initWithQuery:aQuery property:MPMediaItemPropertyComposer lastPredicate:nil lastGroupingType:MPMediaGroupingArtist];
			[self.navigationController pushViewController:table animated:YES];
			[table release];
		}
	}
}


- (void)moveDown {
	if (itemsView.selectedIndex < amount - 1)
		[itemsView moveToRow:itemsView.selectedIndex + 1];
}

- (void)moveUp {
	if (itemsView.selectedIndex > 0)
		[itemsView moveToRow:itemsView.selectedIndex - 1];
}

@end
