//
//  DTScreenTableViewController.h
//  iPod
//
//  Created by Daniel Tull on 14.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DTGridViewController.h"

@interface DTScreenTableViewController : DTGridViewController {
	NSArray *collections;
	NSArray *items;
	NSString *property;
	
	BOOL firstRun;
}

- (id)initWithArray:(NSArray *)array;
- (id)initWithQuery:(MPMediaQuery *)query property:(NSString *)aProperty;

@end
