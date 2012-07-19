//
//  DTTickingLabel.h
//  DTKit
//
//  Created by Daniel Tull on 09/12/2008.
//  Copyright 2008 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FGYTickingLabel : UILabel {
	/*
	NSString *text;
	UILabel *label;
	*/
	
	// PUBLIC:
	
	BOOL isAnimating;
	CGFloat speed;
	CGFloat separatingDistance;
	CGFloat delay;
	// PRIVATE:
	
	UILabel *label1;
	UILabel *label2;
	
	CGFloat duration;
	CGRect frame1;
	CGRect frame2;
	CGRect frame3;
	BOOL shouldDealloc;
	
}

@property (readonly) BOOL isAnimating;
@property CGFloat speed, delay;
@property CGFloat separatingDistance;

/*
@property (copy) NSString *text;
@property (retain) UILabel *label;

- (id)initWithFrame:(CGRect)frame text:(NSString *)text;
*/

- (UILabel *)pureLabel:(UILabel *)aLabel;
- (void)animate;

@end
