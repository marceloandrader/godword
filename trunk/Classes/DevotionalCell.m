//
//  DevotionalCell.m
//  GodWord
//
//  Created by Marcelo Andrade on 8/26/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "DevotionalCell.h"


@implementation DevotionalCell

@synthesize title, verseAndDate;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
		
		title =[[UILabel alloc] initWithFrame:CGRectZero];
		title.font = [UIFont boldSystemFontOfSize:14];
		title.textAlignment = UITextAlignmentLeft;
		title.backgroundColor = [UIColor clearColor];
		title.textColor = [UIColor blackColor];
		title.lineBreakMode = UILineBreakModeWordWrap;
		title.numberOfLines = 2;
		title.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:title];
		
		verseAndDate =[[UILabel alloc] initWithFrame:CGRectZero];
		verseAndDate.font = [UIFont systemFontOfSize:13];
		verseAndDate.textAlignment = UITextAlignmentLeft;
		verseAndDate.backgroundColor = [UIColor clearColor];
		verseAndDate.textColor = [UIColor blackColor];
		verseAndDate.lineBreakMode = UILineBreakModeWordWrap;
		verseAndDate.numberOfLines = 2;
		verseAndDate.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:verseAndDate];
		
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	return self;
}

- (void)setDateValue:(NSDate*)dateVal withVerse:(NSString*)verseNo {
	self.verseAndDate.text = [[NSString alloc] initWithFormat:@"%@ (%@)" ,[formatter stringFromDate:dateVal], verseNo];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}


- (void) layoutSubviews {
	[super layoutSubviews];
	CGRect bound = self.contentView.bounds;
	CGFloat height = bound.size.height / 2;
    CGRect baseRect = CGRectMake(bound.origin.x+3, bound.origin.y+3, bound.size.width, height);
    title.frame = baseRect;
	
	CGRect baseRect2 = CGRectMake(bound.origin.x+3, bound.origin.y+height, bound.size.width, height);
    verseAndDate.frame = baseRect2;
	
}


- (void)dealloc {
	[title release];
	[verseAndDate release];
	[super dealloc];
}


@end
