//
//  DTiPodTableViewCell.m
//  iPod
//
//  Created by Daniel Tull on 13.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTiPodTableViewCell.h"

@implementation DTiPodTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		//self.frame = CGRectMake(0.0, 0.0, 240.0, 27.0);
		
		UIView *bgView = [[UIView alloc] init];
		bgView.backgroundColor = [UIColor colorWithRed:0.8 green:0.867 blue:0.937 alpha:1.0];
		self.backgroundView = bgView;
		[bgView release];
		
		UIView *sbgView = [[UIView alloc] init];
		sbgView.backgroundColor = [UIColor colorWithRed:0.176 green:0.204 blue:0.42 alpha:1.0];
		self.selectedBackgroundView = sbgView;
		[sbgView release];
		
		self.textLabel.backgroundColor = [UIColor colorWithRed:0.8 green:0.867 blue:0.937 alpha:1.0];
		self.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
		self.textLabel.textColor = [UIColor colorWithRed:0.176 green:0.204 blue:0.42 alpha:1.0];
		//self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}
/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {	
	[super setSelected:selected animated:animated];
}

- (void)setSelected:(BOOL)selected {
	if (selected)
		self.textLabel.textColor = [UIColor colorWithRed:0.8 green:0.867 blue:0.937 alpha:1.0];
	else
		self.textLabel.textColor = [UIColor colorWithRed:0.176 green:0.204 blue:0.42 alpha:1.0];

	[super setSelected:selected];
}
*/
- (void)dealloc {
    [super dealloc];
}


@end
