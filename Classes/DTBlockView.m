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

@synthesize blocks, dataSource;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		blocks = [[NSArray alloc] init];
		freeBlocks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)awakeFromNib {
	blocks = [[NSArray alloc] init];
	freeBlocks = [[NSMutableArray alloc] init];
}

- (void)drawRect:(CGRect)rect {
	[self findNumberOfRows];
	[self findInitialRows];
	[self setNeedsLayout];
}

- (void)layoutSubviews {
	
	if (![self.dataSource respondsToSelector:@selector(numberOfRowsToDisplayInBlockView:)]) return;
	
	if ([blocks count] == 0) return;
		
	NSInteger displayRowNumber = [self.dataSource numberOfRowsToDisplayInBlockView:self];
	
	CGFloat width = self.frame.size.width;
	CGFloat height = self.frame.size.height/displayRowNumber;
	
	for (NSInteger i = 0; i < displayRowNumber; i++) {
		UIView<DTBlockViewCellProtocol> *cell = [blocks objectAtIndex:i];
		cell.frame = CGRectMake(0.0, i*height, width, height);
	}
}

- (void)findInitialRows {
	
	if (![self.dataSource respondsToSelector:@selector(blockView:blockViewCellForRow:)])
		return;
	
	NSMutableArray *tempBlocks = [[NSMutableArray alloc] init];
	
	for (NSInteger i = 0; i < numberOfRows; i++) {
		UIView<DTBlockViewCellProtocol> *cell = [self.dataSource blockView:self blockViewCellForRow:i];
		[self addSubview:cell];
		[tempBlocks addObject:cell];
	}
	
	[blocks release];
	blocks = [tempBlocks copy];
	[tempBlocks release];
	
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
		
	UIView<DTBlockViewCellProtocol> *firstCell = [blocks objectAtIndex:0];
	UIView<DTBlockViewCellProtocol> *lastCell = [blocks lastObject];
	
	
	NSInteger firstRowIndex;
	NSInteger lastRowIndex;
	
	if (rowIndex < firstCell.rowIndex) {
		
		firstRowIndex = rowIndex;
		lastRowIndex = rowIndex + numberOfRows - 1;
		
	} else if (rowIndex > lastCell.rowIndex) {
		
		lastRowIndex = rowIndex;
		firstRowIndex = rowIndex - numberOfRows + 1;
		
	}
	
	NSMutableArray *temporaryBlocks = [blocks mutableCopy];
	
	NSMutableArray *tempFreeCells = [[NSMutableArray alloc] init];
	
	for (UIView<DTBlockViewCellProtocol> *cell in blocks)
		if (cell.rowIndex < firstRowIndex || cell.rowIndex > lastRowIndex)
			[tempFreeCells addObject:cell];
	
	[temporaryBlocks removeObjectsInArray:tempFreeCells];
	self.blocks = [[temporaryBlocks copy] autorelease];
	[temporaryBlocks release];
	
	[freeBlocks release];
	freeBlocks = tempFreeCells;
	
	firstCell = [blocks objectAtIndex:0];
	lastCell = [blocks lastObject];
	
	if (firstCell.rowIndex > firstRowIndex) {
		// needs some before
		
		for (NSInteger i = firstCell.rowIndex - 1; i >= firstRowIndex; i--) {
			// ask for cell and add
		}
	}
	
	if (lastCell.rowIndex < lastRowIndex) {
		// needs some after
		
		for (NSInteger i = lastCell.rowIndex + 1; i <= lastRowIndex; i++) {
			//ask for cell and add
		}
	}
	
	
	
	
	[self setNeedsLayout];
}


@end
