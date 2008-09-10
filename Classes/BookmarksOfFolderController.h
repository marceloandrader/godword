//
//  BookmarksOfFolderController.h
//  GodWord
//
//  Created by Marcelo Andrade on 9/8/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BookmarksOfFolderController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	UITableView *table;
	NSInteger folder;
}

@property(nonatomic, assign) NSInteger folder;
@property(nonatomic, retain) UITableView *table;

@end
