//
//  DTPlaybackTimeView.m
//  iPod
//
//  Created by Daniel Tull on 23.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTPlaybackTimeView.h"
#import "NSString+DTPrefixString.h"

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
	NSInteger remaining = (NSInteger)duration - time;
	playedLabel.text = [self timeStringForSeconds:time];
	remainingLabel.text = [NSString stringWithFormat:@"-%@", [self timeStringForSeconds:remaining]];
	

	
}

- (NSString *)timeStringForSeconds:(NSInteger)time {
	NSString *hoursString = @"";
	NSString *minutesString = @"";
	NSString *secondsString = @"";
		
	NSInteger minutes = (NSInteger)(time / 60);
	NSInteger hours = 0;
	NSInteger seconds = time % 60;
	
	minutesString = [NSString stringWithFormat:@"%@:", [NSString stringWithFormat:@"%i", minutes]];
	
	if (minutes > 59) {
		hours = (NSInteger)(minutes / 60);
		hoursString = [NSString stringWithFormat:@"%@:", [NSString stringWithFormat:@"%i", hours]];
		minutes = minutes % 60;
		minutesString = [NSString stringWithFormat:@"%@:", [[NSString stringWithFormat:@"%i", minutes] stringByPrefixingWithString:@"0" resultingInLength:2]];
	}
	
	secondsString = [[NSString stringWithFormat:@"%i", seconds] stringByPrefixingWithString:@"0" resultingInLength:2];
	
	
	return [NSString stringWithFormat:@"%@%@%@", hoursString, minutesString, secondsString];
	
	
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
