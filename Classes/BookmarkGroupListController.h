//
//  BookmarkGroupListController.h
//  GodWord
//
//  Created by Marcelo Andrade on 8/17/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BookmarkGroupListController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	UITableView *table;
	
}

@property(nonatomic,assign) UITableView *table;

@end
