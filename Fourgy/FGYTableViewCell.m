//
//  FGYTableViewCell.m
//  Fourgy
//
//  Created by Daniel Tull on 20.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "Fourgy.h"

@interface FGYTableViewCell ()
@property (nonatomic, strong) IBOutlet FGYTickingLabel *tickingTextLabel;
@property (nonatomic, strong) IBOutlet UILabel *standardTextLabel;
@end

@implementation FGYTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (!self) return nil;
	
	self.tickingTextLabel = [[FGYTickingLabel alloc] initWithFrame:CGRectInset(self.bounds, 10.0f, 0.0f)];
	self.standardTextLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 10.0f, 0.0f)];
	
	self.tickingTextLabel.delay = 1.0;
	self.tickingTextLabel.font = [Fourgy fontOfSize:12.0f];
	self.tickingTextLabel.textColor = [Fourgy foregroundColor];
	self.tickingTextLabel.backgroundColor = [Fourgy backgroundColor];
	self.tickingTextLabel.highlightedTextColor = [Fourgy backgroundColor];
	
	self.standardTextLabel.font = [Fourgy fontOfSize:12.0f];
	self.standardTextLabel.textColor = [Fourgy foregroundColor];
	self.standardTextLabel.backgroundColor = [Fourgy backgroundColor];
	self.standardTextLabel.highlightedTextColor = [Fourgy backgroundColor];
	
	self.contentView.backgroundColor = [Fourgy backgroundColor];
	self.backgroundColor = [Fourgy backgroundColor];
	
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	self.tickingTextLabel.frame = CGRectInset(self.contentView.bounds, 10.0f, 0.0f);
	self.standardTextLabel.frame = CGRectInset(self.contentView.bounds, 10.0f, 0.0f);
	[self.contentView addSubview:self.tickingTextLabel];
	[self.contentView addSubview:self.standardTextLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	self.tickingTextLabel.hidden = !selected;
	self.standardTextLabel.hidden = selected;
}

- (void)setText:(NSString *)text {
	_text = [text copy];
	self.tickingTextLabel.text = text;
	self.standardTextLabel.text = text;
}

@end
