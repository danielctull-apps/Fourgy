//
//  DTArtistsListViewController.m
//  iPod
//
//  Created by Daniel Tull on 09.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTArtistsListViewController.h"
#import "DTAlbumsListViewController.h"
#import "DTSongsListViewController.h"
#import "Album+Extras.h"
#import "Song+Extras.h"

@implementation DTArtistsListViewController

- (void)selected {
	Artist *artist = [items objectAtIndex:itemsView.selectedIndex];
	NSArray *albums = [artist.albums allObjects];
	
	if ([albums count] == 1) {
		Album *album = [albums objectAtIndex:0];
		DTSongsListViewController *slvc = [[DTSongsListViewController alloc] initWithItems:[[album.songs allObjects] sortedArrayUsingSelector:@selector(compareTrackNumber:)]];
		[self.navigationController pushViewController:slvc animated:YES];
		[slvc release];
	} else {
		DTAlbumsListViewController *alvc = [[DTAlbumsListViewController alloc] initWithItems:[albums sortedArrayUsingSelector:@selector(compare:)]];
		[self.navigationController pushViewController:alvc animated:YES];
		[alvc release];
	}
}

- (UIView<DTBlockViewCellProtocol> *)blockView:(DTBlockView *)blockView blockViewCellForRow:(NSInteger)rowIndex {
	
	DTiPodBlockViewCell *cell = (DTiPodBlockViewCell *)[blockView dequeueReusableCell];
	
	if (!cell)
		cell = [[[DTiPodBlockViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, blockView.frame.size.width, 27.0)] autorelease];
	
	cell.titleLabel.text = [[items objectAtIndex:rowIndex] name];
	
	return cell;
}

@end
