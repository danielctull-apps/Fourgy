//
//  FGYAppDelegate.h
//  Fourgy
//
//  Created by Daniel Tull on 25.12.2011.
//  Copyright (c) 2011 Daniel Tull Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FGYViewController;

@interface FGYAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FGYViewController *viewController;

@end
