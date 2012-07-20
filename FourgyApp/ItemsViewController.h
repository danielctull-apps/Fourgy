//
//  ItemsViewController.h
//  Fourgy
//
//  Created by Daniel Tull on 20.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DCTTableViewDataSources/DCTTableViewDataSources.h>
#import <DCTMusicModel/DCTMusicModel.h>
#import <Fourgy/Fourgy.h>

@interface ItemsViewController : FGYTableViewController
- (id)initWithItems:(NSArray *)items;
- (NSString *)titleForItem:(id)item;
@property (nonatomic, readonly) DCTArrayTableViewDataSource *dataSource;
@end
