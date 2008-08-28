//
//  AddBookmarkController.h
//  GodWord
//
//  Created by Marcelo Andrade on 8/5/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddBookmarkController : UIViewController <UITableViewDelegate, 
UITableViewDataSource>
{
	IBOutlet UITableView *table;
}

@property(nonatomic, retain) UITableView *table;

@end
