//
//  MediaItemsViewController.h
//  Fourgy
//
//  Created by Daniel Tull on 19.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import <Fourgy/Fourgy.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MediaItemsViewController : UITableViewController
- (id)initWithMediaQuery:(MPMediaQuery *)query property:(NSString *)property;
@end
