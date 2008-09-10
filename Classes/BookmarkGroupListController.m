//
//  BookmarkGroupListController.m
//  GodWord
//
//  Created by Marcelo Andrade on 8/17/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "BookmarkGroupListController.h"
#import "ReadChapterController.h"
#import "GodWordAppDelegate.h"
#import "BookmarkFolder.h"
#import "Bookmark.h"
#import "BookmarkCell.h"
#import "BibleDatabase.h"
#import "AddBookmarkItemController.h"
#import "Verse.h"
#import "BookmarksOfFolderController.h"

@implementation BookmarkGroupListController

@synthesize table;

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

- (void) viewWillAppear:(BOOL)animated {
	[self.table reloadData];
}

/*
 If you need to do additional setup after loading the view, override viewDidLoad. 
 - (void)viewDidLoad {
	 self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
	[table release];
	[super dealloc];
}


#pragma mark UITableViewDelegate

- (UITableViewCell *) tableView:(UITableView *) tableView 
		  cellForRowAtIndexPath:(NSIndexPath *) indexPath 
{
	//BookmarkCell *cell = (BookmarkCell*) [tableView dequeueReusableCellWithIdentifier:@"BookmarkCellList"];
//	if (cell == nil) {
//		cell = [[BookmarkCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"BookmarkCellList"];
//	}
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookmarkCellList"];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"BookmarkCellList"];
		cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
	}
	
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	BookmarkFolder *bookmarkFolder = (BookmarkFolder *)[appDelegate.bible.bookmarkFolders objectAtIndex:[indexPath row]];	
//	Bookmark *bookmark = (Bookmark*)[bookmarkFolder.bookmarks objectAtIndex:[indexPath row]];
//	cell.descriptionLabel.text = bookmark.description;
//	cell.verse.text = bookmark.verseNo;
	cell.text = [NSString stringWithFormat:@"%@ (%d)", bookmarkFolder.title, bookmarkFolder.bookmarks.count];
	return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
	//GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	//return [appDelegate.bible.bookmarkFolders count];
	return 1;
}

- (NSInteger) tableView:(UITableView *) tableView 
  numberOfRowsInSection:(NSInteger) section 
{
	
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	//BookmarkFolder *bookmarkFolder = (BookmarkFolder *)[appDelegate.bible.bookmarkFolders objectAtIndex:section];	
	return [appDelegate.bible.bookmarkFolders count];
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	BookmarksOfFolderController *bookmarksOfFolder = [[BookmarksOfFolderController alloc] init];
	
	bookmarksOfFolder.folder = indexPath.row;
	
	[self.navigationController pushViewController:bookmarksOfFolder animated:YES];
	
	UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:bookmarksOfFolder action:@selector(edit)];
	
	bookmarksOfFolder.navigationItem.rightBarButtonItem = editButtonItem;
	
	[editButtonItem release];
	
	[bookmarksOfFolder release];
	
}

@end
