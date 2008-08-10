//
//  FindVerseController.m
//  GodWord
//
//  Created by Marcelo Andrade on 7/20/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "FindVerseController.h"
#import "GodWordAppDelegate.h"
#import "ReadChapterController.h"
#import "BibleDatabase.h"
#import "Book.h"
#import "Verse.h"

@implementation FindVerseController

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
 If you need to do additional setup after loading the view, override viewDidLoad.*/
- (void)viewDidLoad {
	[self view].backgroundColor = [UIColor groupTableViewBackgroundColor];
}
 


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}


#pragma mark 
#pragma mark Methods for UIPickerViewDelegate
#pragma mark 

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *) pickerView 
{
	return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView
	rowHeightForComponent:(NSInteger)component
{
	return 35.0;
}

- (void)pickerView:(UIPickerView *)pickerView 
	  didSelectRow:(NSInteger)row 
	   inComponent:(NSInteger)component 
{
	[versePicker reloadComponent:1];
	[versePicker reloadComponent:2];	
}

- (CGFloat)pickerView:(UIPickerView *)pickerView
	widthForComponent:(NSInteger)component
{
	CGFloat componentWidth;
	switch (component) {
		case 0:
			componentWidth = 190.0;
			break;
		case 1:
			componentWidth = 45.0;
			break;
		case 2:
			componentWidth = 45.0;
			break;
	}
	return componentWidth;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView 
		numberOfRowsInComponent:(NSInteger)component
{
	
	if (component == 0) 
	{
		GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
		int result = 0;
		if ([testamentChooser selectedSegmentIndex] == 0)
			result = appDelegate.bible.booksFromOld.count;
		else
			result = appDelegate.bible.booksFromNew.count;
		return result;
	}
	else if (component == 1) 
	{
		int bookRow = [pickerView selectedRowInComponent:0];
		return [self bookAtTestament:[testamentChooser selectedSegmentIndex] inRow:bookRow].chapters;
	}
	else if (component == 2)
	{
		int bookRow = [pickerView selectedRowInComponent:0];
		int chapterRow = [pickerView selectedRowInComponent:1]+1;
		GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		Book * selectedBook = [self bookAtTestament:[testamentChooser selectedSegmentIndex] inRow:bookRow];
		return [appDelegate.bible obtainNumVersesInBook:selectedBook inChapter:chapterRow];
	}
	
	return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView 
			 titleForRow:(NSInteger)row 
			forComponent:(NSInteger)component
{
	if (component == 0 )
	{
		return [self bookAtTestament:[testamentChooser selectedSegmentIndex] inRow:row].title;
	}
	else if(component == 1 )
	{
		return [[NSNumber numberWithInt:(row+1)] stringValue];
	}
	else if (component == 2)
	{
		return [[NSNumber numberWithInt:(row+1)] stringValue];
	}
	return 0;
}

- (Book *) bookAtTestament:(int) testament inRow:(int) row
{
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	Book *bookRequested = nil;
	if ([testamentChooser selectedSegmentIndex] == 0)
		bookRequested = (Book*) [appDelegate.bible.booksFromOld objectAtIndex: row];
	else
		bookRequested = (Book*) [appDelegate.bible.booksFromNew objectAtIndex: row];
	
	return bookRequested;
}



#pragma mark 
#pragma mark Actions sent by the view
#pragma mark 

- (IBAction) searchVerse: (id) sender
{
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.verseSelected.testament     = [testamentChooser selectedSegmentIndex];
	appDelegate.verseSelected.bookNumber    = [versePicker selectedRowInComponent:0];
	appDelegate.verseSelected.chapterNumber = [versePicker selectedRowInComponent:1] + 1;
	appDelegate.verseSelected.verseNumber   = [versePicker selectedRowInComponent:2] + 1;
	appDelegate.tabBarController.selectedIndex = 1;
	[((ReadChapterController*)appDelegate.tabBarController.selectedViewController).table reloadData];
	NSIndexPath* indexPath = [[[NSIndexPath alloc] indexPathByAddingIndex:0] indexPathByAddingIndex:[versePicker selectedRowInComponent:2] ];

	[((ReadChapterController*)appDelegate.tabBarController.selectedViewController).table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:false];
}

- (IBAction) changeTestament: (id) sender
{
	[versePicker reloadComponent:0];
	[versePicker reloadComponent:1];
	[versePicker reloadComponent:2];
}


@end
