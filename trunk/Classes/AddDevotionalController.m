//
//  AddDevotionalController.m
//  GodWord
//
//  Created by Marcelo Andrade on 8/26/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "AddDevotionalController.h"
#import "EditTextViewController.h"
#import "Devotional.h"
#import "GodWordAppDelegate.h"
#import "Verse.h"
#import "BibleDatabase.h"
#import "Book.h"
#import "ReadChapterController.h"
#import "DevotionalListController.h"

@implementation AddDevotionalController

@synthesize devotional;

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
	//btnGoToVerse.font = [UIFont systemFontOfSize:14];
	verseText.font = [UIFont systemFontOfSize:14];
	q1.font = [UIFont systemFontOfSize:14];
	q2.font = [UIFont systemFontOfSize:14];	
	[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate*)[[UIApplication sharedApplication] delegate];
	//verse.text = [appDelegate.bible obtainVerseNumber:appDelegate.verseSelected];
	[btnGoToVerse setTitle:[appDelegate.bible obtainVerseNumber:appDelegate.verseSelected] forState:UIControlStateNormal];
	[btnGoToVerse setTitle:[appDelegate.bible obtainVerseNumber:appDelegate.verseSelected] forState:UIControlStateDisabled];
	verseText.text = [appDelegate.bible obtainVerseText:appDelegate.verseSelected];
	if (devotional==nil){
		devotionalTitle.text = @"";
		q1.text = @"";
		q2.text = @"";
		btnGoToVerse.enabled = NO;
	}else
	{
		btnGoToVerse.enabled = YES;
		devotionalTitle.text = devotional.title;
		q1.text = devotional.questionOne;
		q2.text = devotional.questionTwo;
	}
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

- (void) saveData
{
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	Devotional *devotionalEdited;
	
	if (devotional==nil)
		devotionalEdited = [[Devotional alloc] init];
	else
	{
		devotionalEdited = devotional;
		devotionalEdited.pk = devotional.pk;
	}
	
	devotionalEdited.title = devotionalTitle.text;
	devotionalEdited.verse = appDelegate.verseSelected.verseId;
	devotionalEdited.questionOne = q1.text;
	devotionalEdited.questionTwo = q2.text;
	devotionalEdited.date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
	devotionalEdited.verseNo = [appDelegate.bible obtainVerseNumber:appDelegate.verseSelected];
	[appDelegate.bible saveDevotional:devotionalEdited];
	
}

- (void) save {
	[self saveData];
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void) saveWithPop {
	[self saveData];
	[self.navigationController popViewControllerAnimated:YES];
	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.tabBarController.selectedIndex = 1;
	appDelegate.tabBarController.selectedIndex = 3;	
}

- (IBAction) finishEditing: (id) sender{
	[devotionalTitle resignFirstResponder];
}

- (IBAction) editTextView1: (id) sender{
	[self showEditTextView:q1];
}

- (IBAction) editTextView2: (id) sender{
	[self showEditTextView:q2];
}

- (void) showEditTextView:(UITextView*) question
{
	EditTextViewController *editTextViewController = [[EditTextViewController alloc]
													  initWithNibName:nil 
													  bundle:nil];
	editTextViewController.navigationItem.title = NSLocalizedString(@"Edit",@"Edit");
	UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] 
								 initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
								 target:editTextViewController 
								 action:@selector(done)];
	editTextViewController.navigationItem.rightBarButtonItem = doneItem;
	[doneItem release];
	editTextViewController.txtEdited = question;
	[self.navigationController pushViewController:editTextViewController animated:YES];
	[editTextViewController release];
	
}

- (IBAction) goToVerse: (id) sender{

	GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
    
   	[appDelegate.bible refreshVerseFromVerseId:devotional.verse verse:appDelegate.verseSelected];
    
	appDelegate.tabBarController.selectedIndex = 1;
	
	
}

@end
