//
//  CellTextView.h
//  GodWord
//
//  Created by Marcelo Andrade on 8/5/08.
//  Copyright 2008 Casa. All rights reserved.
//


#import "CellTextView.h"

// cell identifier for this custom cell
NSString* kCellTextView_ID = @"CellTextView_ID";

#define kInsertValue	8.0

@implementation CellTextView

@synthesize textView;

- (id)initWithFrame:(CGRect)aRect reuseIdentifier:(NSString *)identifier
{
	self = [super initWithFrame:aRect reuseIdentifier:identifier];
	if (self)
	{
		// turn off selection use
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        
       /* CGRect frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
        
        textView = [[[UITextView alloc] initWithFrame:frame] autorelease];
        textView.textColor = [UIColor blackColor];
        textView.font = [UIFont fontWithName:@"Arial" size:18.0];
//        textView.delegate = self;
        textView.backgroundColor = [UIColor whiteColor];
        
//        textView.text = txtEdited.text;
        textView.returnKeyType = UIReturnKeyDefault;
        textView.keyboardType = UIKeyboardTypeDefault;
        [self.contentView addSubview:textView];
        [self layoutSubviews];*/
	}
	return self;
}


- (void)setTextView:(UITextView *)inView
{
	textView = inView;
	[textView retain];
	[self.contentView addSubview:inView];
	[self layoutSubviews];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect contentRect = [self.contentView bounds];
	
	// inset the text view within the cell
	if (contentRect.size.width > (kInsertValue*2))	// but not if the width is too small
	{
		self.textView.frame  = CGRectMake(contentRect.origin.x + kInsertValue,
									  contentRect.origin.y + kInsertValue,
									  contentRect.size.width - (kInsertValue*2),
									  contentRect.size.height - (kInsertValue*2));
	}
}

- (void)dealloc
{
    [textView release];
    //[super dealloc];
}

@end
