//
//  Verse.m
//  GodWord
//
//  Created by Marcelo Andrade on 7/22/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "Verse.h"
#import "GodWordAppDelegate.h"
#import "Book.h"
#import "BibleDatabase.h"
#import <sqlite3.h>

static sqlite3_stmt *obtainVerseId = nil;
static sqlite3_stmt *obtainVerse = nil;

@implementation Verse
@synthesize testament, bookNumber, chapterNumber, verseNumber, verseId, text;


- (void) obtainVerseIdWithConnection: (sqlite3*) database
{
	
	if (obtainVerseId == nil) {
        static char *sql = "select id, verse from verses where book_id = ? and chapter_no = ? and verse_no = ?";
        if (sqlite3_prepare_v2(database, sql, -1, &obtainVerseId, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
	
	GodWordAppDelegate *delegate = (GodWordAppDelegate*)[[UIApplication sharedApplication] delegate];
	Book * book;
	
	if (delegate.verseSelected.testament == 0)
		book = (Book*)[delegate.bible.booksFromOld objectAtIndex:self.bookNumber];
	else
		book = (Book*)[delegate.bible.booksFromNew objectAtIndex:self.bookNumber];
	
	sqlite3_bind_text(obtainVerseId, 1,  [book.pk UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(obtainVerseId, 2, self.chapterNumber);
	sqlite3_bind_int(obtainVerseId, 3, self.verseNumber);
	
	int success = sqlite3_step(obtainVerseId);
	
	if (success == SQLITE_ROW) 
	{
		self.verseId = sqlite3_column_int(obtainVerseId, 0);
		self.text = [NSString stringWithUTF8String:(char *)sqlite3_column_text(obtainVerseId, 1)] ;
	}
	else
	{
		self.verseId = 0;
		self.text = @"";
	}
	
	sqlite3_reset(obtainVerseId);
		
}

- (void) obtainVerseFromVerseId:(NSInteger) verseIdQuery withConnection:(sqlite3 *) database
{
	if (obtainVerse == nil) {
        static char *sql = "select bo.testament, v.chapter_no, v.verse_no, bo.id from verses v, books bo where bo.id = v.book_id and v.id = ?";
		
        if (sqlite3_prepare_v2(database, sql, -1, &obtainVerse, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
	
	sqlite3_bind_int(obtainVerse, 1, verseIdQuery);
	
	int success = sqlite3_step(obtainVerse);
	
	if (success == SQLITE_ROW) 
	{
		self.verseId = verseIdQuery;
		self.testament = sqlite3_column_int(obtainVerse, 0);
		self.chapterNumber = sqlite3_column_int(obtainVerse, 1);
		self.verseNumber = sqlite3_column_int(obtainVerse, 2);
		NSString * bookId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(obtainVerse, 3)] ;
		
	GodWordAppDelegate *delegate = (GodWordAppDelegate*)[[UIApplication sharedApplication] delegate];
		NSMutableArray *array;
	
	if (self.testament == 0)
		array = delegate.bible.booksFromOld;
	else
		array = delegate.bible.booksFromNew;
		int i=0;
		for (i=0; i<[array count]; i++) {
			Book *book = (Book*) [array objectAtIndex:i];
			if ([book.pk isEqual:bookId])
			{
				break;
			}
		}
		
		self.bookNumber = i;
		
	}
	else
	{
		self.verseId = 0;
		self.testament = 0;
		self.chapterNumber = 0;
		self.verseNumber = 0;
		self.bookNumber = 0;
	}

	sqlite3_reset(obtainVerse);

}

+ (void) finalizeStatements {
	if (obtainVerse) sqlite3_finalize(obtainVerse);
    if (obtainVerseId) sqlite3_finalize(obtainVerseId);
}


@end