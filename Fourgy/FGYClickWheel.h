//
//  FGYClickWheel.h
//  Fourgy
//
//  Created by Daniel Tull on 13.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FGYClickWheelDelegate <NSObject>
@optional
- (void)clickWheelMenuButtonTapped;
- (void)clickWheelPreviousButtonTapped;
- (void)clickWheelNextButtonTapped;
- (void)clickWheelPlayButtonTapped;
- (void)clickWheelCenterButtonTapped;
- (void)clickWheelTouchesMovedToAngle:(CGFloat)angle distance:(CGFloat)distance;
- (void)clickWheelTouchesEnded;
- (void)clickWheelTouchesBegan;
@end
