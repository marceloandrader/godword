//
//  AddBookmarkController.m
//  GodWord
//
//  Created by Marcelo Andrade on 8/5/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "AddBookmarkController.h"


@implementation AddBookmarkController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */

/*
 If you need to do additional setup after loading the view, override viewDidLoad.*/
- (void)viewDidLoad {
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss:)];
	self.navigationController.navigationItem.rightBarButtonItem = item;
	[item release];
}
 


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}

#pragma mark UITableViewDelegate

- (UITableViewCell *) tableView:(UITableView *) tableView 
		  cellForRowAtIndexPath:(NSIndexPath *) indexPath 
{
	UITableViewCell *cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"BookmarkCell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"BookmarkCell"];
	}
	cell.text = @"Bookmark Folder";
	return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
	return 1;
}

- (NSInteger) tableView:(UITableView *) tableView 
  numberOfRowsInSection:(NSInteger) section 
{
	return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void) dismiss:sender{
	[self dismissModalViewControllerAnimated:TRUE];
}


@end
