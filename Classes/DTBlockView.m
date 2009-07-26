//
//  DTBlockView.m
//  iPod
//
//  Created by Daniel Tull on 15.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTBlockView.h"
#import "DTBlockViewCellProtocol.h"

@implementation DTBlockView

@synthesize blocks, dataSource, selectedIndex, shouldShowScroller, scrollerWidth, scroller, itemsInsets;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		blocks = [[NSArray alloc] init];
		freeBlocks = [[NSMutableArray alloc] init];
		selectedIndex = 0;
    }
    return self;
}

- (void)awakeFromNib {
	blocks = [[NSArray alloc] init];
	freeBlocks = [[NSMutableArray alloc] init];
	selectedIndex = 0;
	scrollerWidth = 20.0;
	shouldShowScroller = YES;
	scroller = nil;
}

- (void)drawRect:(CGRect)rect {
	
	
	
	[self findnumberOfRowsToDisplay];
	[self findNumberOfRows];
	[self findInitialRows];
	
	if (shouldShowScroller && !scroller)
		scroller = [[DTBlockScroller alloc] initWithFrame:CGRectMake(rect.size.width - self.scrollerWidth, 0.0, self.scrollerWidth, rect.size.height)];
	
	if (shouldShowScroller) {
		scroller.frame = CGRectMake(rect.size.width - self.scrollerWidth, 0.0, self.scrollerWidth, rect.size.height);
		[self addSubview:scroller];
	} else {
		self.scrollerWidth = 0.0;
	}
	
	if (scroller) {
		scroller.numberOfitems = numberOfRows;
		scroller.numberOfItemsOnScreen = displayRowNumber;
	}
	
	[self setNeedsLayout];
}

- (void)layoutSubviews {
	
	if ([blocks count] == 0) return;
	
	CGFloat width = self.frame.size.width - scrollerWidth - self.itemsInsets.left - self.itemsInsets.right;
	CGFloat height = (self.frame.size.height - self.itemsInsets.top - self.itemsInsets.bottom)/displayRowNumber;
	
	NSInteger numRows = displayRowNumber;
	
	if (numberOfRows < displayRowNumber)
		numRows = numberOfRows;
	
	for (NSInteger i = 0; i < numRows; i++) {
		UIView<DTBlockViewCellProtocol> *cell = [blocks objectAtIndex:i];
		cell.frame = CGRectMake(self.itemsInsets.left, self.itemsInsets.top + i*height, width, height);
	}
}

- (void)findInitialRows {
	
	if (![self.dataSource respondsToSelector:@selector(blockView:blockViewCellForRow:)])
		return;
	
	NSMutableArray *tempBlocks = [[NSMutableArray alloc] init];
	
	NSInteger numRows = displayRowNumber;
	
	if (numberOfRows < displayRowNumber)
		numRows = numberOfRows;
	
	for (NSInteger i = 0; i < numRows; i++) {
		UIView<DTBlockViewCellProtocol> *cell = [self.dataSource blockView:self blockViewCellForRow:i];
		[self addSubview:cell];
		[tempBlocks addObject:cell];
		cell.rowIndex = i;
	}
	
	[blocks release];
	blocks = [tempBlocks copy];
	[tempBlocks release];
	
	if ([blocks count] > 0)
		[[blocks objectAtIndex:0] setSelected:YES];
}

- (void)findnumberOfRowsToDisplay {
	if ([self.dataSource respondsToSelector:@selector(numberOfRowsToDisplayInBlockView:)])
		displayRowNumber = [self.dataSource numberOfRowsToDisplayInBlockView:self];
}

- (void)findNumberOfRows {
	if ([self.dataSource respondsToSelector:@selector(numberOfRowsForBlockView:)])
		numberOfRows = [self.dataSource numberOfRowsForBlockView:self];
}

- (void)dealloc {
    [super dealloc];
}

- (UIView<DTBlockViewCellProtocol> *)dequeueReusableCell {
	
	UIView<DTBlockViewCellProtocol> *cell = [[freeBlocks lastObject] retain];
	[freeBlocks removeObject:cell];
	return [cell autorelease];
	
}

- (void)moveToRow:(NSInteger)rowIndex {
	
	self.selectedIndex = rowIndex;
	
	UIView<DTBlockViewCellProtocol> *firstCell = [blocks objectAtIndex:0];
	UIView<DTBlockViewCellProtocol> *lastCell = [blocks lastObject];
	
	
	NSInteger firstRowIndex = firstCell.rowIndex;
	NSInteger lastRowIndex = lastCell.rowIndex;
	
	NSInteger numRows = displayRowNumber;
	
	if (numberOfRows < displayRowNumber)
		numRows = numberOfRows;
	
	if (rowIndex < firstCell.rowIndex) {
		
		firstRowIndex = rowIndex;
		lastRowIndex = rowIndex + numRows - 1;
		
	} else if (rowIndex > lastCell.rowIndex) {
		
		lastRowIndex = rowIndex;
		firstRowIndex = rowIndex - numRows + 1;

	}

	if (scroller)
		scroller.currentItemNumber = firstRowIndex;
	
	NSMutableArray *temporaryBlocks = [blocks mutableCopy];
	
	NSMutableArray *tempFreeCells = [[NSMutableArray alloc] init];
	
	for (UIView<DTBlockViewCellProtocol> *cell in blocks)
		if (cell.rowIndex < firstRowIndex || cell.rowIndex > lastRowIndex)
			[tempFreeCells addObject:cell];
	
	
	[freeBlocks release];
	freeBlocks = tempFreeCells;
	
	[temporaryBlocks removeObjectsInArray:freeBlocks];
	self.blocks = temporaryBlocks;
	

	
	[temporaryBlocks release];
	
	firstCell = [self.blocks objectAtIndex:0];
	lastCell = [self.blocks lastObject];
	
	NSMutableArray *tempBlocks = [blocks mutableCopy];
	
	if (firstCell.rowIndex > firstRowIndex) {
		for (NSInteger i = firstCell.rowIndex - 1; i >= firstRowIndex; i--) {
			UIView<DTBlockViewCellProtocol> *cell = [self.dataSource blockView:self blockViewCellForRow:i];
			[self addSubview:cell];
			[tempBlocks insertObject:cell atIndex:0];
			cell.rowIndex = i;
		}
	}
	

	
	if (lastCell.rowIndex < lastRowIndex) {
		for (NSInteger i = lastCell.rowIndex + 1; i <= lastRowIndex; i++) {
			UIView<DTBlockViewCellProtocol> *cell = [self.dataSource blockView:self blockViewCellForRow:i];
			[self addSubview:cell];
			[tempBlocks addObject:cell];
			cell.rowIndex = i;
		}
	}
	
	[blocks release];
	blocks = tempBlocks;
		
	for (UIView<DTBlockViewCellProtocol> *cell in blocks)
		if (cell.rowIndex == selectedIndex)
			cell.selected = YES;
		else
			cell.selected = NO;
	
	
	[self setNeedsLayout];
}


@end
