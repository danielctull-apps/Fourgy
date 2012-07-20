//
//  DTBlockScrollerView.m
//  iPod
//
//  Created by Daniel Tull on 26.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "_FGYScroller.h"
#import "Fourgy.h"

@implementation _FGYScroller

- (void)drawRect:(CGRect)aRect {
	
	CGRect rect = self.bounds;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[[Fourgy foregroundColor] setFill];
	CGContextFillRect(context, rect);
	
	[[Fourgy backgroundColor] setFill];
	rect = CGRectInset(rect, 2.0f, 2.0f);
	CGContextFillRect(context, rect);
	
	rect = CGRectInset(rect, 1.0f, 1.0f);
	
	CGFloat trackHeight = rect.size.height;
	
	NSUInteger numberOfItemsOnScreen = [self.tableView.visibleCells count];
	
	NSInteger numberOfitems = 0;
	NSInteger currentItemNumber = 0;
	
	NSIndexPath *currentIndexPath = [self.tableView indexPathForSelectedRow];
	NSInteger numberOfSections = [self.tableView numberOfSections];
	for (NSInteger i = 0; i < numberOfSections; i++) {
		NSInteger numberOfRowsInSection = [self.tableView numberOfRowsInSection:i];
		numberOfitems += numberOfRowsInSection;
		if (currentIndexPath.section < i)
			currentItemNumber += numberOfRowsInSection;
	}
	currentItemNumber += currentIndexPath.row;
	
	NSInteger knobHeight = (NSInteger)(trackHeight * numberOfItemsOnScreen / numberOfitems--);
	if (knobHeight < 10) knobHeight = 10;
	
	NSInteger knobPosition = (NSInteger)((trackHeight-knobHeight) * currentItemNumber / numberOfitems);
	
	CGRect knobRect = rect;
	knobRect.size.height = knobHeight;
	knobRect.origin.y += knobPosition;
	
	[[Fourgy foregroundColor] setFill];
	CGContextFillRect(context, knobRect);
}

@end
