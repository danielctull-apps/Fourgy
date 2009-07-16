//
//  DTBatteryLevelView.h
//  iPod
//
//  Created by Daniel Tull on 14.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DTBatteryLevelView : UIProgressView {
	BOOL charging;
}
- (void)setup;
@end
