//
//  AddFolderController.h
//  GodWord
//
//  Created by Marcelo Andrade on 8/19/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookmarkFolder;

@interface AddFolderController : UIViewController {
	IBOutlet UITextField *description;
	IBOutlet UIButton *save;
	BookmarkFolder *folder;
}

@property (nonatomic, retain) UITextField *description;
@property (nonatomic, retain) BookmarkFolder *folder;
- (IBAction) addFolder: (id) sender;

@end
