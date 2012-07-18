//
//  FGYClickWheel.h
//  Fourgy
//
//  Created by Daniel Tull on 13.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FGYClickWheelDelegate;

@interface FGYClickWheel : UIView
@property (nonatomic, assign) IBOutlet id<FGYClickWheelDelegate> delegate;
@end


@protocol FGYClickWheelDelegate <NSObject>
@optional
- (void)clickWheelMenuButtonTapped:(FGYClickWheel *)clickWheel;
- (void)clickWheelPreviousButtonTapped:(FGYClickWheel *)clickWheel;
- (void)clickWheelNextButtonTapped:(FGYClickWheel *)clickWheel;
- (void)clickWheelPlayButtonTapped:(FGYClickWheel *)clickWheel;
- (void)clickWheelCenterButtonTapped:(FGYClickWheel *)clickWheel;
- (void)clickWheel:(FGYClickWheel *)clickWheel touchesMovedToAngle:(CGFloat)angle distance:(CGFloat)distance;
- (void)clickWheelTouchesEnded:(FGYClickWheel *)clickWheel;
- (void)clickWheelTouchesBegan:(FGYClickWheel *)clickWheel;
@end
