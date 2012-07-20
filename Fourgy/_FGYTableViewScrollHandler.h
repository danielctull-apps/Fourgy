//
//  UITableViewController+_FGYClickWheelDelegate.h
//  Fourgy
//
//  Created by Daniel Tull on 18.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _FGYTableViewScrollHandler : NSObject
- (id)initWithTableView:(UITableView *)tableView;
- (BOOL)clickWheelTouchesMovedToAngle:(CGFloat)angle distance:(CGFloat)distance;
@end
