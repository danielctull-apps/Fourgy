//
//  DTAlbumsListViewController.m
//  iPod
//
//  Created by Daniel Tull on 09.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTAlbumsListViewController.h"
#import "DTSongsListViewController.h"
#import "Album.h"

@implementation DTAlbumsListViewController

- (void)selected {
	Album *album = [items objectAtIndex:itemsView.selectedIndex];
	DTSongsListViewController *slvc = [[DTSongsListViewController alloc] initWithItems:[[album.songs allObjects] sortedArrayUsingSelector:@selector(compareTrackNumber:)]];
	[self.navigationController pushViewController:slvc animated:YES];
	[slvc release];
}

- (UIView<DTBlockViewCellProtocol> *)blockView:(DTBlockView *)blockView blockViewCellForRow:(NSInteger)rowIndex {
	
	DTiPodBlockViewCell *cell = (DTiPodBlockViewCell *)[blockView dequeueReusableCell];
	
	if (!cell)
		cell = [[[DTiPodBlockViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, blockView.frame.size.width, 27.0)] autorelease];
	
	cell.titleLabel.text = [[items objectAtIndex:rowIndex] title];
	
	return cell;
}

@end
