//
//  iPodAppDelegate.h
//  iPod
//
//  Created by Daniel Tull on 13.07.2009.
//  Copyright Daniel Tull 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPodAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

