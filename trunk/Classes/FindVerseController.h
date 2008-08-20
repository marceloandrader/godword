//
//  FindVerseController.h
//  GodWord
//
//  Created by Marcelo Andrade on 7/20/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Book;

@interface FindVerseController : UIViewController <UIPickerViewDelegate> {
	IBOutlet UIPickerView *versePicker;
	IBOutlet UISegmentedControl *testamentChooser;
}

- (Book *) bookAtTestament:(int) testament inRow:(int) row;

- (void) setVerse;

- (IBAction) searchVerse: (id) sender;
- (IBAction) changeTestament: (id) sender;

@end
