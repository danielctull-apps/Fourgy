//
//  DTiPodViewController.h
//  iPod
//
//  Created by Daniel Tull on 13.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTClickWheelView.h"

@interface DTiPodViewController : UIViewController <UITableViewDataSource, DTClickWheelViewDelegate> {
	
	UITableView *screenTable;
	CGFloat oldAngle, difference;
	
	
	UIView *screenView;
	UINavigationController *nav;
	
}

@property (nonatomic, retain) IBOutlet UITableView *screenTable;
@property (nonatomic, retain) IBOutlet UIView *screenView;

@end
