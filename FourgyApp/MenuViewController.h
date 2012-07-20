//
//  MenuViewController.h
//  Fourgy
//
//  Created by Daniel Tull on 19.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "ItemsViewController.h"

@interface MenuViewController : ItemsViewController
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
@end
