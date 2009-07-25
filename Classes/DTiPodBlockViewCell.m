//
//  DTiPodBlockViewCell.m
//  iPod
//
//  Created by Daniel Tull on 16.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTiPodBlockViewCell.h"


@implementation DTiPodBlockViewCell

@synthesize titleLabel, selectedTitleLabel, rowIndex, selected;

- (id)init {
	return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
	titleLabel = [[UILabel alloc] init];
	selectedTitleLabel = nil;
	
    return self;
}

- (void)drawRect:(CGRect)rect {
	
	UIColor *darkBlueColor = [UIColor colorWithRed:0.176 green:0.204 blue:0.42 alpha:1.0];
	UIColor *lightBlueColor = [UIColor colorWithRed:0.8 green:0.867 blue:0.937 alpha:1.0];
	
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	self.titleLabel.textColor = darkBlueColor;
	
	if (self.selected) {
		self.backgroundColor = darkBlueColor;
		CGContextSetRGBFillColor(context, 0.176, 0.204, 0.42, 1.0);
	} else {
	
		self.backgroundColor = lightBlueColor;
		
		CGContextSetRGBFillColor(context, 0.8, 0.867, 0.937, 1.0);
	
	}
		
	CGContextFillRect(context, rect);
		
	if (self.selected) {
		self.titleLabel.hidden = YES;
		self.selectedTitleLabel = [[[DTTickingLabel alloc] init] autorelease];
		self.selectedTitleLabel.font = [UIFont boldSystemFontOfSize:17.0];
		self.selectedTitleLabel.backgroundColor = darkBlueColor;
		self.selectedTitleLabel.textColor = lightBlueColor;
		self.selectedTitleLabel.text = self.titleLabel.text;
		self.selectedTitleLabel.frame = CGRectMake(10.0, 0.0, rect.size.width - 20, rect.size.height);
		self.selectedTitleLabel.delay = 1.5;
		self.selectedTitleLabel.speed = 50.0;
		self.selectedTitleLabel.separatingDistance = 0.25;
		[self addSubview:self.selectedTitleLabel];
	} else {
		self.titleLabel.hidden = NO;
		[self.selectedTitleLabel removeFromSuperview];
		self.selectedTitleLabel = nil;
		self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
		self.titleLabel.backgroundColor = self.backgroundColor;
		self.titleLabel.frame = CGRectMake(10.0, 0.0, rect.size.width - 20, rect.size.height);
		[self addSubview:self.titleLabel];
	}
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
