//
//  DTGenresListViewController.m
//  iPod
//
//  Created by Daniel Tull on 09.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTGenresListViewController.h"
#import "DTArtistsListViewController.h"
#import "Genre.h"

@implementation DTGenresListViewController

- (void)selected {
	Genre *genre = [items objectAtIndex:itemsView.selectedIndex];
	DTArtistsListViewController *slvc = [[DTArtistsListViewController alloc] initWithItems:[genre.artists allObjects]];
	[self.navigationController pushViewController:slvc animated:YES];
	[slvc release];
}

- (UIView<DTBlockViewCellProtocol> *)blockView:(DTBlockView *)blockView blockViewCellForRow:(NSInteger)rowIndex {
	
	DTiPodBlockViewCell *cell = (DTiPodBlockViewCell *)[blockView dequeueReusableCell];
	
	if (!cell)
		cell = [[[DTiPodBlockViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, blockView.frame.size.width, 27.0)] autorelease];
	
	cell.titleLabel.text = [[items objectAtIndex:rowIndex] name];
	
	return cell;
}

@end
