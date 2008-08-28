//
//  DevotionalCell.h
//  GodWord
//
//  Created by Marcelo Andrade on 8/26/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DevotionalCell : UITableViewCell {
	UILabel *title;
	UILabel *verseAndDate;
	NSDateFormatter *formatter;
}

@property(nonatomic, retain) UILabel *title;
@property(nonatomic, retain) UILabel *verseAndDate;

- (void)setDateValue:(NSDate*)dateVal withVerse:(NSString*)verseNo ;

@end
