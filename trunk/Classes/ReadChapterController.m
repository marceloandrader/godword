//
//  ReadChapterController.m
//  GodWord
//
//  Created by Marcelo Andrade on 7/20/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "ReadChapterController.h"
#import "GodWordAppDelegate.h"
#import "BibleDatabase.h"
#import "Verse.h"
#import "Book.h"
#import "VerseCell.h"
#import "AddBookmarkController.h"

#define HEIGHT_ONE_ROW 21
#define NUM_CHARACTERS_BY_LINE 44

@implementation ReadChapterController

@synthesize table, rowTapped;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
		NSLog(@"initWithNibName read chapter");
	}
	return self;
}


/* Implement loadView if you want to create a view hierarchy programmatically
 - (void)loadView {
	 NSLog(@"load View read chapter");
 }
*/


/* If you need to do additional setup after loading the view, override viewDidLoad.
- (void)viewDidLoad {

}*/



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
	//return YES;
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
	VerseCell *cell = (VerseCell*) [tableView dequeueReusableCellWithIdentifier:@"VerseCell"];
	if (cell == nil) {
		cell = [[VerseCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"VerseCell"];
		cell.hidesAccessoryWhenEditing = NO;
	}
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	Book* book ;
	if (appDelegate.verseSelected.testament == 0 )
		book = (Book*) [appDelegate.bible.booksFromOld 
						objectAtIndex: appDelegate.verseSelected.bookNumber];
	else
		book = (Book*) [appDelegate.bible.booksFromNew 
						objectAtIndex: appDelegate.verseSelected.bookNumber];
	
	cell.verseText.text = [appDelegate.bible 
						   obtainTextVerseInBook:book 
						   inChapter:appDelegate.verseSelected.chapterNumber 
						   inVerse:[indexPath row]+1];
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
	Book* book ;
	if (appDelegate.verseSelected.testament == 0 )
		book = (Book*) [appDelegate.bible.booksFromOld objectAtIndex: appDelegate.verseSelected.bookNumber];
	else
		book = (Book*) [appDelegate.bible.booksFromNew objectAtIndex: appDelegate.verseSelected.bookNumber];
	NSLog(@"rows in section");
	return [appDelegate.bible obtainNumVersesInBook:book inChapter:appDelegate.verseSelected.chapterNumber];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	Book* book ;
	if (appDelegate.verseSelected.testament == 0 )
		book = (Book*) [appDelegate.bible.booksFromOld objectAtIndex: appDelegate.verseSelected.bookNumber];
	else
		book = (Book*) [appDelegate.bible.booksFromNew objectAtIndex: appDelegate.verseSelected.bookNumber];
	
	int verseLength = [[appDelegate.bible obtainTextVerseInBook:book 
						inChapter:appDelegate.verseSelected.chapterNumber 
						inVerse:[indexPath row]+1] length];
	
	return [self heightForLength:verseLength];
	
}

- (float) heightForLength:(int) length {
	
	int numLines;
	
	numLines = (length / NUM_CHARACTERS_BY_LINE) + 1;
	
	return  HEIGHT_ONE_ROW * numLines;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	Book* book ;
	if (appDelegate.verseSelected.testament == 0 )
		book = (Book*) [appDelegate.bible.booksFromOld 
						objectAtIndex: appDelegate.verseSelected.bookNumber];
	else
		book = (Book*) [appDelegate.bible.booksFromNew 
						objectAtIndex: appDelegate.verseSelected.bookNumber];
	NSString *title = book.title;
	title = [title stringByAppendingFormat:@" - %d", appDelegate.verseSelected.chapterNumber];
	return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@" verse selected %d", [indexPath row]);
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	rowTapped = [indexPath row];
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Save this verse to:"
															 delegate:self cancelButtonTitle:nil		
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Bookmark", @"Note", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
	[actionSheet release];
}


#pragma mark UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 0){
		//Bookmark
		NSLog(@"bookmarking %d", rowTapped);
		AddBookmarkController *bookmarkController = [[AddBookmarkController alloc] 
													 initWithNibName:@"AddBookmark" 
													 bundle:[NSBundle mainBundle]];
		bookmarkController.navigationItem.title = @"Bookmark Folders";
		UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] 
										  initWithTitle:@"Back"
										  style:UIBarButtonItemStyleBordered
										  target:self 
										  action:@selector(dismiss)];
		
		
		bookmarkController.navigationItem.leftBarButtonItem = dismissButton;
		[dismissButton release];		
		
		UINavigationController *navigationController = [[UINavigationController alloc] 
														initWithRootViewController:bookmarkController];
		[bookmarkController release];
		
		
		[self presentModalViewController:navigationController
								animated:YES];

		[navigationController release];
	} else if (buttonIndex == 1) {
		//Note
		NSLog(@"annotating %d", rowTapped);
	}
}

-(void)dismiss
{
	[self dismissModalViewControllerAnimated:TRUE];
}



@end