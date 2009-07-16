//
//  DTBlockView.m
//  iPod
//
//  Created by Daniel Tull on 15.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTBlockView.h"


@implementation DTBlockView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
	
	
	
}


- (void)dealloc {
    [super dealloc];
}

- (void)moveToRow:(NSInteger)rowIndex {
	
	DTBlockViewCell *firstCell = [blocks objectAtIndex:0];
	DTBlockViewCell *lastCell = [blocks lastObject];
	
	
	NSInteger firstRowIndex;
	NSInteger lastRowIndex;
	
	if (rowIndex < firstCell.rowIndex) {
		
		firstRowIndex = rowIndex;
		lastRowIndex = rowIndex + numberOfRows - 1;
		
	} else if (rowIndex > lastCell.rowIndex) {
		
		lastRowIndex = rowIndex;
		firstRowIndex = rowIndex - numberOfRows + 1;
		
	}
		
	for (NSInteger i = 0; i < [blocks count]; i++) {
		
		
	}
}


@end
