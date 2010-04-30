//
//  VerseCell.m
//  GodWord
//
//  Created by Marcelo Andrade on 7/29/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "VerseCell.h"


@implementation VerseCell

@synthesize verseText, darkColor;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) 
	{
		verseText = [[UILabel alloc] initWithFrame:CGRectZero];
//		NSArray* arreglo = [UIFont fontNamesForFamilyName:@"Courier"];
//		NSUInteger i, count = [arreglo count];
//		for (i = 0; i < count; i++) {
//			NSString * obj = (NSString*)[arreglo objectAtIndex:i];
//			NSLog(obj);
//		}

		verseText.font = [UIFont systemFontOfSize:14];
		//verseText.font = [UIFont fontWithName:@"Courier" size:14];
		verseText.textAlignment = UITextAlignmentLeft;
        //cambiar color celdas

        if (darkColor == YES){
            verseText.backgroundColor = [UIColor blackColor];
            verseText.textColor = [UIColor whiteColor];
		}else{   
            verseText.backgroundColor = [UIColor whiteColor];
            verseText.textColor = [UIColor blackColor];
        }
        
        verseText.lineBreakMode = UILineBreakModeWordWrap;
		verseText.numberOfLines = 20;
		verseText.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//		verseText.multipleTouchEnabled = true;
		[self.contentView addSubview:verseText];
		//self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;		
	}
	return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
	[super setSelected:selected animated:animated];
	
	if (selected)
	{
        if (darkColor == YES){
            verseText.backgroundColor = [UIColor whiteColor];
            verseText.textColor = [UIColor blackColor];
        }else{
            verseText.backgroundColor = [UIColor blackColor];
            verseText.textColor = [UIColor whiteColor];
        }
	} else {
        if (darkColor == YES){
            verseText.backgroundColor = [UIColor blackColor];
            verseText.textColor = [UIColor whiteColor];
        }else{
            verseText.backgroundColor = [UIColor whiteColor];
            verseText.textColor = [UIColor blackColor];
        }
    }

		
}

- (void) layoutSubviews {
	[super layoutSubviews];
    CGRect baseRect = CGRectInset(self.contentView.bounds, 0, 0);
    verseText.frame = baseRect;
}


- (void)dealloc {
	[verseText release];
	[super dealloc];
}


@end
