//
//  DTScreenViewController.h
//  iPod
//
//  Created by Daniel Tull on 16.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DTBlockView.h"

@interface DTScreenViewController : UIViewController <DTBlockViewDataSource> {
	DTBlockView *itemsView;
	
	NSArray *collections;
	NSArray *items;
	NSString *property;
	MPMediaQuery *query;
	
	MPMediaPropertyPredicate *predicateToRemoveFromQueryWhenPopped;
	MPMediaGrouping groupingTypeToRevertToWhenPopped;
	
	NSInteger amount;
}

@property (nonatomic, retain) IBOutlet DTBlockView *itemsView;

- (id)initWithQuery:(MPMediaQuery *)aQuery property:(NSString *)aProperty lastPredicate:(MPMediaPropertyPredicate *)theLastPredicate lastGroupingType:(MPMediaGrouping)thelastGroupingType;
- (id)initWithArray:(NSArray *)array;
- (void)willPopFromNavigationController;
- (void)selected;
- (void)moveUp;
- (void)moveDown;
@end