//
//  BookmarkCell.m
//  GodWord
//
//  Created by Marcelo Andrade on 8/17/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "BookmarkCell.h"


@implementation BookmarkCell

@synthesize descriptionLabel, verse;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		
		descriptionLabel =[[UILabel alloc] initWithFrame:CGRectZero];
		descriptionLabel.font = [UIFont boldSystemFontOfSize:14];
		descriptionLabel.textAlignment = UITextAlignmentLeft;
		descriptionLabel.backgroundColor = [UIColor clearColor];
		descriptionLabel.textColor = [UIColor blackColor];
		descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
		descriptionLabel.numberOfLines = 2;
		descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:descriptionLabel];
		
		verse =[[UILabel alloc] initWithFrame:CGRectZero];
		verse.font = [UIFont systemFontOfSize:13];
		verse.textAlignment = UITextAlignmentLeft;
		verse.backgroundColor = [UIColor clearColor];
		verse.textColor = [UIColor blackColor];
		verse.lineBreakMode = UILineBreakModeWordWrap;
		verse.numberOfLines = 2;
		verse.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:verse];
		
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];

}

- (void) layoutSubviews {
	[super layoutSubviews];
	CGRect bound = self.contentView.bounds;
	CGFloat height = bound.size.height / 2;
    CGRect baseRect = CGRectMake(bound.origin.x+3, bound.origin.y+3, bound.size.width, height);
    descriptionLabel.frame = baseRect;
	
	CGRect baseRect2 = CGRectMake(bound.origin.x+3, bound.origin.y+height, bound.size.width, height);
    verse.frame = baseRect2;
	
}


- (void)dealloc {
	[descriptionLabel release];
	[verse release];
	[super dealloc];
}


@end
