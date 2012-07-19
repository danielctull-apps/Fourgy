//
//  FGYController.h
//  Fourgy
//
//  Created by Daniel Tull on 25.12.2011.
//  Copyright (c) 2011 Daniel Tull Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGYController : UIViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController;

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, readonly) UIViewController *topViewController;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (NSArray *)popToViewController:(UIViewController *)newViewController animated:(BOOL)animated;
- (UIViewController *)popViewControllerAnimated:(BOOL)animated;
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated;

- (void)click;

@end


@interface UIViewController (FGYController)
- (FGYController *)fgy_controller;
@end
