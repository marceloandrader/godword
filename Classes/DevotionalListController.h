//
//  DevotionalListController.h
//  GodWord
//
//  Created by Marcelo Andrade on 8/26/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DevotionalListController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *table;
}

@property(nonatomic, retain) UITableView *table;

@end
