//
//  AddDevotionalController.h
//  GodWord
//
//  Created by Marcelo Andrade on 8/26/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddDevotionalController : UIViewController {
	IBOutlet UILabel *verse;
	IBOutlet UITextView *verseText;	
	IBOutlet UITextField *devotionalTitle;
	IBOutlet UITextView *q1;
	IBOutlet UITextView *q2;
	NSDateFormatter *formatter;
}

- (void) save;

- (IBAction) finishEditing: (id) sender;

- (IBAction) editTextView: (id) sender;

@end
