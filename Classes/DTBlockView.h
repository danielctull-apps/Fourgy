//
//  DTBlockView.h
//  iPod
//
//  Created by Daniel Tull on 15.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTBlockViewDataSource;

@interface DTBlockView : UIView {
	
	NSMutableArray *blocks;
	NSMutableArray *freeBlocks;
	NSInteger *numberOfRows;
	
	CGFloat *cellHeights;
}

- (DTGridViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (void)moveToRow:(NSInteger)rowIndex;

@end


@protocol DTBlockViewDataSource

- (NSInteger)numberOfRowsForBlockView:(DTBlockView *)blockView;
- (DTBlockViewCell *)blockView:(DTBlockView *)blockView blockViewCellForRow:(NSInteger)rowIndex;

@end
