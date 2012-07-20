//
//  DTBlockScrollerView.m
//  iPod
//
//  Created by Daniel Tull on 26.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "_FGYScroller.h"


@implementation _FGYScroller

@synthesize numberOfitems, numberOfItemsOnScreen, currentItemNumber, knobInsets, scrollerInsets;

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
	
	scrollerInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	knobInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	numberOfitems = 1;
	numberOfItemsOnScreen = 1;
	currentItemNumber = 0;
	
    return self;
}


- (void)drawRect:(CGRect)aRect {
	
	CGRect rect = CGRectMake(aRect.origin.x + self.scrollerInsets.left,
							 aRect.origin.y + self.scrollerInsets.top,
							 aRect.size.width - self.scrollerInsets.left - self.scrollerInsets.right,
							 aRect.size.height - self.scrollerInsets.top - self.scrollerInsets.bottom);
	
	[self drawBackgroundInRect:rect];
	
	CGFloat scrollerHeight = rect.size.height - knobInsets.top - knobInsets.bottom;
	
	CGFloat knobHeight = (CGFloat)(NSInteger)(scrollerHeight * numberOfItemsOnScreen / numberOfitems);
	
	CGFloat knobPosition = (CGFloat)(NSInteger)(scrollerHeight * self.currentItemNumber / self.numberOfitems);
	
	[self drawKnobInRect:CGRectMake(knobInsets.left,
									knobPosition + knobInsets.top,
									rect.size.width - knobInsets.left - knobInsets.right, 
									knobHeight + 1.0)];
}

- (void)drawBackgroundInRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetGrayFillColor(context, 0.5, 1.0);
	CGContextFillRect(context, rect);
}

- (void)drawKnobInRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetGrayFillColor(context, 0.0, 1.0);
	CGContextFillRect(context, rect);
}

- (void)setCurrentItemNumber:(NSInteger)anInteger {
	currentItemNumber = anInteger;
	[self setNeedsDisplay];
}


@end
