//
//  DTiPodNavigationBar.m
//  iPod
//
//  Created by Daniel Tull on 14.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTiPodNavigationBar.h"


@implementation DTiPodNavigationBar


- (id)init {
    if (!(self = [super init])) return nil;
	
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 30.0);
	
    return self;
}


- (void)drawRect:(CGRect)rect {
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 30.0);
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
