//
//  UITableViewController+_FGYClickWheelDelegate.h
//  Fourgy
//
//  Created by Daniel Tull on 18.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGYClickWheel.h"
#import "FGYTableViewController.h"
#import "FGYController.h"

@interface _FGYTableViewScrollHandler : NSObject

- (id)initWithTableView:(UITableView *)tableView
	   fourgyController:(FGYController *)fourgyController;

- (void)clickWheelTouchesMovedToAngle:(CGFloat)angle distance:(CGFloat)distance;

@end
