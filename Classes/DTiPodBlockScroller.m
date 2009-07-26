//
//  DTiPodBlockScroller.m
//  iPod
//
//  Created by Daniel Tull on 26.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTiPodBlockScroller.h"


@implementation DTiPodBlockScroller

- (void)drawBackgroundInRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	
	CGContextSetRGBFillColor(context, 0.176, 0.204, 0.42, 1.0);
	CGContextFillRect(context, rect);
	
	CGContextSetRGBFillColor(context, 0.8, 0.867, 0.937, 1.0);
	CGContextFillRect(context, CGRectMake(2.0, 0.0, rect.size.width - 4.0, rect.size.height - 2.0));
}

- (void)drawKnobInRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(context, 0.176, 0.204, 0.42, 1.0);
	CGContextFillRect(context, rect);
}

@end
