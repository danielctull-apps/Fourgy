//
//  DTPlaybackTimeView.m
//  iPod
//
//  Created by Daniel Tull on 23.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTPlaybackTimeView.h"


@implementation DTPlaybackTimeView


- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
	
	iPod = [[MPMusicPlayerController iPodMusicPlayer] retain];
	timer = [[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer:) userInfo:nil repeats:YES] retain];
	
    return self;
}

- (void)awakeFromNib {
	iPod = [[MPMusicPlayerController iPodMusicPlayer] retain];
	timer = [[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timer:) userInfo:nil repeats:YES] retain];
}


- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(context, 0.8, 0.867, 0.937, 1.0);
	CGContextFillRect(context, rect);
	
	
	CGFloat radius = 7;
	

	
	/*CGContextMoveToPoint(context, radius, indent);
	CGContextAddLineToPoint(context, rect.size.width - radius, indent);
	CGContextAddArcToPoint(context, rect.size.width - indent, indent, rect.size.width-indent, radius, radius-indent);
	CGContextAddArcToPoint(context, rect.size.width - indent, 2*radius - indent, rect.size.width - radius, 2*radius - indent, radius-indent);
	CGContextAddLineToPoint(context, radius, 2*radius - indent);
	CGContextAddArcToPoint(context, indent, 2*radius - indent, indent, radius, radius-indent);
	CGContextAddArcToPoint(context, indent, indent, radius, indent, radius-indent);
	
	CGContextSetLineWidth(context, 2.0);
	CGContextSetRGBStrokeColor(context, 0.176, 0.204, 0.42, 1.0);
	CGContextStrokePath(context);*/
	
	/*
	indent = 2.0;
	
	CGContextMoveToPoint(context, radius, indent);
	CGContextAddLineToPoint(context, rect.size.width - radius, indent);
	CGContextAddArcToPoint(context, rect.size.width - indent, indent, rect.size.width-indent, radius, radius-indent);
	CGContextAddArcToPoint(context, rect.size.width - indent, 2*radius - indent, rect.size.width - radius, 2*radius - indent, radius-indent);
	CGContextAddLineToPoint(context, radius, 2*radius - indent);
	CGContextAddArcToPoint(context, indent, 2*radius - indent, indent, radius, radius-indent);
	CGContextAddArcToPoint(context, indent, indent, radius, indent, radius-indent);
	CGContextSetRGBFillColor(context, 0.8, 0.867, 0.937, 1.0);
	CGContextFillPath(context);*/
	
	CGFloat indent = 1.0;
	
	CGContextMoveToPoint(context, radius, indent);
	CGContextAddLineToPoint(context, rect.size.width - radius, indent);
	CGContextAddArcToPoint(context, rect.size.width - indent, indent, rect.size.width-indent, radius, radius-indent);
	CGContextAddArcToPoint(context, rect.size.width - indent, 2*radius - indent, rect.size.width - radius, 2*radius - indent, radius-indent);
	CGContextAddLineToPoint(context, radius, 2*radius - indent);
	CGContextAddArcToPoint(context, indent, 2*radius - indent, indent, radius, radius-indent);
	CGContextAddArcToPoint(context, indent, indent, radius, indent, radius-indent);
	CGContextSetRGBFillColor(context, 0.176, 0.204, 0.42, 1.0);
	CGContextFillPath(context);
	
	
	CGFloat duration = [[iPod.nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue];
	CGFloat percentage = iPod.currentPlaybackTime / duration;
	CGFloat width = (rect.size.width - 2*indent) * (1 - percentage);
	CGRect coverUpRect = CGRectMake(rect.size.width - indent - width, indent, width, 2*(radius-indent));
	CGContextSetRGBFillColor(context, 0.8, 0.867, 0.937, 1.0);
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
	CGContextSetRGBStrokeColor(context, 0.176, 0.204, 0.42, 1.0);
	CGContextStrokePath(context);
	
	NSInteger heightInt = (NSInteger)rect.size.height;
	NSInteger widthInt = (NSInteger)rect.size.width;
	
	if (!playedLabel) {
		playedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, heightInt - 21, 100, 21)];
		playedLabel.textAlignment = UITextAlignmentLeft;
		playedLabel.backgroundColor = [UIColor clearColor];
		playedLabel.font = [UIFont boldSystemFontOfSize:17.0];
		playedLabel.textColor = [UIColor colorWithRed:0.176 green:0.204 blue:0.42 alpha:1.0];
		[self addSubview:playedLabel];
	}
	if (!remainingLabel) {
		remainingLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthInt-100, heightInt - 21, 100, 21)];
		remainingLabel.textAlignment = UITextAlignmentRight;
		remainingLabel.backgroundColor = [UIColor clearColor];
		remainingLabel.font = [UIFont boldSystemFontOfSize:17.0];
		remainingLabel.textColor = [UIColor colorWithRed:0.176 green:0.204 blue:0.42 alpha:1.0];
		[self addSubview:remainingLabel];
	}
	
	NSInteger time = (NSInteger)iPod.currentPlaybackTime;
	
	NSInteger mins = (NSInteger)(iPod.currentPlaybackTime / 60);
	NSInteger secs = (NSInteger)(time % 60);
	
	if (secs < 10)
		playedLabel.text = [NSString stringWithFormat:@"%i:0%i", mins, secs];	
	else
		playedLabel.text = [NSString stringWithFormat:@"%i:%i", mins, secs];

	
	NSInteger remainingTime = (NSInteger)duration - time;
	
	mins = (NSInteger)(remainingTime / 60);
	secs = (NSInteger)(remainingTime % 60);
	
	if (secs < 10)
		remainingLabel.text = [NSString stringWithFormat:@"-%i:0%i", mins, secs];	
	else
		remainingLabel.text = [NSString stringWithFormat:@"-%i:%i", mins, secs];
	
}

- (void)setup {

}

- (void)timer:(NSTimer *)timer {
	[self setNeedsDisplay];
}

- (void)dealloc {
	[remainingLabel release];
	[playedLabel release];
	[iPod release];
	[timer invalidate];
	[timer release];
    [super dealloc];
}


@end
