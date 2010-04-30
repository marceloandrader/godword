//
//  SearchController.m
//  GodWord
//
//  Created by Marcelo Andrade on 1/4/09.
//  Copyright 2009 Casa. All rights reserved.
//

#import "SearchController.h"
#import "GodWordAppDelegate.h"
#import "BibleDatabase.h"
#import "VerseCell.h"
#import "Verse.h"
#import "Book.h"
#import "ReadChapterController.h"


@implementation SearchController

#pragma mark UISearchBarDelegate functions

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchB{
    NSString * searchText = searchB.text;
    GodWordAppDelegate* appDelegate = (GodWordAppDelegate*) [[UIApplication sharedApplication] delegate];
    appDelegate.bible.page = 1;

    [self searchWord:searchText];
}

-(void) searchWord:(NSString*) texto{
    GodWordAppDelegate* appDelegate = (GodWordAppDelegate*) [[UIApplication sharedApplication] delegate];
    pageItem.title = [[NSString alloc] initWithFormat:@"%d", appDelegate.bible.page];
    if ([texto length] == 0) {
        return;
    }
    
    activity.hidden = NO;
    [activity startAnimating]; 
    [self.view setNeedsLayout];
    [appDelegate.bible.versesFound removeAllObjects];
    
    [appDelegate.bible searchWord:texto];
    [table reloadData];
    
    [activity stopAnimating];
    activity.hidden = YES;
}

- (IBAction) nextPage: (id) sender{
    NSString * searchText = searchBar.text;
    GodWordAppDelegate* appDelegate = (GodWordAppDelegate*) [[UIApplication sharedApplication] delegate];
    appDelegate.bible.page += 1;
    [self searchWord:searchText];    
    
    if ([appDelegate.bible.versesFound count] == 0 ) {
        appDelegate.bible.page -= 1;
        [self searchWord:searchText];    
    }
}

- (IBAction) previousPage: (id) sender{
    NSString * searchText = searchBar.text;
    GodWordAppDelegate* appDelegate = (GodWordAppDelegate*) [[UIApplication sharedApplication] delegate];
    appDelegate.bible.page -= 1;
    if(appDelegate.bible.page == 0){
        appDelegate.bible.page = 1;
    }
    
    [self searchWord:searchText]; 
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchB{
    [searchB resignFirstResponder];
}

#pragma mark UITableViewDelegate & dataSource functions

- (NSInteger) tableView:(UITableView *) tableView 
  numberOfRowsInSection:(NSInteger) section {
    GodWordAppDelegate* appDelegate = (GodWordAppDelegate*) [[UIApplication sharedApplication] delegate];
    return [appDelegate.bible.versesFound count];
}

- (UITableViewCell *) tableView:(UITableView *) tableView 
		  cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    
    GodWordAppDelegate* appDelegate = (GodWordAppDelegate*) [[UIApplication sharedApplication] delegate];
    VerseCell *cell = (VerseCell*) [tableView dequeueReusableCellWithIdentifier:@"VerseFoundCell"];
	if (cell == nil) {
		cell = [[VerseCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"VerseFoundCell"];
	}
	
    Verse *verse = [appDelegate.bible.versesFound objectAtIndex:[indexPath row]];
    Book *book;
    if (verse.testament == 0)
        book = (Book*) [appDelegate.bible.booksFromOld 
						objectAtIndex: verse.bookNumber];
	else
		book = (Book*) [appDelegate.bible.booksFromNew 
						objectAtIndex: verse.bookNumber];
    
    cell.verseText.text = [[NSString alloc] initWithFormat:@"%@ %d:%d. %@", book.title, verse.chapterNumber,
    verse.verseNumber, verse.text];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
    Verse *verse = [appDelegate.bible.versesFound objectAtIndex:[indexPath row]];
	Book *book;
    if (verse.testament == 0)
        book = (Book*) [appDelegate.bible.booksFromOld 
						objectAtIndex: verse.bookNumber];
	else
		book = (Book*) [appDelegate.bible.booksFromNew 
						objectAtIndex: verse.bookNumber];
    
    NSString *verso = [[NSString alloc] initWithFormat:@"%@ %d:%d. %@", book.title, verse.chapterNumber,
                           verse.verseNumber, verse.text];
	return [self heightForLength:[verso length]];
	
}

/*- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];

    return [[NSString alloc] initWithFormat:@"%d %@", [appDelegate.bible.versesFound count], NSLocalizedString(@"verses found", @"verses found")];
}*/

- (float) heightForLength:(int) length {
	
	int numLines;
	
	numLines = (length / NUM_CHARACTERS_BY_LINE) + 1;
	
	return  HEIGHT_ONE_ROW * numLines;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
    Verse *verse = [appDelegate.bible.versesFound objectAtIndex:[indexPath row]];
    [appDelegate.bible refreshVerseFromVerseId:verse.verseId verse:appDelegate.verseSelected];

    appDelegate.tabBarController.selectedIndex = 1;

}

#pragma mark UIView & Class functions

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
    searchBar.keyboardType = UIKeyboardTypeDefault; 
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


@end
