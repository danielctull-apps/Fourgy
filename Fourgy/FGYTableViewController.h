//
//  FGYTableViewController.h
//  Fourgy
//
//  Created by Daniel Tull on 20.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGYClickWheel.h"

@interface FGYTableViewController : UIViewController <FGYClickWheelDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
