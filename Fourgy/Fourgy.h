//
//  Fourgy.h
//  Fourgy
//
//  Created by Daniel Tull on 18.07.2012.
//  Copyright (c) 2012 Daniel Tull Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGYController.h"
#import "FGYClickWheel.h"

@interface Fourgy : NSObject
+ (UIFont *)fontOfSize:(CGFloat)size;
+ (CGFloat)rowHeight;
+ (UIColor *)foregroundColor;
+ (UIColor *)backgroundColor;
@end
