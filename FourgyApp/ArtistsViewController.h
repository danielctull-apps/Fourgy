//
//  ArtistsViewController.h
//  Fourgy
//
//  Created by Daniel Tull on 19.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ArtistsViewController : UITableViewController
- (id)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController;
@property (readonly) NSFetchedResultsController *fetchedResultsController;
@end
