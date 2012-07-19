//
//  MenuViewController.h
//  Fourgy
//
//  Created by Daniel Tull on 19.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UITableViewController
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
@property (readonly) NSManagedObjectContext *managedObjectContext;
@end
