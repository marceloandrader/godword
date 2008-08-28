//
//  DevotionalNavController.m
//  GodWord
//
//  Created by Marcelo Andrade on 8/26/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "DevotionalNavController.h"
#import "DevotionalListController.h"

@implementation DevotionalNavController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically*/
- (void)loadView {
	
 devotionalListController = [[DevotionalListController alloc] initWithNibName:nil bundle:nil];
 
 UINavigationController *navControler = [[UINavigationController alloc] initWithRootViewController:devotionalListController];
 devotionalListController.navigationItem.title = @"Devotionals";
 
 UIBarButtonItem *deleteButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:devotionalListController action:@selector(edit)];
 
 devotionalListController.navigationItem.rightBarButtonItem = deleteButtonItem;
 
 [deleteButtonItem release];
 
 
 self.view = navControler.view;
 
 }
 
 - (void) viewWillAppear:(BOOL) animated{
	 [devotionalListController.table reloadData];
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
	[devotionalListController release];
	[super dealloc];
}


@end
