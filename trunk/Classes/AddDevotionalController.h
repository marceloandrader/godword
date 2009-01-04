//
//  AddDevotionalController.h
//  GodWord
//
//  Created by Marcelo Andrade on 8/26/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Devotional;
@class Verse;

@interface AddDevotionalController : UIViewController {
	//IBOutlet UILabel *verse;
	IBOutlet UITextView *verseText;	
	IBOutlet UITextField *devotionalTitle;
	IBOutlet UITextView *q1;
	IBOutlet UITextView *q2;
	IBOutlet UIButton *btnGoToVerse;
	NSDateFormatter *formatter;
	Devotional *devotional;
}

@property(nonatomic, retain) Devotional *devotional;


- (void) save;

- (void) saveWithPop;

- (void) showEditTextView:(UITextView*) question;

- (IBAction) finishEditing: (id) sender;

- (IBAction) editTextView1: (id) sender;

- (IBAction) editTextView2: (id) sender;

- (IBAction) goToVerse: (id) sender;

@end
