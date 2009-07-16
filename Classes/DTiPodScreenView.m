//
//  DTiPodScreenView.m
//  iPod
//
//  Created by Daniel Tull on 13.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTiPodScreenView.h"


@implementation DTiPodScreenView

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextFillRect(context, rect);
	
	
	CGContextSetRGBFillColor(context, 0.412, 0.443, 0.463, 1.0);
	
	CGFloat amount = 5.0;
	
	CGContextMoveToPoint(context, amount, 0.0);
	CGContextAddLineToPoint(context, rect.size.width - amount, 0.0);
	CGContextAddArcToPoint(context, rect.size.width, 0.0, rect.size.width, amount, amount);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height - amount);
	CGContextAddArcToPoint(context, rect.size.width, rect.size.height, rect.size.width - amount, rect.size.height, amount);
	CGContextAddLineToPoint(context, amount, rect.size.height);
	CGContextAddArcToPoint(context, 0.0, rect.size.height, 0.0, rect.size.height - amount, amount);
	CGContextAddLineToPoint(context, 0.0, amount);
	CGContextAddArcToPoint(context, 0.0, 0.0, 10.0, 0.0, amount);
	CGContextFillPath(context);
}



@end
