//
//  EditTextViewController.m
//  GodWord
//
//  Created by Marcelo Andrade on 8/27/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "EditTextViewController.h"
#import "CellTextView.h"

@implementation EditTextViewController

#define kUITextViewCellRowHeight 150.0

@synthesize myTableView, txtEdited;

- (id)init
{
	self = [super init];
	if (self)
	{
		// this title will appear in the navigation bar
		self.title = NSLocalizedString(@"Edit Answer", @"Edit Answer");
	}
	
	return self;
}

- (void)dealloc
{
	[myTableView release];
	
	[super dealloc];
}

- (void)loadView
{
	// create and configure the table view
	myTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];	
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.scrollEnabled = NO; // no scrolling in this case, we don't want to interfere with text view scrolling
	myTableView.autoresizesSubviews = YES;
	
	self.view = myTableView;
}

- (UITextView *)create_UITextView
{
	CGRect frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
	
	UITextView *textView = [[[UITextView alloc] initWithFrame:frame] autorelease];
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont fontWithName:@"Arial" size:18.0];
    textView.delegate = self;
    textView.backgroundColor = [UIColor whiteColor];
	
	textView.text = txtEdited.text;
	textView.returnKeyType = UIReturnKeyDefault;
	textView.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
	
	// note: for UITextView, if you don't like autocompletion while typing use:
	// myTextView.autocorrectionType = UITextAutocorrectionTypeNo;
	
	return textView;
}


#pragma mark UITextView delegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	// provide my own Save button to dismiss the keyboard
	UIBarButtonItem* saveItem = [[UIBarButtonItem alloc] 
								 initWithBarButtonSystemItem:UIBarButtonSystemItemDone
								 target:self 
								 action:@selector(done)];
	self.navigationItem.rightBarButtonItem = saveItem;
	[saveItem release];
}


#pragma mark - UITableView delegates

// if you want the entire table to just be re-orderable then just return UITableViewCellEditingStyleNone
//
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Question 1";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

// to determine specific row height for each cell, override this.  In this example, each row is determined
// buy the its subviews that are embedded.
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat result;
	
	switch ([indexPath row])
	{
		case 0:
		{
			result = kUITextViewCellRowHeight;
			break;
		}
	}
	
	return result;
}

// utility routine leveraged by 'cellForRowAtIndexPath' to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)obtainTableCellForRow:(NSInteger)row
{
	UITableViewCell *cell = nil;
	
	if (row == 0)
		cell = [myTableView dequeueReusableCellWithIdentifier:kCellTextView_ID];
	if (cell == nil)
	{
		if (row == 0)
		{
			cell = [[[CellTextView alloc] initWithFrame:CGRectZero reuseIdentifier:kCellTextView_ID] autorelease];
			((CellTextView*)cell).textView = [self create_UITextView];
		}
	}

	
	return cell;
}

// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	UITableViewCell *cellView = [self obtainTableCellForRow:row];
	
	return cellView;
}

- (void) done {
	UITableViewCell *cell = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	
	[((CellTextView *)cell).textView resignFirstResponder];
	self.txtEdited.text = ((CellTextView *)cell).textView.text;
	self.navigationItem.rightBarButtonItem = nil;
	[self.navigationController popViewControllerAnimated:YES];
}

@end

