//
//  SearchController.h
//  GodWord
//
//  Created by Marcelo Andrade on 1/4/09.
//  Copyright 2009 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UISearchBar *searchBar;
    IBOutlet UITableView *table;
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UIBarButtonItem *pageItem;
}

- (float) heightForLength:(int) length ;

-(void) searchWord:(NSString*) texto;

- (IBAction) nextPage: (id) sender;

- (IBAction) previousPage: (id) sender;

@end
