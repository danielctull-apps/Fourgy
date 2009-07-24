//
//  DTiPodBlockViewCell.m
//  iPod
//
//  Created by Daniel Tull on 16.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTiPodBlockViewCell.h"


@implementation DTiPodBlockViewCell

@synthesize titleLabel, rowIndex, selected;

- (id)init {
	return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
	
	//NSLog(@"%@:%s", self, _cmd);
	titleLabel = [[UILabel alloc] init];
	
    return self;
}

- (void)drawRect:(CGRect)rect {
	
	UIColor *darkBlueColor = [UIColor colorWithRed:0.176 green:0.204 blue:0.42 alpha:1.0];
	UIColor *lightBlueColor = [UIColor colorWithRed:0.8 green:0.867 blue:0.937 alpha:1.0];
	
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	
	
	if (self.selected) {
		self.backgroundColor = darkBlueColor;
		self.titleLabel.textColor = lightBlueColor;
		CGContextSetRGBFillColor(context, 0.176, 0.204, 0.42, 1.0);
	} else {
	
		self.backgroundColor = lightBlueColor;
		self.titleLabel.textColor = darkBlueColor;	
		CGContextSetRGBFillColor(context, 0.8, 0.867, 0.937, 1.0);
	
	}
	
	
	CGContextFillRect(context, rect);
	
	self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
	self.titleLabel.backgroundColor = self.backgroundColor;
	self.titleLabel.frame = CGRectMake(10.0, 0.0, rect.size.width - 20, rect.size.height);
	[self addSubview:self.titleLabel];
}

- (void)setSelected:(BOOL)aBool {
	selected = aBool;
	[self setNeedsDisplay];
}

- (void)dealloc {
	[titleLabel release];
    [super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@:%i", [self class], self.rowIndex];
}


@end
