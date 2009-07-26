//
//  DTBlockScrollerView.h
//  iPod
//
//  Created by Daniel Tull on 26.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DTBlockScroller : UIView {
	NSInteger numberOfitems, numberOfItemsOnScreen, currentItemNumber, minimumKnobHeight;
	UIEdgeInsets knobInsets, scrollerInsets;
}

@property (nonatomic, assign) NSInteger numberOfitems, numberOfItemsOnScreen, currentItemNumber, minimumKnobHeight;
@property (nonatomic, assign) UIEdgeInsets knobInsets, scrollerInsets;

- (void)drawBackgroundInRect:(CGRect)rect;
- (void)drawKnobInRect:(CGRect)rect;

@end
