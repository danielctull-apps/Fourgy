//
//  ImportingViewController.h
//  Fourgy
//
//  Created by Daniel Tull on 19.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DCTMusicModel/DCTMusicModel.h>

@interface ImportingViewController : UIViewController
- (id)initWithMusicModel:(DCTMusicModel *)musicModel;
@property (nonatomic, readonly) DCTMusicModel *musicModel;
@end
