//
//  DTTickingLabel.m
//  DTKit
//
//  Created by Daniel Tull on 09/12/2008.
//  Copyright 2008 Daniel Tull. All rights reserved.
//

#import "FGYTickingLabel.h"

@implementation FGYTickingLabel

@synthesize isAnimating, speed, separatingDistance, delay;

- (id)initWithFrame:(CGRect)aRect {
	
	if (!(self = [super initWithFrame:aRect]))
		return nil;
	
	separatingDistance = 0.5;
	speed = 50.0;
	label1 = nil;
	label2 = nil;
	isAnimating = NO;
	
	return self;
}


- (void)awakeFromNib {
	self.separatingDistance = 0.5;
	self.speed = 50.0;
	label1 = nil;
	label2 = nil;
	isAnimating = NO;
}

- (void)setText:(NSString *)aString {
	if ([aString isEqualToString:self.text])
		return;
	
	[super setText:aString];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	
	for (UIView *v in self.subviews)
		[v removeFromSuperview];
	
	CGSize size = [self.text sizeWithFont:self.font];
	
	if (size.width < rect.size.width) {
		[super drawRect:rect];
		return;
	}
	
	frame1 = CGRectMake(0.0, 0.0, size.width, self.frame.size.height);
	frame2 = CGRectMake(frame1.size.width + (self.separatingDistance * rect.size.width), frame1.origin.y, frame1.size.width, frame1.size.height);
	frame3 = CGRectMake(0.0 - frame1.size.width - (self.separatingDistance * rect.size.width), frame1.origin.y, frame1.size.width, frame1.size.height);
	
	duration = (frame1.size.width + self.separatingDistance) / self.speed;
	
	shouldDealloc = NO;
	
	[label1 removeFromSuperview];
	label1 = [self pureLabel:self];
	
	label1.frame = frame1;
	
	[self addSubview:label1];
	
	[label2 removeFromSuperview];
	label2 = [self pureLabel:self];
	label2.frame = frame2;	
	[self addSubview:label2];
	
	if (!isAnimating)
		[self animate];
}

#pragma mark Animation delegates

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	
	if (!self.superview)
		return;
	
	isAnimating = NO;
	
	label1.frame = frame1;
	label2.frame = frame2;

	[self animate];
}

- (UILabel *)pureLabel:(UILabel *)aLabel {
	
	UILabel *returnLabel = [[UILabel alloc] initWithFrame:aLabel.frame];
	
	returnLabel.text = aLabel.text;
	returnLabel.font = aLabel.font;
	returnLabel.textColor = aLabel.textColor;
	returnLabel.textAlignment = aLabel.textAlignment;
	returnLabel.lineBreakMode = aLabel.lineBreakMode;
	returnLabel.enabled = aLabel.enabled;
	
	returnLabel.adjustsFontSizeToFitWidth = aLabel.adjustsFontSizeToFitWidth;
	returnLabel.baselineAdjustment = aLabel.baselineAdjustment;
	returnLabel.minimumFontSize = aLabel.minimumFontSize;
	returnLabel.numberOfLines = aLabel.numberOfLines;
	
	returnLabel.highlightedTextColor = aLabel.highlightedTextColor;
	returnLabel.highlighted = aLabel.highlighted;
	
	returnLabel.shadowColor = aLabel.shadowColor;
	returnLabel.shadowOffset = aLabel.shadowOffset;
	
	returnLabel.userInteractionEnabled = aLabel.userInteractionEnabled;
	
	returnLabel.backgroundColor = aLabel.backgroundColor;
	
	return returnLabel;
}

- (void)animate {
	[UIView beginAnimations:@"ticking" context:nil];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDelay:self.delay];
	[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
	isAnimating = YES;
	
	label1.frame = frame3;
	label2.frame = frame1;
	
	[UIView commitAnimations];
	
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@ text = %@ > subviews = %@", [self class], self.text, self.subviews];
}

@end

/*

//
//  WETickerView.m
//  DTTableViewTester
//
//  Created by Daniel Tull on 09/12/2008.
//  Copyright 2008 Daniel Tull. All rights reserved.
//

#import "WETickerView.h"


@implementation WETickerView

@synthesize text, label;

- (id)initWithFrame:(CGRect)frame text:(NSString *)text {
    if (![super initWithFrame:frame])
		return nil;
	
	self.clipsToBounds = YES;
	self.text = text;
	label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.height, frame.size.width)];
	
	self.backgroundColor = [UIColor clearColor];
	
	
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	
	return [self initWithFrame:frame text:@""];
	
}


- (void)drawRect:(CGRect)rect {

	CGSize size = [text sizeWithFont:label.font];

	label.frame = CGRectMake(0.0, 0.0, size.width, self.frame.size.height);
	
	rectToMoveFrom = CGRectMake(label.frame.origin.x + label.frame.size.width + (self.frame.size.width / 2), 0.0, label.frame.size.width, label.frame.size.height);
	
	label.text = self.text;
	label.backgroundColor = self.backgroundColor;

	label1 = [[self pureLabel:label] retain];

	label2 = [[self pureLabel:label] retain];
	label2.frame = rectToMoveFrom;

	
	
	rectToMoveTo = CGRectMake(label1.frame.origin.x - label2.frame.origin.x, 0.0, label1.frame.size.width, label1.frame.size.height);
	duration = (label.frame.size.width + (self.frame.size.width / 2)) / 35;
	
	[self addSubview:label1];
	[self addSubview:label2];

	[self animate];

}

#pragma mark Animation delegates

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	
	if ([animationID isEqualToString:@"ticking"]) {
		label1.frame = rectToMoveFrom;
		[self animate2];
	} else {
		label2.frame = rectToMoveFrom;
		[self animate];	
	}
}

- (UILabel *)pureLabel:(UILabel *)aLabel {
	
	UILabel *returnLabel = [[UILabel alloc] initWithFrame:aLabel.frame];
	
	returnLabel.text = aLabel.text;
	
	//if (aLabel.font)
	returnLabel.font = aLabel.font;
	
	//if (aLabel.textColor)
	returnLabel.textColor = aLabel.textColor;
	returnLabel.textAlignment = aLabel.textAlignment;
	returnLabel.lineBreakMode = aLabel.lineBreakMode;
	returnLabel.enabled = aLabel.enabled;
	
	returnLabel.adjustsFontSizeToFitWidth = aLabel.adjustsFontSizeToFitWidth;
	returnLabel.baselineAdjustment = aLabel.baselineAdjustment;
	returnLabel.minimumFontSize = aLabel.minimumFontSize;
	returnLabel.numberOfLines = aLabel.numberOfLines;
	
	returnLabel.highlightedTextColor = aLabel.pureLabel;
	returnLabel.highlighted = aLabel.highlighted;
	
	returnLabel.shadowColor = aLabel.shadowColor;
	returnLabel.shadowOffset = aLabel.shadowOffset;
	
	returnLabel.userInteractionEnabled = aLabel.userInteractionEnabled;
	
	returnLabel.backgroundColor = aLabel.backgroundColor;
	
	return returnLabel;
}

- (void)animate {	
	[UIView beginAnimations:@"ticking" context:nil];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
	
	label1.frame = rectToMoveTo;
	label2.frame = label.frame;
	
	[UIView commitAnimations];
}

- (void)animate2 {	
	[UIView beginAnimations:@"ticking2" context:nil];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
	
	label2.frame = rectToMoveTo;
	label1.frame = label.frame;
	
	[UIView commitAnimations];
}


- (void)dealloc {
	[self.text release];
	[self.label release];

	if (label1)
		[label1 release];
		
	if (label2)
		[label2 release];

    [super dealloc];
}


@end
*/