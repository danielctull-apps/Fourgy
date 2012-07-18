//
//  FGYController.m
//  Fourgy
//
//  Created by Daniel Tull on 25.12.2011.
//  Copyright (c) 2011 Daniel Tull Limited. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FGYController.h"
#import "FGYBatteryLevelView.h"
#import "FGYClickWheel.h"
#import "Fourgy.h"

@interface FGYController () <FGYClickWheelDelegate>
@end

@implementation FGYController {
	__strong FGYClickWheel *clickWheel;
	__strong UIView *screenView;
	__strong UILabel *titleLabel;
	__strong UIView *separatorView;
	__strong UIView *contentView;
	
	__strong NSMutableArray *stack;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
	if (!(self = [self init])) return nil;
	
	stack = [NSMutableArray new];
	[self pushViewController:rootViewController animated:NO];
	
	return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	
	[self view];
	
	UIViewController *oldViewController = self.topViewController;
	
	[stack addObject:viewController];
	[self addChildViewController:viewController];
	[contentView addSubview:viewController.view];
	
	CGRect frame = contentView.bounds;
	frame.origin.x = contentView.bounds.size.width;
	viewController.view.frame = frame;
	
	frame.origin.x = -contentView.bounds.size.width;
	
	NSTimeInterval duration = 0.0f;
	if (animated) duration = (1.0f/3.0f);
	
	[UIView animateWithDuration:duration animations:^{
		
		oldViewController.view.frame = frame;
		viewController.view.frame = contentView.bounds;
		
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
	
	CGRect frame = contentView.bounds;
	frame.origin.x = -contentView.bounds.size.width;
	newViewController.view.frame = frame;
	[contentView addSubview:newViewController.view];
	
	NSTimeInterval duration = 0.0f;
	if (animated) duration = (1.0f/3.0f);
	
	frame.origin.x = contentView.bounds.size.width;
	
	[UIView animateWithDuration:duration animations:^{
		
		oldViewController.view.frame = frame;
		newViewController.view.frame = contentView.bounds;
		
	} completion:^(BOOL finished) {
		
		[oldViewController.view removeFromSuperview];
		
		for (UIViewController *vc in viewControllersToPop)
			[vc removeFromParentViewController];
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

- (void)loadView {
	self.view = [[UIView alloc] init];
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleHeight);
	self.view.layer.cornerRadius = 15.0f;
	self.view.backgroundColor = [UIColor whiteColor];
	
	clickWheel = [[FGYClickWheel alloc] initWithFrame:CGRectMake(45.0f, 233.0f, 231.0f, 231.0f)];
	clickWheel.delegate = self;
	[self.view addSubview:clickWheel];
	
	UIView *windowView = [[UIView alloc] initWithFrame:CGRectMake(38.0f, 20.0f, 246.0f, 198.0f)];
	windowView.layer.cornerRadius = 5.0f;
	windowView.backgroundColor = [UIColor colorWithRed:0.412f green:0.443f blue:0.463f alpha:1.0f];
	[self.view addSubview:windowView];
	
	screenView = [[UIView alloc] initWithFrame:CGRectMake(3.0f, 3.0f, 240.0f, 192.0f)];
	screenView.backgroundColor = [UIColor colorWithRed:0.8 green:0.867 blue:0.937 alpha:1.0];
	[windowView addSubview:screenView];
	
	FGYBatteryLevelView *batteryView = [[FGYBatteryLevelView alloc] initWithFrame:CGRectMake(200.0f, 5.0f, 35.0f, 16.0f)];
	[screenView addSubview:batteryView];
	
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 1.0f, 160.0f, 26.0f)];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.backgroundColor = screenView.backgroundColor;
	[screenView addSubview:titleLabel];
	titleLabel.font = [Fourgy fontOfSize:12.0f];
	titleLabel.textColor = [UIColor colorWithRed:0.176f green:0.204f blue:0.42f alpha:1.0f];
	titleLabel.text = @"iPod";
	
	separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 27.0f, 240.0f, 2.0f)];
	separatorView.backgroundColor = titleLabel.textColor;
	[screenView addSubview:separatorView];
	
	contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 240.0f, 162.0f)];
	contentView.backgroundColor = screenView.backgroundColor;
	contentView.clipsToBounds = YES;
	[screenView addSubview:contentView];
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
}

@end
