//
//  FGYController.h
//  Fourgy
//
//  Created by Daniel Tull on 25.12.2011.
//  Copyright (c) 2011 Daniel Tull Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FGYControllerControl <NSObject>
- (BOOL)moveUpByAmount:(NSUInteger)amountToMoveUp;
- (BOOL)moveDownByAmount:(NSUInteger)amountToMoveUp;
@end

@interface FGYController : UIViewController

- (id)initWithRootViewController:(UIViewController<FGYControllerControl> *)rootViewController;

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, readonly) UIViewController<FGYControllerControl> *topViewController;

- (void)pushViewController:(UIViewController<FGYControllerControl> *)viewController animated:(BOOL)animated;
- (NSArray *)popToViewController:(UIViewController<FGYControllerControl> *)newViewController animated:(BOOL)animated;
- (UIViewController<FGYControllerControl> *)popViewControllerAnimated:(BOOL)animated;
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated;

@end
