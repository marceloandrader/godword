//
//  BibleDatabase.m
//  GodWord
//
//  Created by Marcelo Andrade on 7/20/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "BibleDatabase.h"
#import "Book.h"
#import "BookmarkFolder.h"
#import "Bookmark.h"
#import "Verse.h"
#import "Devotional.h"

@implementation BibleDatabase

@synthesize booksFromOld, booksFromNew, bookmarkFolders, devotionals, bibleName;

- (void)createEditableCopyOfDatabaseIfNeeded {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:self.bibleName];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) 
	{
		if (sqlite3_open([writableDBPath UTF8String], &connection) != SQLITE_OK) {
			NSAssert1(0, @"Failed to open the database file with message '%@'.", 
					  sqlite3_errmsg(connection));
		}
		return;
	}
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] 
							   stringByAppendingPathComponent:self.bibleName];
    success = [fileManager copyItemAtPath:defaultDBPath 
								   toPath:writableDBPath 
									error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", 
				  [error localizedDescription]);
    }
	
	if (sqlite3_open([writableDBPath UTF8String], &connection) != SQLITE_OK) {
		NSAssert1(0, @"Failed to open the database file with message '%@'.", 
				  sqlite3_errmsg(connection));
	}
}

- (void)initializeDatabase {
    NSMutableArray *bookArray = [[NSMutableArray alloc] init];
    self.booksFromOld = bookArray;
    [bookArray release];
    NSMutableArray *bookArray2 = [[NSMutableArray alloc] init];
    self.booksFromNew = bookArray2;
    [bookArray2 release];	
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:self.bibleName];
    if (sqlite3_open([path UTF8String], &connection) == SQLITE_OK) {
		const char *sql = "select id,name,testament,(select max(chapter_no) from verses v where v.book_id = b.id) from books b where id in (select distinct book_id from verses)";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(connection, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
				NSString *pk = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];					
				NSString *bookTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];					
				int testament = sqlite3_column_int(statement, 2);
				int numChapters = sqlite3_column_int(statement, 3);
				Book *book = [[Book alloc] initWithPrimaryKey:pk title:bookTitle chapters:numChapters];
				if (testament == 0)
					[booksFromOld addObject:book];
				else if (testament == 1)
					[booksFromNew addObject:book];
                [book release];
            }
        }
        sqlite3_finalize(statement);
    } else {
        sqlite3_close(connection);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(connection));
    }
}

- (void) initializeBookmarkFolders
{
	NSMutableArray *folders = [[NSMutableArray alloc] init];
    self.bookmarkFolders = folders;
    [folders release];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:self.bibleName];
    if (sqlite3_open([path UTF8String], &connection) == SQLITE_OK) {
		const char *sql = "select * from folders";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(connection, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
				NSInteger pk = sqlite3_column_int(statement, 0);
				NSString *folderTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				
				BookmarkFolder *bookmarkFolder = [[BookmarkFolder alloc] initWithPrimaryKey:pk 
																			   title:folderTitle];
				[bookmarkFolder refreshBookmarksWithDatabase:connection];
				[bookmarkFolders addObject:bookmarkFolder];
                [bookmarkFolder release];
            }
        }
        sqlite3_finalize(statement);
    } else {
        sqlite3_close(connection);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(connection));
    }
	
}

- (int) obtainNumVersesInBook:(Book *) book inChapter:(int) chapter
{
	return [book obtainNumVersesInChapter:chapter connection:connection];
}

- (NSString*) obtainTextVerseInBook:(Book *) book inChapter:(int) chapter inVerse:(int) verse
{
	return [book obtainVerseTextWithChapter:chapter verseNumber:verse connection:connection];
}

- (void) saveBookmark:(Bookmark *) bookmark
{
	[bookmark saveWithDatabase:connection];
}

- (void) refreshVerseId:(Verse*) verse
{
	[verse obtainVerseIdWithConnection:connection];
}

- (void) refreshVerseFromVerseId:(NSInteger) verseId verse:(Verse *) verse
{
	[verse obtainVerseFromVerseId:verseId withConnection:connection];
}

- (void) deleteBookmark:(Bookmark*) bookmark {
	[bookmark deleteWithDatabase:connection];
}

- (void) insertFolder:(BookmarkFolder *)folder {
	[folder insertWithDatabase:connection];
}

- (void) deleteFolder:(BookmarkFolder *)folder{
	[folder deleteWithDatabase:connection];
}

- (void) updateFolder:(BookmarkFolder *)folder{
	[folder updateWithDatabase:connection];
}

- (void) initializeDevotionals
{
	NSMutableArray *devotionalsArray = [[NSMutableArray alloc] init];
    self.devotionals = devotionalsArray;
    [devotionalsArray release];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:self.bibleName];
    if (sqlite3_open([path UTF8String], &connection) == SQLITE_OK) {
		const char *sql = "select d.*, v.chapter_no, v.verse_no, b.name from devotionals d, books b, verses v where d.verse_id = v.id and v.book_id = b.id ";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(connection, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
				NSInteger pk = sqlite3_column_int(statement, 0);
				NSString *title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				NSString *quest1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
				NSString *quest2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
				NSInteger verseId = sqlite3_column_int(statement, 4);
				
				NSDate *devDate = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(statement, 5)];
				
				NSInteger chapter = sqlite3_column_int(statement, 6);
				NSInteger verse = sqlite3_column_int(statement, 7);
				NSString *bookName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
				
				NSString * verseNo = [[NSString alloc] initWithFormat:@"%@ %d:%d", bookName, chapter, verse];
				
				Devotional * devotional = [[Devotional alloc] init];
				devotional.pk = pk;
				devotional.title = title;
				devotional.questionOne = quest1;
				devotional.questionTwo = quest2;				
				devotional.verse = verseId;
				devotional.verseNo = verseNo;
				devotional.date = devDate;
				
				[devotionals addObject:devotional];
				
                [devotional release];
            }
        }
        sqlite3_finalize(statement);
    } else {
        sqlite3_close(connection);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(connection));
    }
	
}


- (void) saveDevotional:(Devotional *) devotional
{
	if (devotional.pk != 0)
	{
		[devotional saveWithDatabase:connection];
	}else
	{	
		[devotional addWithDatabase:connection];
		[devotionals addObject:devotional];
	}
}

- (NSString*) obtainVerseNumber:(Verse*) verseSelected
{
	
	Book* book ;
	if (verseSelected.testament == 0 )
		book = (Book*) [self.booksFromOld 
						objectAtIndex: verseSelected.bookNumber];
	else
		book = (Book*) [self.booksFromNew 
						objectAtIndex: verseSelected.bookNumber];
	
	NSString * verseNo = [[NSString alloc] initWithFormat:@"%@ %d:%d", book.title, verseSelected.chapterNumber , verseSelected.verseNumber];
	return verseNo;
}

- (NSString*) obtainVerseText:(Verse *) verseSelected{

	Book* book ;
	if (verseSelected.testament == 0 )
		book = (Book*) [self.booksFromOld 
						objectAtIndex: verseSelected.bookNumber];
	else
		book = (Book*) [self.booksFromNew 
						objectAtIndex: verseSelected.bookNumber];
	
	return [self obtainTextVerseInBook:book inChapter:verseSelected.chapterNumber inVerse:verseSelected.verseNumber];
}


- (void) deleteDevotional:(Devotional *)devotional{
	[devotional deleteWithDatabase:connection];
}
@end
