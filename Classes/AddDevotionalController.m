//
//  AddDevotionalController.m
//  GodWord
//
//  Created by Marcelo Andrade on 8/26/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "AddDevotionalController.h"
#import "EditTextViewController.h"

@implementation AddDevotionalController


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
	[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	verse.text = @"Gen 1:1";
	devotionalTitle.text = @"";
	verseText.text = @"";
	q1.text = @"";
	q2.text = @"";
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

- (void) save {
	NSLog(@"save %@", devotionalTitle.text );
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction) finishEditing: (id) sender{
	[devotionalTitle resignFirstResponder];
}

- (IBAction) editTextView: (id) sender{
	EditTextViewController *editTextViewController = [[EditTextViewController alloc]
													  initWithNibName:@"EditTextView" 
													  bundle:[NSBundle mainBundle]];
	editTextViewController.navigationItem.title = @"Edit";
	UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] 
								 initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
								 target:editTextViewController 
								 action:@selector(done)];
	editTextViewController.navigationItem.rightBarButtonItem = doneItem;
	[doneItem release];
	[self.navigationController pushViewController:editTextViewController animated:YES];
	[editTextViewController release];
}

@end
