//
//  FGYProgressView.m
//  Fourgy
//
//  Created by Daniel Tull on 19.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "FGYProgressView.h"
#import "Fourgy.h"

@implementation FGYProgressView

- (id)initWithFrame:(CGRect)frame {
	return [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 14.0f)];
}

- (void)awakeFromNib {
	[super awakeFromNib];
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 14.0f);
}

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, self.bounds);
	
	CGFloat radius = 7;
	CGFloat indent = 1.0;
	
	CGContextMoveToPoint(context, radius, indent);
	CGContextAddLineToPoint(context, rect.size.width - radius, indent);
	CGContextAddArcToPoint(context, rect.size.width - indent, indent, rect.size.width-indent, radius, radius-indent);
	CGContextAddArcToPoint(context, rect.size.width - indent, 2*radius - indent, rect.size.width - radius, 2*radius - indent, radius-indent);
	CGContextAddLineToPoint(context, radius, 2*radius - indent);
	CGContextAddArcToPoint(context, indent, 2*radius - indent, indent, radius, radius-indent);
	CGContextAddArcToPoint(context, indent, indent, radius, indent, radius-indent);
	[[Fourgy foregroundColor] setFill];
	CGContextFillPath(context);
	
	CGFloat percentage = self.progress / 1.0f;
	CGFloat width = (rect.size.width - 2*indent) * (1 - percentage);
	CGRect coverUpRect = CGRectMake(rect.size.width - indent - width, indent, width, 2*(radius-indent));
	[[Fourgy backgroundColor] setFill];
	CGContextFillRect(context, coverUpRect);
	
	indent = 1.0;
	
	CGContextMoveToPoint(context, radius, indent);
	CGContextAddLineToPoint(context, rect.size.width - radius, indent);
	CGContextAddArcToPoint(context, rect.size.width - indent, indent, rect.size.width-indent, radius, radius-indent);
	CGContextAddArcToPoint(context, rect.size.width - indent, 2*radius - indent, rect.size.width - radius, 2*radius - indent, radius-indent);
	CGContextAddLineToPoint(context, radius, 2*radius - indent);
	CGContextAddArcToPoint(context, indent, 2*radius - indent, indent, radius, radius-indent);
	CGContextAddArcToPoint(context, indent, indent, radius, indent, radius-indent);
	
	CGContextSetLineWidth(context, 2.0);
	[[Fourgy foregroundColor] setStroke];
	CGContextStrokePath(context);
}

@end
