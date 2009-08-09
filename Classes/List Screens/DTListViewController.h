//
//  DTListViewController.h
//  iPod
//
//  Created by Daniel Tull on 09.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTBlockView.h"
#import "DTiPodBlockViewCell.h"

#import "Artist+Extras.h"
#import "Album+Extras.h"
#import "Song+Extras.h"
#import "Playlist+Extras.h"

@interface DTListViewController : UIViewController <DTBlockViewDataSource> {
	DTBlockView *itemsView;
	NSArray *items;
}

@property (nonatomic, retain) IBOutlet DTBlockView *itemsView;
@property (nonatomic, retain) NSArray *items;

- (id)initWithItems:(NSArray *)someItems;
- (void)selected;
- (BOOL)moveUp;
- (BOOL)moveDown;

@end
