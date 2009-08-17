//
//  DTSongsListViewController.m
//  iPod
//
//  Created by Daniel Tull on 09.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTSongsListViewController.h"
#import "Song+Extras.h"
#import "DTPlayingScreenViewController.h"

@implementation DTSongsListViewController

- (void)selected {
	
	NSMutableArray *mediaitems = [[NSMutableArray alloc] init];
	
	for (Song *s in self.items)
		[mediaitems addObject:[s mediaItem]];
	
	Song *song = (Song *)[self.items objectAtIndex:self.itemsView.selectedIndex];
		
	
	DTPlayingScreenViewController *playing = [[DTPlayingScreenViewController alloc] initWithMediaItem:[song mediaItem]
																					  mediaCollection:[MPMediaItemCollection collectionWithItems:mediaitems]];
	
	[self.navigationController pushViewController:playing animated:YES];
	[playing release];
}

- (UIView<DTBlockViewCellProtocol> *)blockView:(DTBlockView *)blockView blockViewCellForRow:(NSInteger)rowIndex {
	
	DTiPodBlockViewCell *cell = (DTiPodBlockViewCell *)[blockView dequeueReusableCell];
	
	if (!cell)
		cell = [[[DTiPodBlockViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, blockView.frame.size.width, 27.0)] autorelease];
	
	cell.titleLabel.text = [[items objectAtIndex:rowIndex] title];
	
	return cell;
}

@end
