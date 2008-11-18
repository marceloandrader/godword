//
//  AddBookmarkController.m
//  GodWord
//
//  Created by Marcelo Andrade on 8/5/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "AddBookmarkController.h"
#import "BookmarkFolder.h"
#import "GodWordAppDelegate.h"
#import "BibleDatabase.h"
#import "AddBookmarkItemController.h"
#import "Verse.h"
#import "AddFolderController.h"

@implementation AddBookmarkController

@synthesize table;

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
	table.allowsSelectionDuringEditing = YES;
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
} 

- (void) viewWillAppear:(BOOL)animated {
	[table reloadData];
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
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.hidesAccessoryWhenEditing = NO;
	}
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
		
	if (indexPath.row < [appDelegate.bible.bookmarkFolders count])
	{
		BookmarkFolder *bookmarFolder = (BookmarkFolder *)[appDelegate.bible.bookmarkFolders objectAtIndex:[indexPath row]];

		cell.text = bookmarFolder.title;
	} else {
		cell.text = NSLocalizedString(@"Add new folder",@"Add new folder");
	}
	
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
	NSInteger count = [appDelegate.bible.bookmarkFolders count];
	if (table.editing) 	count++;
	return count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[table deselectRowAtIndexPath:indexPath animated:NO];
	if (table.editing == NO) {
		AddBookmarkItemController *addBookmarkItemController = [[[AddBookmarkItemController alloc] 
														  initWithNibName:@"AddBookmarkItem" 
														  bundle:[NSBundle mainBundle]] autorelease];
		addBookmarkItemController.rowFolder = [indexPath row];
		addBookmarkItemController.navigationItem.title = NSLocalizedString(@"Add Bookmark",@"Add Bookmark");
		[[self navigationController] pushViewController:addBookmarkItemController animated:YES];
		
	} else {
		
		//controlador de modificar carpeta
		
		GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		BookmarkFolder * folderToEdit ;
		
		if ([appDelegate.bible.bookmarkFolders count] == 0 || indexPath.row >= [appDelegate.bible.bookmarkFolders count]){
			folderToEdit = [[BookmarkFolder alloc] initWithPrimaryKey:0 title:@""];
		}else
		{
			folderToEdit = [appDelegate.bible.bookmarkFolders objectAtIndex:indexPath.row];
		}
		
		AddFolderController *addFolderController = [[[AddFolderController alloc] initWithNibName:@"AddFolder" bundle:[NSBundle mainBundle]
		] autorelease];
		
		addFolderController.navigationItem.title = NSLocalizedString(@"Edit Folder",@"Edit Folder");
		addFolderController.folder = folderToEdit;
		[self.navigationController pushViewController:addFolderController animated:YES];
	}

}

- (void)     tableView:(UITableView *)aTableView 
	commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
	 forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];

		BookmarkFolder * folderToDelete = [appDelegate.bible.bookmarkFolders objectAtIndex:indexPath.row];
		
		if ([folderToDelete.bookmarks count] == 0) {
			
			[appDelegate.bible deleteFolder:folderToDelete];
			[appDelegate.bible.bookmarkFolders removeObjectAtIndex:indexPath.row];
			[aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
						  withRowAnimation:UITableViewRowAnimationFade];

			
		}
		
	} else if (editingStyle == UITableViewCellEditingStyleInsert) {
		
		AddFolderController *addFolderController = [[[AddFolderController alloc] initWithNibName:@"AddFolder" bundle:[NSBundle mainBundle]
													 ] autorelease];
		
		addFolderController.navigationItem.title = NSLocalizedString(@"Add Folder",@"Add Folder");
		BookmarkFolder *insertFolder = [[BookmarkFolder alloc] initWithPrimaryKey:0 title:@""];
		addFolderController.folder = insertFolder;
		[self.navigationController pushViewController:addFolderController animated:YES];

	}
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];	
    [super setEditing:editing animated:animated];
    NSArray *indexPaths = [NSArray arrayWithObjects:
						   [NSIndexPath indexPathForRow:[appDelegate.bible.bookmarkFolders count] inSection:0], nil];

    [table beginUpdates];
    [table setEditing:editing animated:YES];
    if (editing) {
		//show
        [table insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    } else {
		//hide
        [table deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    [table endUpdates];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // No editing style if not editing or the index path is nil.
    if (table.editing == NO || !indexPath) 
		return UITableViewCellEditingStyleNone;
	
    // Determine the editing style based on whether the cell is a placeholder for adding content or already 
    // existing content. Existing content can be deleted.
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (indexPath.row >= [appDelegate.bible.bookmarkFolders count]) {
		return UITableViewCellEditingStyleInsert;
	} else {
		return UITableViewCellEditingStyleDelete;
	}

    return UITableViewCellEditingStyleNone;
    
}



@end
