//
//  DevotionalListController.m
//  GodWord
//
//  Created by Marcelo Andrade on 8/26/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "DevotionalListController.h"
#import "GodWordAppDelegate.h"
#import "BibleDatabase.h"
#import "Devotional.h"
#import "DevotionalCell.h"

@implementation DevotionalListController

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
	table.separatorStyle = UITableViewCellSeparatorStyleNone;
	table.allowsSelectionDuringEditing = YES;
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
										 initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
										 target:self
										 action:@selector(edit)];
	self.navigationItem.rightBarButtonItem = deleteButtonItem;
	[deleteButtonItem release];
	[table setEditing:NO animated:YES];
}

#pragma mark UITableViewDelegate

- (UITableViewCell *) tableView:(UITableView *) tableView 
		  cellForRowAtIndexPath:(NSIndexPath *) indexPath 
{
	DevotionalCell *cell = (DevotionalCell*) 
	[tableView dequeueReusableCellWithIdentifier:@"DevotionalCellList"];
	if (cell == nil) {
		cell = [[DevotionalCell alloc] 
				initWithFrame:CGRectZero reuseIdentifier:@"DevotionalCellList"];
	}
	
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	Devotional *devotional = (Devotional*) [appDelegate.bible.devotionals objectAtIndex:indexPath.row];
	
	cell.title.text = devotional.title;
	[cell setDateValue:devotional.date withVerse:devotional.verseNo];
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
	return [appDelegate.bible.devotionals count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
		
}




@end
