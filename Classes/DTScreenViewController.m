//
//  DTScreenViewController.m
//  iPod
//
//  Created by Daniel Tull on 16.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTScreenViewController.h"
#import "DTiPodBlockViewCell.h"

@implementation DTScreenViewController

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)init {
    return [self initWithNibName:nil bundle:nil];
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
/*- (void)loadView {
	self.view = [[DTBlockView alloc] initWithFrame:CGRectZero];
	((DTBlockView *)self.view).dataSource = self;
	itemsView = self.view;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	itemsView.backgroundColor = [UIColor colorWithRed:0.8 green:0.867 blue:0.937 alpha:1.0];
	
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

- (NSInteger)numberOfRowsForBlockView:(DTBlockView *)blockView {
	return 50;
}

- (NSInteger)numberOfRowsToDisplayInBlockView:(DTBlockView *)blockView {
	return 6;
}

- (UIView<DTBlockViewCellProtocol> *)blockView:(DTBlockView *)blockView blockViewCellForRow:(NSInteger)rowIndex {
	
	DTiPodBlockViewCell *cell = (DTiPodBlockViewCell *)[blockView dequeueReusableCell];
	
	if (!cell) {
		cell = [[DTiPodBlockViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, blockView.frame.size.width, 27.0)];
	}
	/*
	if (rowIndex == 0)
		cell.backgroundColor = [UIColor redColor];
	else if (rowIndex == 1)
		cell.backgroundColor = [UIColor blueColor];
	else if (rowIndex == 2)
		cell.backgroundColor = [UIColor yellowColor];
	else if (rowIndex == 3)
		cell.backgroundColor = [UIColor blackColor];
	else if (rowIndex == 4)
		cell.backgroundColor = [UIColor grayColor];
	else if (rowIndex == 5)
		cell.backgroundColor = [UIColor lightGrayColor];
	*/
	
	if (rowIndex == 0)
		cell.titleLabel.text = @"Music";
	else if (rowIndex == 1)
		cell.titleLabel.text = @"Extras";
	else if (rowIndex == 2)
		cell.titleLabel.text = @"Settings";
	else if (rowIndex == 3)
		cell.titleLabel.text = @"Shuffle Songs";
	else if (rowIndex == 4)
		cell.titleLabel.text = @"Backlight";
	
	return cell;
}

- (void)moveDown {
	NSLog(@"%@:%s", self, _cmd);
	[itemsView moveToRow:6];
}

@end
