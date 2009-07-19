//
//  DTiPodViewController.m
//  iPod
//
//  Created by Daniel Tull on 13.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTiPodViewController.h"
#import "DTiPodTableViewCell.h"
#import "DTScreenViewController.h"
#import "DTiPodNavigationBar.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation DTiPodViewController

@synthesize screenTable, screenView;

- (id)init {
	return [self initWithNibName:@"DTiPodView" bundle:nil];
}


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		oldAngle = 500.0;
		difference = 0.0;
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];	
	
	//DTScreenTableViewController *table = [[DTScreenTableViewController alloc] initWithArray:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MainMenu" ofType:@"plist"]]];
	
	DTScreenViewController *vc = [[DTScreenViewController alloc] init];
	
	nav = [[UINavigationController alloc] initWithRootViewController:vc];
	
	[vc release];
	
	nav.view.frame = CGRectMake(0.0, 30.0 - nav.navigationBar.frame.size.height, 240.0, 162.0 + nav.navigationBar.frame.size.height);
	
	DTiPodNavigationBar *navbar = [[DTiPodNavigationBar alloc] init];
	
	//nav.navigationBar = navbar;
	
	[navbar release];
	
	[self.screenView insertSubview:nav.view atIndex:0];
	
	//[screenTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSLog(@"%@:%s", self, _cmd);
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSLog(@"%@:%s", self, _cmd);
	
	DTiPodTableViewCell *cell = (DTiPodTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
	
	if (!cell)
		cell = [[[DTiPodTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
	
	if (indexPath.row == 0)
		cell.textLabel.text = @"Music";
	else if (indexPath.row == 1)
		cell.textLabel.text = @"Extras";
	else if (indexPath.row == 2)
		cell.textLabel.text = @"Settings";
	else if (indexPath.row == 3)
		cell.textLabel.text = @"Shuffle Songs";
	else if (indexPath.row == 4)
		cell.textLabel.text = @"Backlight";
		
	return cell;
	
}

#pragma mark DTClickWheelViewDelegate Methods

- (void)menuButtonTappedOnClickWheel:(DTClickWheelView *)clickWheel {
	[nav popViewControllerAnimated:YES];
}

- (void)centerButtonTappedOnClickWheel:(DTClickWheelView *)clickWheel {
	
	oldAngle = 500.0;
	
	DTScreenViewController *tableController = (DTScreenViewController *)nav.visibleViewController;
	/*
	UITableViewCell *cell = [tableController.tableView cellForRowAtIndexPath:[tableController.tableView indexPathForSelectedRow]];
	
	if ([cell.textLabel.text isEqualToString:@"Music"]) {
		DTScreenTableViewController *table = [[DTScreenTableViewController alloc] initWithArray:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MusicMenu" ofType:@"plist"]]];
		[nav pushViewController:table animated:YES];
		[table release];
	} else if ([cell.textLabel.text isEqualToString:@"Artists"]) {
		MPMediaQuery *query = [MPMediaQuery artistsQuery];
		[query setGroupingType:MPMediaGroupingArtist];
		NSLog(@"%@:%s", self, _cmd);
		DTScreenTableViewController *table = [[DTScreenTableViewController alloc] initWithQuery:query property:MPMediaItemPropertyArtist];
		NSLog(@"%@:%s", self, _cmd);
		[nav pushViewController:table animated:YES];
		[table release];
	} else if ([cell.textLabel.text isEqualToString:@"Albums"]) {
		MPMediaQuery *query = [MPMediaQuery albumsQuery];
		[query setGroupingType:MPMediaGroupingAlbum];
		DTScreenTableViewController *table = [[DTScreenTableViewController alloc] initWithQuery:query property:MPMediaItemPropertyAlbumTitle];
		[nav pushViewController:table animated:YES];
		[table release];
	} else if ([cell.textLabel.text isEqualToString:@"Genres"]) {
		MPMediaQuery *query = [MPMediaQuery genresQuery];
		[query setGroupingType:MPMediaGroupingGenre];
		DTScreenTableViewController *table = [[DTScreenTableViewController alloc] initWithQuery:query property:MPMediaItemPropertyGenre];
		[nav pushViewController:table animated:YES];
		[table release];
	} else if ([cell.textLabel.text isEqualToString:@"Songs"]) {
		MPMediaQuery *query = [MPMediaQuery songsQuery];
		DTScreenTableViewController *table = [[DTScreenTableViewController alloc] initWithQuery:query property:MPMediaItemPropertyTitle];
		[nav pushViewController:table animated:YES];
		[table release];
	} else if ([cell.textLabel.text isEqualToString:@"Podcasts"]) {
		MPMediaQuery *query = [MPMediaQuery podcastsQuery];
		DTScreenTableViewController *table = [[DTScreenTableViewController alloc] initWithQuery:query property:MPMediaItemPropertyPodcastTitle];
		[nav pushViewController:table animated:YES];
		[table release];
	} else if ([cell.textLabel.text isEqualToString:@"Audiobooks"]) {
		MPMediaQuery *query = [MPMediaQuery audiobooksQuery];
		DTScreenTableViewController *table = [[DTScreenTableViewController alloc] initWithQuery:query property:MPMediaItemPropertyTitle];
		[nav pushViewController:table animated:YES];
		[table release];
	} else if ([cell.textLabel.text isEqualToString:@"Composers"]) {
		MPMediaQuery *query = [MPMediaQuery composersQuery];
		DTScreenTableViewController *table = [[DTScreenTableViewController alloc] initWithQuery:query property:MPMediaItemPropertyComposer];
		[nav pushViewController:table animated:YES];
		[table release];
	}
	*/
}

- (void)clickWheel:(DTClickWheelView *)clickWheel touchesMovedToAngle:(CGFloat)angle distance:(CGFloat)distance {
	
	if (oldAngle == 500.0) {
		//DTScreenTableViewController *tableController = (DTScreenTableViewController *)nav.visibleViewController;
		//[tableController.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
		oldAngle = angle;
		return;
	}
	
	CGFloat diff = angle - oldAngle;
	
	oldAngle = angle;
	
	if (diff < -180)
		diff += 360;
	else if (diff > 180)
		diff -= 360;
	
	if (difference < 0 && diff > 0 || difference > 0 && diff < 0)
		difference = 0.0;
	
	
	difference += diff;
	/*
	if (difference > 30) {
		difference = 0.0;
		DTScreenTableViewController *tableController = (DTScreenTableViewController *)nav.visibleViewController;
		NSIndexPath *ip = [tableController.tableView indexPathForSelectedRow];
		
		if (ip.row+1 < [tableController.tableView numberOfRowsInSection:ip.section]) {
			if ([[tableController.tableView visibleCells] containsObject:[tableController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:ip.row+1 inSection:ip.section]]])
				[tableController.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:ip.row+1 inSection:ip.section] animated:NO scrollPosition:UITableViewScrollPositionNone];
			else
				[tableController.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:ip.row+1 inSection:ip.section] animated:NO scrollPosition:UITableViewScrollPositionBottom];
		}
	} else if (difference < -30) {
		DTScreenTableViewController *tableController = (DTScreenTableViewController *)nav.visibleViewController;
		NSIndexPath *ip = [tableController.tableView indexPathForSelectedRow];
		if (ip.row > 0) {
			if ([[tableController.tableView visibleCells] containsObject:[tableController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:ip.row-1 inSection:ip.section]]])
				[tableController.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:ip.row-1 inSection:ip.section] animated:NO scrollPosition:UITableViewScrollPositionNone];
			else
				[tableController.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:ip.row-1 inSection:ip.section] animated:NO scrollPosition:UITableViewScrollPositionTop];
		
		}
		difference = 0.0;
		
	}*/
		
}

@end
