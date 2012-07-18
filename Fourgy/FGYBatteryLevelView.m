//
//  FGYBatteryLevelView.m
//  Fourgy
//
//  Created by Daniel Tull on 14.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "FGYBatteryLevelView.h"

@interface FGYBatteryLevelView ()
- (void)fgyInternal_sharedInit;
@end

@implementation FGYBatteryLevelView {
	BOOL charging;
	float progress;
}


- (id)initWithFrame:(CGRect)frame {
	if (!(self = [super initWithFrame:frame])) return nil;
	[self fgyInternal_sharedInit];
	return self;
}

- (void)awakeFromNib {
	[self fgyInternal_sharedInit];
}

- (void)fgyInternal_sharedInit {
	UIDevice *device = [UIDevice currentDevice];
	device.batteryMonitoringEnabled = YES;
	progress = device.batteryLevel;
	
	if (device.batteryState == UIDeviceBatteryStateCharging || device.batteryState == UIDeviceBatteryStateFull)
		charging = YES;
	else
		charging = NO;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryLevelChanged:) name:UIDeviceBatteryLevelDidChangeNotification object:device];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryLevelChanged:) name:UIDeviceBatteryStateDidChangeNotification object:device];
	[self setNeedsDisplay];
}

- (void)batteryLevelChanged:(NSNotification *)notification {
	UIDevice *device = [UIDevice currentDevice];
	progress = device.batteryLevel;
	
	if (device.batteryState == UIDeviceBatteryStateCharging || device.batteryState == UIDeviceBatteryStateFull)
		charging = YES;
	else
		charging = NO;
	
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	
	CGFloat shiftX = 3.0;
	CGFloat width = rect.size.width - shiftX;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBFillColor(context, 0.8, 0.867, 0.937, 1.0);
	CGContextFillRect(context, rect);
	
	CGContextSetRGBFillColor(context, 0.176, 0.204, 0.42, 1.0);
	CGContextFillRect(context, CGRectMake(shiftX, 0.0, width, rect.size.height));
	
	CGContextSetRGBFillColor(context, 0.8, 0.867, 0.937, 1.0);
	CGContextFillRect(context, CGRectMake(width - 2.0 + shiftX, 0.0, 2.0, rect.size.height/4.0));
	
	CGContextFillRect(context, CGRectMake(width - 2.0 + shiftX, 3*rect.size.height/4.0, 2.0, rect.size.height/4.0));
	
	CGContextFillRect(context, CGRectMake(2.0 + shiftX, 2.0, width-6.0, rect.size.height-4.0));
	
	CGContextFillRect(context, CGRectMake(width - 4.0 + shiftX, (rect.size.height/4.0)+2.0, 2.0, (rect.size.height/2.0)-4.0));
	
	CGContextSetRGBFillColor(context, 0.176, 0.204, 0.42, 1.0);
	
	CGContextFillRect(context, CGRectMake(3.0 + shiftX, 3.0, (width-8.0)*progress, rect.size.height-6.0));
	
	if (charging) {
		
		
		CGContextSetRGBFillColor(context, 0.8, 0.867, 0.937, 1.0);
		
		CGContextMoveToPoint(context, 0.0, 0.0);
		CGContextAddLineToPoint(context, 0.0, rect.size.height);
		
		CGContextAddLineToPoint(context, 6.5, rect.size.height);
		CGContextAddLineToPoint(context, 12.0, (rect.size.height/2)-2.0);
		CGContextAddLineToPoint(context, 6.0, (rect.size.height/2)-2.0);
		CGContextAddLineToPoint(context, 9.5, 0.0);
		CGContextAddLineToPoint(context, 0.0, 0.0);
		
		CGContextFillPath(context);
		
		CGContextSetRGBFillColor(context, 0.176, 0.204, 0.42, 1.0);
		CGContextMoveToPoint(context, 3.0, 0.0);
		CGContextAddLineToPoint(context, 0.0, (rect.size.height/2)+1.0);
		CGContextAddLineToPoint(context, 6.0, (rect.size.height/2)+1.0);
		CGContextAddLineToPoint(context, 4.0, rect.size.height);
		CGContextAddLineToPoint(context, 5.0, rect.size.height);
		CGContextAddLineToPoint(context, 10.0, (rect.size.height/2)-1.0);
		CGContextAddLineToPoint(context, 4.0, (rect.size.height/2)-1.0);
		CGContextAddLineToPoint(context, 8.0, 0.0);
		CGContextAddLineToPoint(context, 3.0, 0.0);

		CGContextFillPath(context);
	
	
	
	}
}

- (void)dealloc {
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	UIDevice *device = [UIDevice currentDevice];
	[defaultCenter removeObserver:self name:UIDeviceBatteryLevelDidChangeNotification object:device];
	[defaultCenter removeObserver:self name:UIDeviceBatteryStateDidChangeNotification object:device];
}

@end
