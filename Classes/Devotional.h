//
//  Devotional.h
//  GodWord
//
//  Created by Marcelo Andrade on 8/26/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Devotional : NSObject {
	NSInteger pk;
	NSString *title;
	NSString *questionOne;
	NSString *questionTwo;
	NSInteger verse;
	NSString *verseNo;
	NSDate *date;
}

@property(nonatomic, assign) NSInteger pk;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *questionOne;
@property(nonatomic, copy) NSString *questionTwo;
@property(nonatomic, assign) NSInteger verse;
@property(nonatomic, copy) NSString *verseNo;
@property(nonatomic, copy) 	NSDate *date;

@end
