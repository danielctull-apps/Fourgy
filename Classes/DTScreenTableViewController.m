//
//  DTScreenTableViewController.m
//  iPod
//
//  Created by Daniel Tull on 14.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTScreenTableViewController.h"
#import "DTiPodTableViewCell.h"

@implementation DTScreenTableViewController

/*
- (id)init {
    return [self initWithStyle:UITableViewStylePlain];
}*/

- (id)initWithArray:(NSArray *)array {
	
	if (!(self = [self init])) return nil;
	
	items = [array copy];
	collections = nil;
	property = nil;
	
    return self;
}

- (id)initWithQuery:(MPMediaQuery *)query property:(NSString *)aProperty {
	
    if (!(self = [self init])) return nil;
	
	collections = [[query collections] retain];
	items = nil;
	property = [aProperty copy];
	
    return self;
}


- (id)initWithStyle:(UITableViewStyle)style {
	
    if (!(self = [super initWithStyle:style])) return nil;
	
	//NSLog(@"%@:%s", self, _cmd);
	firstRun = YES;
	
    return self;
}

- (void)viewDidLoad {
	
	//NSLog(@"%@:%s", self, _cmd);
	/*
    self.tableView.rowHeight = 27.0;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.userInteractionEnabled = NO;
	self.tableView.backgroundColor = [UIColor colorWithRed:0.8 green:0.867 blue:0.937 alpha:1.0];
	self.tableView.frame = CGRectMake(0.0, 0.0, 240.0, 162.0);*/
	[super viewDidLoad];
	
	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

/*- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}*/

/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

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


#pragma mark Table view methods


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	//NSLog(@"%@:%s", self, _cmd);
	
	if (items)
		return [items count];
	
	return [collections count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	//NSLog(@"%@:%s", self, _cmd);
	
	DTiPodTableViewCell *cell = (DTiPodTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
	
	if (!cell)
		cell = [[[DTiPodTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
	
	if (items)
		cell.textLabel.text = [items objectAtIndex:indexPath.row];
	else
		cell.textLabel.text = [((MPMediaItemCollection *)[collections objectAtIndex:indexPath.row]).representativeItem valueForProperty:property];
		
	return cell;
}

- (void)tableView:(UITableView *)tv willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (firstRun && indexPath.row == 0 & indexPath.section == 0) {
		cell.selected = YES;
		[tv selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
		firstRun = NO;
	}
}

- (void)dealloc {
    [super dealloc];
}


- (NSInteger)numberOfRowsInGridView:(DTGridView *)gridView {
	
	if (items)
		return [items count];
	
	return [collections count];

}
- (NSInteger)numberOfColumnsInGridView:(DTGridView *)gridView forRowWithIndex:(NSInteger)index {
	return 1;
}
- (CGFloat)gridView:(DTGridView *)gridView heightForRow:(NSInteger)rowIndex {
	//NSLog(@"%@:%s", self, _cmd);
	return 27;
}
- (CGFloat)gridView:(DTGridView *)gridView widthForCellAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	gridView.frame.size.width;
}
- (DTGridViewCell *)gridView:(DTGridView *)gridView viewForRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	DTiPodTableViewCell *cell = (DTiPodTableViewCell *)[gridView dequeueReusableCellWithIdentifier:@"cell"];
	
	if (!cell) {
		cell = [[[DTiPodTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
		cell.textLabel.frame = CGRectMake(0.0, 0.0, gridView.frame.size.width, 27.0);
	}
	if (items)
		cell.textLabel.text = [items objectAtIndex:rowIndex];
	else
		cell.textLabel.text = [((MPMediaItemCollection *)[collections objectAtIndex:rowIndex]).representativeItem valueForProperty:property];
		
	return cell;
}



@end

