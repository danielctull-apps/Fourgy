//
//  DTScreenViewController.h
//  iPod
//
//  Created by Daniel Tull on 16.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTBlockView.h"

@interface DTScreenViewController : UIViewController <DTBlockViewDataSource> {
	DTBlockView *itemsView;
}

@end
