//
//  EditTextViewController.h
//  GodWord
//
//  Created by Marcelo Andrade on 8/27/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditTextViewController : UIViewController<UIScrollViewDelegate, UITextViewDelegate,
													UITableViewDelegate, UITableViewDataSource> {
	UITableView	*myTableView;
}

@property (nonatomic, retain) UITableView *myTableView;

- (void) done;

@end
