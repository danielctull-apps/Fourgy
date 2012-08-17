//
//  FGYController.m
//  Fourgy
//
//  Created by Daniel Tull on 25.12.2011.
//  Copyright (c) 2011 Daniel Tull Limited. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "FGYController.h"
#import "FGYBatteryLevelView.h"
#import "_FGYClickWheel.h"
#import "Fourgy.h"

@interface FGYController () <FGYClickWheelDelegate>
@property (weak) IBOutlet FGYClickWheel *clickWheel;
@property (weak) IBOutlet UIView *windowView;
@property (weak) IBOutlet UIView *screenView;
@property (weak) IBOutlet UILabel *titleLabel;
@property (weak) IBOutlet UIView *separatorView;
@property (weak) IBOutlet UIView *contentView;
@end

@implementation FGYController {
	__strong NSMutableArray *stack;
	SystemSoundID _clickSound;
}

- (void)dealloc {
	AudioServicesDisposeSystemSoundID(_clickSound);
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
	
	NSBundle *bundle = [Fourgy bundle];
	
	self = [self initWithNibName:@"FGYController" bundle:bundle];
	if (!self) return nil;
	
	stack = [NSMutableArray new];
	[self pushViewController:rootViewController animated:NO];
	
	// Create a system sound object representing the sound file
	NSURL *clickSoundURL = [bundle URLForResource:@"click" withExtension:@"wav"];
	AudioServicesCreateSystemSoundID ((__bridge CFURLRef)clickSoundURL, &_clickSound);
	
	return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	
	UIViewController *oldViewController = self.topViewController;
	[stack addObject:viewController];
	
	if (![self isViewLoaded]) return;
	
	CGRect frame = self.contentView.bounds;
	frame.origin.x = self.contentView.bounds.size.width;
	viewController.view.frame = frame;
	
	[self addChildViewController:viewController];
	[self.contentView addSubview:viewController.view];
	[oldViewController willMoveToParentViewController:nil];
	
	[self _setupViewController:viewController];
	
	NSTimeInterval duration = 0.0f;
	if (animated) duration = (1.0f/3.0f);
	
	frame.origin.x = -self.contentView.bounds.size.width;
	
	[UIView animateWithDuration:duration animations:^{
		
		oldViewController.view.frame = frame;
		viewController.view.frame = self.contentView.bounds;
		
	} completion:^(BOOL finished) {
		
		[oldViewController.view removeFromSuperview];
		[oldViewController removeFromParentViewController];
	}];
}

- (NSArray *)popToViewController:(UIViewController *)newViewController animated:(BOOL)animated {
	
	NSUInteger startIndexToPop = 1+[stack indexOfObject:newViewController];
	NSRange range = NSMakeRange(startIndexToPop, [stack count]-startIndexToPop);
	
	UIViewController *oldViewController = self.topViewController;
	NSArray *viewControllersToPop = [stack subarrayWithRange:range];
	[stack removeObjectsInRange:range];
	
	CGRect frame = self.contentView.bounds;
	frame.origin.x = -self.contentView.bounds.size.width;
	newViewController.view.frame = frame;
	
	[self addChildViewController:newViewController];
	[self.contentView addSubview:newViewController.view];
	[oldViewController willMoveToParentViewController:nil];
	
	[self _setupViewController:newViewController];
	
	NSTimeInterval duration = 0.0f;
	if (animated) duration = (1.0f/3.0f);
	
	frame.origin.x = self.contentView.bounds.size.width;
	
	[UIView animateWithDuration:duration animations:^{
		
		oldViewController.view.frame = frame;
		newViewController.view.frame = self.contentView.bounds;
		
	} completion:^(BOOL finished) {
		
		[oldViewController.view removeFromSuperview];
		[oldViewController removeFromParentViewController];
	}];
	
	return viewControllersToPop;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
	
	if ([stack count] < 2) return nil;
	
	UIViewController *viewControllerToPopTo = [stack objectAtIndex:([stack count]-2)];
	
	return [[self popToViewController:viewControllerToPopTo animated:animated] lastObject];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
	
	if ([stack count] == 0) 
		return nil;
	
	return [self popToViewController:[stack objectAtIndex:0] animated:animated];
}

- (UIViewController *)topViewController {
	return [stack lastObject];
}

- (void)setViewControllers:(NSArray *)viewControllers {
	
}

- (NSArray *)viewControllers {
	return [stack copy];
}

- (void)viewDidLoad {
	
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleHeight);
	self.view.layer.cornerRadius = 15.0f;
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.windowView.layer.cornerRadius = 5.0f;
	self.windowView.backgroundColor = [UIColor colorWithRed:0.412f green:0.443f blue:0.463f alpha:1.0f];
	
	self.screenView.backgroundColor = [Fourgy backgroundColor];
	self.titleLabel.backgroundColor = [Fourgy backgroundColor];
	self.titleLabel.font = [Fourgy fontOfSize:12.0f];
	self.titleLabel.textColor = [Fourgy foregroundColor];
	self.titleLabel.text = @"iPod";
	
	self.separatorView.backgroundColor = [Fourgy foregroundColor];
	self.contentView.backgroundColor = [Fourgy backgroundColor];
	
	if (self.topViewController) {
		self.topViewController.view.frame = self.contentView.bounds;
		[self addChildViewController:self.topViewController];
		[self.contentView addSubview:self.topViewController.view];
		[self _setupViewController:self.topViewController];
	}
}

- (void)click {
	AudioServicesPlaySystemSound(_clickSound);
}

- (void)_setupViewController:(UIViewController *)viewController {
	self.titleLabel.text = viewController.title;
	viewController.view.backgroundColor = self.contentView.backgroundColor;
	if ([viewController conformsToProtocol:@protocol(FGYClickWheelDelegate)]) {
		self.clickWheel.delegate = (id<FGYClickWheelDelegate>)viewController;
	}
}

@end


@implementation UIViewController (FGYController)

- (FGYController *)fgy_controller {
	
	if ([self isKindOfClass:[FGYController class]])
		return (FGYController *)self;
	
	return [self.parentViewController fgy_controller];
}

@end

