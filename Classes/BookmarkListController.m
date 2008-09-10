//
//  BookmarkList.m
//  GodWord
//
//  Created by Marcelo Andrade on 8/14/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "BookmarkListController.h"
#import "BookmarkGroupListController.h"
#import "GodWordAppDelegate.h"
#import "BibleDatabase.h"

@implementation BookmarkListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	};
	return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically  */
- (void)loadView {
	
	bookmarkGroupListController = [[BookmarkGroupListController alloc] initWithNibName:nil bundle:nil];
	
	UINavigationController *navControler = [[UINavigationController alloc] initWithRootViewController:bookmarkGroupListController];
	bookmarkGroupListController.navigationItem.title = NSLocalizedString(@"Folders",@"Folders");
	
	//UIBarButtonItem *deleteButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:bookmarkGroupListController action:@selector(edit)];
	
	//bookmarkGroupListController.navigationItem.rightBarButtonItem = deleteButtonItem;
	
	//[deleteButtonItem release];
	
	
	self.view = navControler.view;
	
}

- (void) viewWillAppear:(BOOL) animated{
	[bookmarkGroupListController.table reloadData];
}


/*
 If you need to do additional setup after loading the view, override viewDidLoad.
 - (void)viewDidLoad {
 }
 */


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[bookmarkGroupListController release];
	[super dealloc];
}

@end
