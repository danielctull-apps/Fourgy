//
//  ImportingViewController.m
//  Fourgy
//
//  Created by Daniel Tull on 19.07.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "ImportingViewController.h"
#import <Fourgy/Fourgy.h>

@interface ImportingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet FGYProgressView *progressView;
@end

@implementation ImportingViewController
@synthesize textLabel;
@synthesize progressView;

- (id)initWithMusicModel:(DCTMusicModel *)musicModel {
	self = [self init];
	if (!self) return nil;
	_musicModel = musicModel;
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.textLabel.font = [Fourgy fontOfSize:12.0f];
	
	__weak ImportingViewController *weakSelf = self;
	_musicModel.importHandler= ^(CGFloat percentComplete, BOOL finished) {
		weakSelf.progressView.progress = percentComplete;
		
		if (finished) [weakSelf.fgy_controller popViewControllerAnimated:NO];
	};
}

@end
