//
//  Book.h
//  GodWord
//
//  Created by Marcelo Andrade on 7/20/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Book : NSObject {
	NSString *pk;
	NSString *title;
	NSInteger chapters;
}
@property(copy, nonatomic) NSString *pk;
@property(copy, nonatomic) NSString *title;
@property(assign, nonatomic) NSInteger chapters;

- (id) initWithPrimaryKey: (NSString*) primaryKey 
					title: (NSString *) bookTitle 
				 chapters:(NSInteger) numChapters;

- (int) obtainNumVersesInChapter:(int) chapter 
					  connection:(sqlite3*) database;

- (NSString*) obtainVerseTextWithChapter:(int) chapter
							 verseNumber:(int) verse
							  connection:(sqlite3*) database;


+ (void) finalizeStatements;

@end
