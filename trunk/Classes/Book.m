//
//  Book.m
//  GodWord
//
//  Created by Marcelo Andrade on 7/20/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "Book.h"
#import <sqlite3.h>

static sqlite3_stmt *obtainNumVerses = nil;
static sqlite3_stmt *obtainVerseText = nil;

@implementation Book

@synthesize pk, title, chapters;

- (id) initWithPrimaryKey: (NSString*) primaryKey title: (NSString *) bookTitle chapters: (NSInteger) numChapters
{
	if ( self = [super init] ) {		
		self.pk = primaryKey;
		self.title = bookTitle;
		self.chapters = numChapters;
	}
	return self;
}

- (int) obtainNumVersesInChapter:(int) chapter connection:(sqlite3*) database
{
	if (obtainNumVerses == nil) {
        static char *sql = "select max(verse_no) from verses where book_id = ? and chapter_no = ? ";
        if (sqlite3_prepare_v2(database, sql, -1, &obtainNumVerses, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
	
	sqlite3_bind_text(obtainNumVerses, 1,  [pk UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(obtainNumVerses, 2, chapter);
	
	int success = sqlite3_step(obtainNumVerses);
	int numVerses = 0;
	
	if (success == SQLITE_ROW) 
	{
		numVerses = sqlite3_column_int(obtainNumVerses, 0);
	}
	
	sqlite3_reset(obtainNumVerses);
	
	return numVerses;
	
}

- (NSString*) obtainVerseTextWithChapter:(int) chapter
							 verseNumber:(int) verse
							  connection:(sqlite3*) database
{
	
	if (obtainVerseText == nil) {
        static char *sql = "select verse from verses where book_id = ? and chapter_no = ? and verse_no = ?";
        if (sqlite3_prepare_v2(database, sql, -1, &obtainVerseText, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
	
	sqlite3_bind_text(obtainVerseText, 1,  [pk UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(obtainVerseText, 2, chapter);
	sqlite3_bind_int(obtainVerseText, 3, verse);
	
	int success = sqlite3_step(obtainVerseText);
	NSString *verseText = nil;
	NSString *verseNumberText = [[[NSString alloc] init] stringByAppendingFormat:@"%d. ", verse];
	
	if (success == SQLITE_ROW) 
	{
		verseText = [verseNumberText stringByAppendingString: [NSString stringWithUTF8String:(char *)sqlite3_column_text(obtainVerseText, 0)] ];
	}
	
	sqlite3_reset(obtainVerseText);
	
	if (verseText==nil)
		verseText = [[NSString alloc] initWithString:@"Verse not found"];				 
	
	return verseText;
	
}

+ (void) finalizeStatements {
    if (obtainNumVerses) sqlite3_finalize(obtainNumVerses);
	if (obtainVerseText) sqlite3_finalize(obtainVerseText);
}

@end
