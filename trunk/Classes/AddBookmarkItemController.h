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
}

- (IBAction) addBookmark: (id) sender;

@end
