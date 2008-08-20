//
//  AddBookmarkItemController.h
//  GodWord
//
//  Created by Marcelo Andrade on 8/9/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddBookmarkItemController : UIViewController {
	IBOutlet UITextField * description;
	IBOutlet UILabel * verse;
	IBOutlet UIButton * save;
	NSInteger rowFolder;
}

@property(nonatomic, assign) NSInteger rowFolder;

- (IBAction) addBookmark: (id) sender;

- (IBAction) finishEditing: (id) sender;

@end
