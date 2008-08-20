//
//  BookmarkCell.h
//  GodWord
//
//  Created by Marcelo Andrade on 8/17/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BookmarkCell : UITableViewCell {
	UILabel *descriptionLabel;
	UILabel *verse;
}

@property(readonly, retain) UILabel *descriptionLabel;
@property(readonly, retain) UILabel *verse;

@end
