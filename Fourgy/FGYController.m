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
#import "FGYClickWheel.h"
#import "_Fourgy.h"

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

- (id)initWithRootViewController:(UIViewController<FGYControllerControl> *)rootViewController {
	
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

- (void)pushViewController:(UIViewController<FGYControllerControl> *)viewController animated:(BOOL)animated {
	
	UIViewController *oldViewController = self.topViewController;
	[stack addObject:viewController];
	
	if (![self isViewLoaded]) return;
	
	[self addChildViewController:viewController];
	[self.contentView addSubview:viewController.view];
	
	CGRect frame = self.contentView.bounds;
	frame.origin.x = self.contentView.bounds.size.width;
	viewController.view.frame = frame;
	
	frame.origin.x = -self.contentView.bounds.size.width;
	
	NSTimeInterval duration = 0.0f;
	if (animated) duration = (1.0f/3.0f);
	
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
	[self.contentView addSubview:newViewController.view];
	
	NSTimeInterval duration = 0.0f;
	if (animated) duration = (1.0f/3.0f);
	
	frame.origin.x = self.contentView.bounds.size.width;
	
	[UIView animateWithDuration:duration animations:^{
		
		oldViewController.view.frame = frame;
		newViewController.view.frame = self.contentView.bounds;
		
	} completion:^(BOOL finished) {
		
		[oldViewController.view removeFromSuperview];
		
		for (UIViewController *vc in viewControllersToPop)
			[vc removeFromParentViewController];
	}];
	
	return viewControllersToPop;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
	
	if ([stack count] < 2) return nil;
	
	UIViewController<FGYControllerControl> *viewControllerToPopTo = [stack objectAtIndex:([stack count]-2)];
	
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
	
	self.screenView.backgroundColor = [UIColor colorWithRed:0.8 green:0.867 blue:0.937 alpha:1.0];
	self.titleLabel.backgroundColor = self.screenView.backgroundColor;
	self.titleLabel.font = [Fourgy fontOfSize:12.0f];
	self.titleLabel.textColor = [UIColor colorWithRed:0.176f green:0.204f blue:0.42f alpha:1.0f];
	self.titleLabel.text = @"iPod";
	
	self.separatorView.backgroundColor = self.titleLabel.textColor;
	
	self.contentView.backgroundColor = self.screenView.backgroundColor;
	
	if (self.topViewController) {
		self.topViewController.view.frame = self.contentView.bounds;
		[self.contentView addSubview:self.topViewController.view];
	}
}

#pragma mark - FGYClickWheelDelegate

- (void)clickWheelMenuButtonTapped:(FGYClickWheel *)cw {
	[self popViewControllerAnimated:YES];
	
	if ([self.topViewController conformsToProtocol:@protocol(FGYClickWheelDelegate)]
		&& [self.topViewController respondsToSelector:_cmd]) {
		
		id<FGYClickWheelDelegate> delegate = (id<FGYClickWheelDelegate>)self.topViewController;
		[delegate clickWheelMenuButtonTapped:cw];
	}
}

- (void)clickWheelCenterButtonTapped:(FGYClickWheel *)cw {
	
	if ([self.topViewController.view isKindOfClass:[UITableView class]] 
		&& [self.topViewController conformsToProtocol:@protocol(UITableViewDelegate)]
		&& [self.topViewController respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
	
		UITableView *tv = (UITableView *)self.topViewController.view;
		id<UITableViewDelegate> delegate = (id<UITableViewDelegate>)self.topViewController;
		[delegate tableView:tv didSelectRowAtIndexPath:[tv indexPathForSelectedRow]];
	}
	
	if ([self.topViewController conformsToProtocol:@protocol(FGYClickWheelDelegate)]
		&& [self.topViewController respondsToSelector:_cmd]) {
		
		id<FGYClickWheelDelegate> delegate = (id<FGYClickWheelDelegate>)self.topViewController;
		[delegate clickWheelCenterButtonTapped:cw];
	}
}

- (void)clickWheelNextButtonTapped:(FGYClickWheel *)cw {
	if ([self.topViewController conformsToProtocol:@protocol(FGYClickWheelDelegate)]
		&& [self.topViewController respondsToSelector:_cmd]) {
		
		id<FGYClickWheelDelegate> delegate = (id<FGYClickWheelDelegate>)self.topViewController;
		[delegate clickWheelNextButtonTapped:cw];
	}
}

- (void)clickWheelPlayButtonTapped:(FGYClickWheel *)cw {
	if ([self.topViewController conformsToProtocol:@protocol(FGYClickWheelDelegate)]
		&& [self.topViewController respondsToSelector:_cmd]) {
		
		id<FGYClickWheelDelegate> delegate = (id<FGYClickWheelDelegate>)self.topViewController;
		[delegate clickWheelPlayButtonTapped:cw];
	}
}

- (void)clickWheelPreviousButtonTapped:(FGYClickWheel *)cw {
	if ([self.topViewController conformsToProtocol:@protocol(FGYClickWheelDelegate)]
		&& [self.topViewController respondsToSelector:_cmd]) {
		
		id<FGYClickWheelDelegate> delegate = (id<FGYClickWheelDelegate>)self.topViewController;
		[delegate clickWheelPreviousButtonTapped:cw];
	}
}

- (void)clickWheel:(FGYClickWheel *)cw touchesMovedToAngle:(CGFloat)angle distance:(CGFloat)distance {
	if ([self.topViewController conformsToProtocol:@protocol(FGYClickWheelDelegate)]
		&& [self.topViewController respondsToSelector:_cmd]) {
		
		id<FGYClickWheelDelegate> delegate = (id<FGYClickWheelDelegate>)self.topViewController;
		[delegate clickWheel:cw touchesMovedToAngle:angle distance:distance];
	}
	
	AudioServicesPlaySystemSound(_clickSound);
}

@end
