//
//  DTClickWheelView.h
//  iPod
//
//  Created by Daniel Tull on 13.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTClickWheelViewDelegate;

@interface DTClickWheelView : UIView {
	CGFloat rotation, distance;
	NSObject<DTClickWheelViewDelegate> *delegate;
}

@property (nonatomic, assign) CGFloat rotation, distance;
@property (nonatomic, assign) IBOutlet NSObject<DTClickWheelViewDelegate> *delegate;

@end


@protocol DTClickWheelViewDelegate
@optional
- (void)menuButtonTappedOnClickWheel:(DTClickWheelView *)clickWheel;
- (void)backButtonTappedOnClickWheel:(DTClickWheelView *)clickWheel;
- (void)nextButtonTappedOnClickWheel:(DTClickWheelView *)clickWheel;
- (void)playButtonTappedOnClickWheel:(DTClickWheelView *)clickWheel;
- (void)centerButtonTappedOnClickWheel:(DTClickWheelView *)clickWheel;
- (void)clickWheel:(DTClickWheelView *)clickWheel touchesMovedToAngle:(CGFloat)angle distance:(CGFloat)distance;
@end
