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
										 style:UITableViewStyleGrouped];
	
	table.autoresizingMask = 
	UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth; 
	table.delegate = self; 
	table.dataSource = self; 
	[table reloadData]; 
	
	self.view = table;
	
	[table release];
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
	BookmarkCell *cell = (BookmarkCell*) [tableView dequeueReusableCellWithIdentifier:@"BookmarkCellList"];
	if (cell == nil) {
		cell = [[BookmarkCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"BookmarkCellList"];
	}
	
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	BookmarkFolder *bookmarkFolder = (BookmarkFolder *)[appDelegate.bible.bookmarkFolders objectAtIndex:[indexPath section]];	
	Bookmark *bookmark = (Bookmark*)[bookmarkFolder.bookmarks objectAtIndex:[indexPath row]];
	cell.descriptionLabel.text = bookmark.description;
	cell.verse.text = bookmark.verseNo;
	return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	return [appDelegate.bible.bookmarkFolders count];
	
}

- (NSInteger) tableView:(UITableView *) tableView 
  numberOfRowsInSection:(NSInteger) section 
{
	
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	BookmarkFolder *bookmarkFolder = (BookmarkFolder *)[appDelegate.bible.bookmarkFolders objectAtIndex:section];	
	return [bookmarkFolder.bookmarks count];
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	BookmarkFolder *bookmarkFolder = (BookmarkFolder *)[appDelegate.bible.bookmarkFolders objectAtIndex:[indexPath section]];
	Bookmark *bookmark = (Bookmark*)[bookmarkFolder.bookmarks objectAtIndex:[indexPath row]];
	
	[appDelegate.bible refreshVerseFromVerseId:bookmark.verse verse:appDelegate.verseSelected];
	
	appDelegate.tabBarController.selectedIndex = 1;
	[((ReadChapterController*)appDelegate.tabBarController.selectedViewController).table reloadData];
	
	NSIndexPath* indexPathPosition = [NSIndexPath indexPathForRow:appDelegate.verseSelected.verseNumber inSection:0];
	
	[((ReadChapterController*)appDelegate.tabBarController.selectedViewController).table 
	 scrollToRowAtIndexPath:indexPathPosition 
	 atScrollPosition:UITableViewScrollPositionTop animated:false];
	
	[indexPathPosition release];
	
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	BookmarkFolder *bookmarFolder = (BookmarkFolder *)[appDelegate.bible.bookmarkFolders objectAtIndex: section];	
    return bookmarFolder.title;
}

@end
