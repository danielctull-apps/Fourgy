//
//  DTBlockView.h
//  iPod
//
//  Created by Daniel Tull on 15.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTBlockViewCellProtocol.h"
#import "DTBlockScroller.h"

@protocol DTBlockViewDataSource;

@interface DTBlockView : UIView {
	
	NSArray *blocks;
	NSMutableArray *freeBlocks;
	NSInteger numberOfRows;
	NSInteger displayRowNumber;
	CGFloat *cellHeights;
	
	NSInteger selectedIndex;
	
	NSObject<DTBlockViewDataSource> *dataSource;
	
	BOOL shouldShowScroller;
	CGFloat scrollerWidth;
	DTBlockScroller *scroller;
}

@property (nonatomic, copy) NSArray *blocks;
@property (nonatomic, assign) IBOutlet NSObject<DTBlockViewDataSource> *dataSource;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL shouldShowScroller;
@property (nonatomic, assign) CGFloat scrollerWidth;
@property (nonatomic, retain) DTBlockScroller *scroller;

- (UIView<DTBlockViewCellProtocol> *)dequeueReusableCell;
- (void)moveToRow:(NSInteger)rowIndex;
-(void)findnumberOfRowsToDisplay;
-(void)findNumberOfRows;
-(void)findInitialRows;

@end


@protocol DTBlockViewDataSource

- (NSInteger)numberOfRowsForBlockView:(DTBlockView *)blockView;
- (UIView<DTBlockViewCellProtocol> *)blockView:(DTBlockView *)blockView blockViewCellForRow:(NSInteger)rowIndex;
- (NSInteger)numberOfRowsToDisplayInBlockView:(DTBlockView *)blockView;

@end
