//
//  AddFolderController.m
//  GodWord
//
//  Created by Marcelo Andrade on 8/19/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "AddFolderController.h"
#import "GodWordAppDelegate.h"
#import "BibleDatabase.h"
#import "BookmarkFolder.h"

@implementation AddFolderController

@synthesize description, folder;

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
	[super dealloc];
}

- (IBAction) addFolder: (id) sender
{
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate*)[[UIApplication sharedApplication] delegate];
	folder.title = description.text;
	if (folder.pk == 0)
	{
		[appDelegate.bible insertFolder:folder];
		[appDelegate.bible.bookmarkFolders addObject:folder];
	} else
	{
		[appDelegate.bible updateFolder:folder];
	}
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL) animated {

	[description setText:folder.title];
	[description becomeFirstResponder];
}

@end
