//
//  DTBlockView.h
//  iPod
//
//  Created by Daniel Tull on 15.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTBlockViewCellProtocol.h"

@protocol DTBlockViewDataSource;

@interface DTBlockView : UIView {
	
	NSArray *blocks;
	NSMutableArray *freeBlocks;
	NSInteger numberOfRows;
	
	CGFloat *cellHeights;
}

@property (nonatomic, retain) NSArray *blocks;

- (UIView<DTBlockViewCellProtocol> *)dequeueReusableCell;
- (void)moveToRow:(NSInteger)rowIndex;

@end


@protocol DTBlockViewDataSource

- (NSInteger)numberOfRowsForBlockView:(DTBlockView *)blockView;
- (UIView<DTBlockViewCellProtocol> *)blockView:(DTBlockView *)blockView blockViewCellForRow:(NSInteger)rowIndex;

@end
