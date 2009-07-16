//
//  DTiPodTableViewCell.h
//  iPod
//
//  Created by Daniel Tull on 13.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTGridViewCell.h"


@interface DTiPodTableViewCell : DTGridViewCell {
	UILabel *textLabel;
}

@property (nonatomic, retain) UILabel *textLabel;

@end
