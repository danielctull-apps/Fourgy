//
//  DTClickWheelView.m
//  iPod
//
//  Created by Daniel Tull on 13.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTClickWheelView.h"

@interface DTClickWheelView ()
-(void)calculateAngleFromPoint:(CGPoint)point;
@end


@implementation DTClickWheelView

@synthesize rotation, distance, delegate;

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(context, 0.824, 0.824, 0.843, 1.0);
	CGContextFillEllipseInRect(context, rect);
	
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextFillEllipseInRect(context, CGRectInset(rect, rect.size.width/3, rect.size.width/3));
	
	UILabel *menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width/3, rect.size.width/27, rect.size.width/3, rect.size.width/12)];
	menuLabel.textColor = [UIColor whiteColor];
	menuLabel.text = @"MENU";
	menuLabel.font = [UIFont boldSystemFontOfSize:13.5];
	menuLabel.textAlignment = UITextAlignmentCenter;
	menuLabel.backgroundColor = [UIColor colorWithRed:0.824 green:0.824 blue:0.843 alpha:1.0];
	[self addSubview:menuLabel];
	[menuLabel release];
	/*
	UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width/21, 11*rect.size.width/24, rect.size.width/6, rect.size.width/12)];
	backLabel.textColor = [UIColor whiteColor];
	backLabel.text = @"|<";
	backLabel.font = [UIFont boldSystemFontOfSize:13.5];
	backLabel.textAlignment = UITextAlignmentLeft;
	backLabel.backgroundColor = [UIColor colorWithRed:0.824 green:0.824 blue:0.843 alpha:1.0];
	[self addSubview:backLabel];
	[backLabel release];
	
	UILabel *nextLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width - rect.size.width/21 - rect.size.width/6, 11*rect.size.width/24, rect.size.width/6, rect.size.width/12)];
	nextLabel.textColor = [UIColor whiteColor];
	nextLabel.text = @">|";
	nextLabel.font = [UIFont boldSystemFontOfSize:13.5];
	nextLabel.textAlignment = UITextAlignmentRight;
	nextLabel.backgroundColor = [UIColor colorWithRed:0.824 green:0.824 blue:0.843 alpha:1.0];
	[self addSubview:nextLabel];
	[nextLabel release];*/
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {


}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
 
    if ([touch tapCount] == 1) {
        CGPoint tapPoint = [touch locationInView:self];
		
		CGFloat f = self.frame.size.width/3;
		
		if (tapPoint.x > f && tapPoint.y > f && tapPoint.x < 2*f && tapPoint.y < 2*f) {
			if ([self.delegate respondsToSelector:@selector(centerButtonTappedOnClickWheel:)])
				[self.delegate centerButtonTappedOnClickWheel:self];
		} else if (tapPoint.x > f && tapPoint.y > 0 && tapPoint.x < 2*f && tapPoint.y < f) {
			if ([self.delegate respondsToSelector:@selector(menuButtonTappedOnClickWheel:)])
				[self.delegate menuButtonTappedOnClickWheel:self];
		}
    }
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[self calculateAngleFromPoint:[[touches anyObject] locationInView:self]];
	
	if ([self.delegate respondsToSelector:@selector(clickWheel:touchesMovedToAngle:distance:)])
		[self.delegate clickWheel:self touchesMovedToAngle:self.rotation distance:distance];
}

-(void)calculateAngleFromPoint:(CGPoint)point {
	
	float x=point.x-(self.frame.size.width/2);
	float y=point.y-(self.frame.size.height/2);
	
	float result=90;	// x=x angle=90
	if(point.x!=0)
		result=180*atan(fabs(y/x))/M_PI;
	
	// work out what quadrant we are in
	if(y>=0) {
		self.rotation = x>=0 ? 90.0 + result : 270.0 - result;
	} else {
		self.rotation = x>=0 ? 90.0 - result : 270.0 + result;
	}
	
	self.distance = sqrt((x*x)+(y*y));
	
}

@end
