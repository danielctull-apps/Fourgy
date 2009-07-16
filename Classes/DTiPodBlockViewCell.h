//
//  DTiPodBlockViewCell.h
//  iPod
//
//  Created by Daniel Tull on 16.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTBlockViewCellProtocol.h"

@interface DTiPodBlockViewCell : UIView <DTBlockViewCellProtocol> {
	UILabel *titleLabel;
	NSInteger *rowIndex;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, assign) NSInteger *rowIndex;

@end
