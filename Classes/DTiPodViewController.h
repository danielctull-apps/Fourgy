//
//  DTiPodViewController.h
//  iPod
//
//  Created by Daniel Tull on 13.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTClickWheelView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface DTiPodViewController : UIViewController {

	SystemSoundID clickSound;
	
	UITableView *screenTable;
	CGFloat oldAngle, difference;
	
	BOOL doneOnce;
	UIView *screenView;
	UINavigationController *nav;
	
	NSInteger rotations;
	CGFloat rotation360check;
	
}

@property (nonatomic, retain) IBOutlet UITableView *screenTable;
@property (nonatomic, retain) IBOutlet UIView *screenView;

@end
