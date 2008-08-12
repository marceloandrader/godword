//
//  AddBookmarkItemController.m
//  GodWord
//
//  Created by Marcelo Andrade on 8/9/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "AddBookmarkItemController.h"
#import "GodWordAppDelegate.h"
#import "Bookmark.h"
#import "Verse.h"
#import "BibleDatabase.h"

@implementation AddBookmarkItemController

@synthesize folder;

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
 If you need to do additional setup after loading the view, override viewDidLoad. */
- (void)viewDidLoad {
	[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	GodWordAppDelegate *delegate = (GodWordAppDelegate*)[[UIApplication sharedApplication] delegate];
	verse.text = delegate.verseSelected.text;
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


- (IBAction) addBookmark: (id) sender
{
	GodWordAppDelegate *delegate = (GodWordAppDelegate*)[[UIApplication sharedApplication] delegate];
	Bookmark * bookmark = [[Bookmark alloc] initWithPrimaryKey:0 description:[description text] verse:delegate.verseSelected.verseId folder:self.folder ];
	[delegate.bible saveBookmark:bookmark];
	[[self navigationController] popViewControllerAnimated:YES];
}


- (IBAction) finishEditing: (id) sender
{
	[description resignFirstResponder];
	if ([[description text] length] > 0) {
		[save setEnabled:TRUE];
	} else {
		[save setEnabled:FALSE];
	}

}

@end
