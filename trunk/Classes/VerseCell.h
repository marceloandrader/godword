//
//  VerseCell.h
//  GodWord
//
//  Created by Marcelo Andrade on 7/29/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VerseCell : UITableViewCell {
	UILabel *verseText;
    bool darkColor;
}

@property(readonly, retain) UILabel *verseText;
@property(nonatomic, assign)    bool darkColor;

@end
