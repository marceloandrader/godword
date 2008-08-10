//
//  Verse.h
//  GodWord
//
//  Created by Marcelo Andrade on 7/22/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Verse : NSObject {
	NSInteger testament;
	NSInteger bookNumber;
	NSInteger chapterNumber;
	NSInteger verseNumber;
}
@property(nonatomic, assign) NSInteger testament;
@property(nonatomic, assign) NSInteger bookNumber;
@property(nonatomic, assign) NSInteger chapterNumber;
@property(nonatomic, assign) NSInteger verseNumber;
@end