//
//  BookmarksOfFolderController.m
//  GodWord
//
//  Created by Marcelo Andrade on 9/8/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "BookmarksOfFolderController.h"
#import "GodWordAppDelegate.h"
#import "BookmarkFolder.h"
#import "Bookmark.h"
#import "BookmarkCell.h"
#import "BibleDatabase.h"
#import "AddBookmarkItemController.h"
#import "Verse.h"

@implementation BookmarksOfFolderController

@synthesize folder,table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically */
- (void)loadView {
	table = [[UITableView alloc] initWithFrame:
			 [[UIScreen mainScreen] applicationFrame] 
										 style:UITableViewStylePlain];
	
	table.autoresizingMask = 
	UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth; 
	table.delegate = self; 
	table.dataSource = self; 
	
	self.view = table;
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
	[super dealloc];
}


#pragma mark UITableViewDelegate

- (UITableViewCell *) tableView:(UITableView *) tableView 
		  cellForRowAtIndexPath:(NSIndexPath *) indexPath 
{
	BookmarkCell *cell = (BookmarkCell*) [tableView dequeueReusableCellWithIdentifier:@"BookmarkItemCellList"];
	if (cell == nil) {
		cell = [[BookmarkCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"BookmarkItemCellList"];
	}
	
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	BookmarkFolder *bookmarkFolder = (BookmarkFolder *)[appDelegate.bible.bookmarkFolders objectAtIndex:self.folder];	
	Bookmark *bookmark = (Bookmark*)[bookmarkFolder.bookmarks objectAtIndex:[indexPath row]];
	cell.descriptionLabel.text = bookmark.description;
	cell.verse.text = bookmark.verseNo;
	
	return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
	return 1;
}

- (NSInteger) tableView:(UITableView *) tableView 
  numberOfRowsInSection:(NSInteger) section 
{
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	BookmarkFolder *bookmarkFolder = (BookmarkFolder *)[appDelegate.bible.bookmarkFolders objectAtIndex:self.folder];	
	
	return [bookmarkFolder.bookmarks count];
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	BookmarkFolder *bookmarkFolder = (BookmarkFolder *)[appDelegate.bible.bookmarkFolders objectAtIndex:self.folder];
	Bookmark *bookmark = (Bookmark*)[bookmarkFolder.bookmarks objectAtIndex:[indexPath row]];
	
	[appDelegate.bible refreshVerseFromVerseId:bookmark.verse verse:appDelegate.verseSelected];
	
	appDelegate.tabBarController.selectedIndex = 1;
	

}

- (void) edit {
	UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] 
								 initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
								 target:self 
								 action:@selector(finishEdit)];
	self.navigationItem.rightBarButtonItem = doneItem;
	[doneItem release];
	
	[table setEditing:YES animated:YES];
}

- (void) finishEdit {
	UIBarButtonItem *deleteButtonItem = [[UIBarButtonItem alloc] 
										 initWithBarButtonSystemItem:UIBarButtonSystemItemTrash 
										 target:self
										 action:@selector(edit)];
	self.navigationItem.rightBarButtonItem = deleteButtonItem;
	[deleteButtonItem release];
	[table setEditing:NO animated:YES];
}


- (void)tableView:(UITableView *)aTableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
		GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
		BookmarkFolder *bookmarkFolder = (BookmarkFolder *)[appDelegate.bible.bookmarkFolders objectAtIndex:self.folder];	
		Bookmark *bookmark = (Bookmark*)[bookmarkFolder.bookmarks objectAtIndex:[indexPath row]];
		
		[appDelegate.bible deleteBookmark:bookmark];
		[bookmarkFolder.bookmarks removeObjectAtIndex:indexPath.row];
		
        [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
						  withRowAnimation:UITableViewRowAnimationFade];
		
	}
}


@end
