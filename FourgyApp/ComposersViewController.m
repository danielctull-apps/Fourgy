//
//  ComposersViewController.m
//  Fourgy
//
//  Created by Daniel Tull on 20.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "ComposersViewController.h"

@implementation ComposersViewController

- (NSString *)titleForItem:(DCTComposer *)composer {
	return composer.name;
}

@end
