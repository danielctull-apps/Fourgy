//
//  _FGYClickWheel.h
//  Fourgy
//
//  Created by Daniel Tull on 18.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FGYClickWheel.h"

@interface FGYClickWheel : UIView
@property (nonatomic, weak) IBOutlet id<FGYClickWheelDelegate> delegate;
@end
