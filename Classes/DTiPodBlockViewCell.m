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
	
	NSLog(@"%@:%s", self, _cmd);
	titleLabel = [[UILabel alloc] init];
	
    return self;
}

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(context, 0.8, 0.867, 0.937, 1.0);
	CGContextFillRect(context, rect);
	
	self.backgroundColor = [UIColor colorWithRed:0.8 green:0.867 blue:0.937 alpha:1.0];
	self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
	self.titleLabel.textColor = [UIColor colorWithRed:0.176 green:0.204 blue:0.42 alpha:1.0];
	self.titleLabel.backgroundColor = self.backgroundColor;
	self.titleLabel.frame = CGRectMake(10.0, 0.0, rect.size.width - 20, rect.size.height);
	[self addSubview:self.titleLabel];
}

- (void)dealloc {
	[titleLabel release];
    [super dealloc];
}


@end
