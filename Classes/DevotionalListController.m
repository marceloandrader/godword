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
#import "AddDevotionalController.h"

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
	table.allowsSelectionDuringEditing = NO;
	table.delegate = self; 
	table.dataSource = self; 
	table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	
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
										 initWithBarButtonSystemItem:UIBarButtonSystemItemTrash 
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
	NSDateFormatter *formatter;
	
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	[formatter setTimeStyle:NSDateFormatterNoStyle];
	
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	Devotional *devotional = (Devotional*) [appDelegate.bible.devotionals objectAtIndex:indexPath.row];
	
	[appDelegate.bible refreshVerseFromVerseId:devotional.verse verse:appDelegate.verseSelected];
	
	AddDevotionalController *devotionalController = [[AddDevotionalController alloc] 
													 initWithNibName:@"AddDevotional" 
													 bundle:[NSBundle mainBundle]];
	devotionalController.devotional = devotional;
	devotionalController.navigationItem.title = [formatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0]];
	UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] 
									  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
									  target:self 
									  action:@selector(dismiss)];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] 
								   initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
								   target:devotionalController action:@selector(saveWithPop)];
	
	devotionalController.navigationItem.leftBarButtonItem = dismissButton;
	devotionalController.navigationItem.rightBarButtonItem = saveButton;
	[dismissButton release];		
	[saveButton release];
	
	
	[self.navigationController pushViewController:devotionalController
							animated:YES];
	
	[devotionalController release];
	
	
}

-(void)dismiss
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)     tableView:(UITableView *)aTableView 
	commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
	 forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		Devotional * devotionalToDelete = [appDelegate.bible.devotionals objectAtIndex:indexPath.row];
		
		if (devotionalToDelete)
		{	
			[appDelegate.bible deleteDevotional:devotionalToDelete];
			[appDelegate.bible.devotionals removeObjectAtIndex:indexPath.row];
			[aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
							  withRowAnimation:UITableViewRowAnimationFade];
			
			
		}
		
	}
}


@end
