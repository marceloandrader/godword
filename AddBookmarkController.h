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
- (UITableViewCell *) tableView:(UITableView *) tableView 
		  cellForRowAtIndexPath:(NSIndexPath *) indexPath;

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView;

- (NSInteger) tableView:(UITableView *) tableView 
  numberOfRowsInSection:(NSInteger) section ;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
