//
//  FGYClickWheel.m
//  Fourgy
//
//  Created by Daniel Tull on 13.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "_FGYClickWheel.h"

@implementation FGYClickWheel

@synthesize delegate;

- (void)drawRect:(CGRect)dirtyRect {
	
	CGRect rect = self.bounds;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
	CGContextFillRect(context, rect);
	
	CGContextSetRGBFillColor(context, 0.824f, 0.824f, 0.843f, 1.0f);
	CGContextFillEllipseInRect(context, rect);
	
	CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);

	CGContextFillEllipseInRect(context, CGRectInset(rect, rect.size.width/3.0f, rect.size.width/3.0f));
	
	UILabel *menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width/3.0f, 
																   rect.size.width/27.0f,
																   rect.size.width/3.0f,
																   rect.size.width/12.0f)];
	menuLabel.textColor = [UIColor whiteColor];
	menuLabel.text = @"MENU";
	menuLabel.font = [UIFont boldSystemFontOfSize:14.5f];
	menuLabel.textAlignment = UITextAlignmentCenter;
	menuLabel.backgroundColor = [UIColor clearColor];//colorWithRed:0.824f green:0.824f blue:0.843f alpha:1.0f];
	[self addSubview:menuLabel];
	
	
	CGFloat w = (CGFloat)(NSInteger)rect.size.width/2.0f;
	
	CGRect playRect = CGRectMake(w - 15.0f, rect.size.height - 15.0f - 12.0f, 13.0f, 12.0f);
	CGRect pauseRect = CGRectMake(w + 4.0f, rect.size.height - 15.0f - 12.0f, 9.0f, 12.0f);
	
	CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
	CGContextMoveToPoint(context, playRect.origin.x, playRect.origin.y);
	CGContextAddLineToPoint(context, playRect.origin.x+playRect.size.width, playRect.origin.y+((CGFloat)(NSInteger)playRect.size.height)/2.0f);
	CGContextAddLineToPoint(context, playRect.origin.x, playRect.origin.y + playRect.size.height);
	CGContextAddLineToPoint(context, playRect.origin.x, playRect.origin.y);
	CGContextFillPath(context);
	
	CGContextFillRect(context, CGRectMake(pauseRect.origin.x, pauseRect.origin.y, pauseRect.size.width/3.0f, pauseRect.size.height));
	CGContextFillRect(context, CGRectMake(pauseRect.origin.x + 2.0f*pauseRect.size.width/3.0f, pauseRect.origin.y, pauseRect.size.width/3.0f, pauseRect.size.height));
	
	
	CGFloat width = 10.0f;
	CGFloat height = 12.0f;
	CGFloat yPos = (CGFloat)(NSInteger)(rect.size.height/2.0f - height/2.0f);
	CGFloat initialX = 12.0f;
	
	CGContextMoveToPoint(context, initialX, yPos + height / 2.0f);
	CGContextAddLineToPoint(context, initialX + width, yPos);
	CGContextAddLineToPoint(context, initialX + width, yPos + height);
	CGContextAddLineToPoint(context, initialX, yPos + height / 2.0f);
	CGContextFillPath(context);
	CGContextMoveToPoint(context, initialX+width, yPos + height / 2.0f);
	CGContextAddLineToPoint(context, initialX + 2.0f*width, yPos);
	CGContextAddLineToPoint(context, initialX + 2.0f*width, yPos + height);
	CGContextAddLineToPoint(context, initialX + width, yPos + height / 2.0f);
	CGContextFillPath(context);
	CGContextFillRect(context, CGRectMake(initialX-3.0f, yPos, 3.0f, height));
	initialX = (CGFloat)(NSInteger)(rect.size.width - 2.0f*width - 10.0f);
	
	
	
	CGContextMoveToPoint(context, initialX, yPos);
	CGContextAddLineToPoint(context, initialX + width, yPos + height/2.0f);
	CGContextAddLineToPoint(context, initialX, yPos + height);
	CGContextAddLineToPoint(context, initialX, yPos);
	CGContextFillPath(context);
	CGContextMoveToPoint(context, initialX+width, yPos);
	CGContextAddLineToPoint(context, initialX + 2.0f*width, yPos + height/2.0f);
	CGContextAddLineToPoint(context, initialX + width, yPos + height);
	CGContextAddLineToPoint(context, initialX + width, yPos);
	CGContextFillPath(context);
	CGContextFillRect(context, CGRectMake(initialX + 2.0f*width, yPos, 3.0f, height));
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[super touchesBegan:touches withEvent:event];
	
	if ([self.delegate respondsToSelector:@selector(clickWheelTouchesBegan)])
		[self.delegate clickWheelTouchesBegan];
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[super touchesEnded:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];
 
    if ([touch tapCount] == 1) {
        CGPoint tapPoint = [touch locationInView:self];
		
		CGFloat thirdwidth = self.frame.size.width/3.0f;
		
		if (tapPoint.x > thirdwidth && 
			tapPoint.y > thirdwidth && 
			tapPoint.x < 2.0f * thirdwidth && 
			tapPoint.y < 2.0f * thirdwidth) {
			
			if ([self.delegate respondsToSelector:@selector(clickWheelCenterButtonTapped)])
				[self.delegate clickWheelCenterButtonTapped];
			
		} else if (tapPoint.x > thirdwidth && 
				   tapPoint.y > 0.0f && 
				   tapPoint.x < 2.0f * thirdwidth && 
				   tapPoint.y < thirdwidth) {
			
			if ([self.delegate respondsToSelector:@selector(clickWheelMenuButtonTapped)])
				[self.delegate clickWheelMenuButtonTapped];
			
		} else if (tapPoint.x > thirdwidth && 
				   tapPoint.y > 2.0f * thirdwidth &&
				   tapPoint.x < 2.0f * thirdwidth && 
				   tapPoint.y < 3.0f * thirdwidth) {
			
			if ([self.delegate respondsToSelector:@selector(clickWheelPlayButtonTapped)])
				[self.delegate clickWheelPlayButtonTapped];
			
		} else if (tapPoint.x > 0.0f &&
				   tapPoint.y > thirdwidth && 
				   tapPoint.x < thirdwidth && 
				   tapPoint.y < 2.0f * thirdwidth) {
			
			if ([self.delegate respondsToSelector:@selector(clickWheelPreviousButtonTapped)])
				[self.delegate clickWheelPreviousButtonTapped];
			
		} else if (tapPoint.x > 2.0f * thirdwidth &&
				   tapPoint.y > thirdwidth && 
				   tapPoint.x < 3.0f * thirdwidth && 
				   tapPoint.y < 2.0f * thirdwidth) {
			
			if ([self.delegate respondsToSelector:@selector(clickWheelNextButtonTapped)])
				[self.delegate clickWheelNextButtonTapped];
			
		}
    } else {
		
		if ([self.delegate respondsToSelector:@selector(clickWheelTouchesEnded)])
			[self.delegate clickWheelTouchesEnded];
		
	}
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

	CGPoint point = [[touches anyObject] locationInView:self];
	
	CGFloat x = point.x - (self.frame.size.width/2.0f);
	CGFloat y = point.y - (self.frame.size.height/2.0f);
	
	CGFloat result = 90.0f;	// x=x angle=90
	if (point.x != 0.0f)
		result = 180.0f * ((CGFloat)atan(fabs(y/x))) / (CGFloat)M_PI;
	
	CGFloat rotation = 0.0f;
	
	// work out what quadrant we are in
	if(y >= 0.0f)
		rotation = (x >= 0.0f) ? 90.0f + result : 270.0f - result;
	else
		rotation = (x >= 0.0f) ? 90.0f - result : 270.0f + result;
	
	CGFloat distance = ((CGFloat)sqrt((x * x) + (y * y)));
	
	if ([self.delegate respondsToSelector:@selector(clickWheelTouchesMovedToAngle:distance:)])
		[self.delegate clickWheelTouchesMovedToAngle:rotation distance:distance];
}

@end
