//
//  EditTextViewController.h
//  GodWord
//
//  Created by Marcelo Andrade on 8/27/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditTextViewController : UIViewController<UITextViewDelegate,
UITableViewDelegate, UITableViewDataSource> {
	UITableView	*myTableView;
	UITextView *txtEdited;													
	
}

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) UITextView *txtEdited;							
- (void) done;

@end
