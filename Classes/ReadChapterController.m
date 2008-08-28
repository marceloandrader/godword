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
#import "AddDevotionalController.h"

#define HEIGHT_ONE_ROW 21
#define NUM_CHARACTERS_BY_LINE 44

@implementation ReadChapterController

@synthesize table, rowTapped;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
		self.title = @"Read";
		self.tabBarItem.image = [UIImage imageNamed:@"Notes.png"];
	}
	return self;
}


/* Implement loadView if you want to create a view hierarchy programmatically
 - (void)loadView {
	 //NSLog(@"load View read chapter");
 }
*/


/* If you need to do additional setup after loading the view, override viewDidLoad.
- (void)viewDidLoad {

}*/



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

- (void)viewWillAppear:(BOOL)animated
{
	[table reloadData];
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
	//NSLog(@"rows in section");
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


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	rowTapped = [indexPath row];
	GodWordAppDelegate * delegate = (GodWordAppDelegate*) [[UIApplication sharedApplication] delegate];
	delegate.verseSelected.verseNumber = rowTapped + 1;
	[delegate.bible refreshVerseId:delegate.verseSelected];
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Save this verse to:"
															 delegate:self cancelButtonTitle:nil		
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Bookmark", @"Devotional", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
	[actionSheet release];
}


#pragma mark UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 0){
		//Bookmark
		
		//NSLog(@"bookmarking %d", rowTapped);
		AddBookmarkController *bookmarkController = [[AddBookmarkController alloc] 
													 initWithNibName:@"AddBookmark" 
													 bundle:[NSBundle mainBundle]];
		bookmarkController.navigationItem.title = @"Bookmark Folders";
		UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] 
										  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
										  target:self 
										  action:@selector(dismiss)];
		
		UIBarButtonItem *editButton = [[UIBarButtonItem alloc] 
									   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
									   target:bookmarkController action:@selector(edit)];
		
		
		
		bookmarkController.navigationItem.leftBarButtonItem = dismissButton;
		bookmarkController.navigationItem.rightBarButtonItem = editButton;
		[dismissButton release];		
		[editButton release];
		
		UINavigationController *navigationController = [[UINavigationController alloc] 
														initWithRootViewController:bookmarkController];
		[bookmarkController release];
		
		
		[self presentModalViewController:navigationController
								animated:YES];

		[navigationController release];
	} else if (buttonIndex == 1) {
		//Note
		//NSLog(@"annotating %d", rowTapped);
		NSDateFormatter *formatter;
		
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
		
		AddDevotionalController *devotionalController = [[AddDevotionalController alloc] 
													 initWithNibName:@"AddDevotional" 
													 bundle:[NSBundle mainBundle]];
		devotionalController.navigationItem.title = [formatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0]];
		UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] 
										  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
										  target:self 
										  action:@selector(dismiss)];
		
		UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] 
									   initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
									   target:devotionalController action:@selector(save)];
				
		devotionalController.navigationItem.leftBarButtonItem = dismissButton;
		devotionalController.navigationItem.rightBarButtonItem = saveButton;
		[dismissButton release];		
		[saveButton release];
		
		UINavigationController *navigationController = [[UINavigationController alloc] 
														initWithRootViewController:devotionalController];
		[devotionalController release];
		
		
		[self presentModalViewController:navigationController
								animated:YES];
		
		[navigationController release];
		
	}
}

-(void)dismiss
{
	[self dismissModalViewControllerAnimated:TRUE];
}



@end