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

@synthesize booksFromOld, booksFromNew, bookmarkFolders, devotionals, bibleName, versesFound, page;

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
    // TODO si el número de capítulos lo ponemos en la tabla books esto se reduce 10 veces.
    if (sqlite3_open([path UTF8String], &connection) == SQLITE_OK) {
		const char *sql = "select id,name,testament, (select max(chapter_no) from verses v where v.book_id = b.id) from books b ";
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

- (void) searchWord:(NSString*) word {
    double initTime, endTime;
    initTime = [[[NSDate alloc] init] timeIntervalSince1970] ;

    if (self.versesFound == nil) {     
        NSMutableArray *versesArray = [[NSMutableArray alloc] init];
        self.versesFound = versesArray;
        [versesArray release];
    } else {
        [self.versesFound removeAllObjects];
    }
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:self.bibleName];
    if (sqlite3_open([path UTF8String], &connection) == SQLITE_OK) {
        NSString * buscar = [[NSString alloc] initWithFormat:@" %@ ", word];
        buscar = [[buscar stringByReplacingOccurrencesOfString:@" " withString:@"%%"] lowercaseString];
        
		const char *sql = "select v.id from verses v where v.verse like ? LIMIT ? OFFSET ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(connection, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [buscar UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statement, 2, PAGE_FOUND_SIZE);
            sqlite3_bind_int(statement, 3, (page * PAGE_FOUND_SIZE));
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSInteger verseId = sqlite3_column_int(statement, 0);
				Verse *verse = [[Verse alloc] init];
                verse.verseId = verseId;
                
                [verse obtainVerseFromVerseId:verseId withConnection:connection];
				
				[versesFound addObject:verse];
				
                [verse release];
            }
        }
        sqlite3_finalize(statement);
    } else {
        sqlite3_close(connection);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(connection));
    }
    
    endTime = [[[NSDate alloc] init] timeIntervalSince1970] ;
    NSLog(@"searchWord time %f ", (endTime-initTime));   
    
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

- (void) setUpChaptersTable
{
    sqlite3_stmt *chapters = nil;
    static char *sql = "create table chapters(num integer primary key, book_id text, chapter_no text);";
    if (sqlite3_prepare_v2(connection, sql, -1, &chapters, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(connection));
    }
    if (sqlite3_step(chapters) == SQLITE_DONE)
    {
        sqlite3_stmt *inserts = nil;
        static char *sql1 = "insert into chapters (book_id, chapter_no) select distinct book_id, chapter_no from verses order by book_id, chapter_no;";
        if (sqlite3_prepare_v2(connection, sql1, -1, &inserts, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(connection));
        }
        if (sqlite3_step(inserts) == SQLITE_DONE)
        {
            NSLog(@"table chapters inserted");
        }
        sqlite3_reset(inserts);
        sqlite3_finalize(inserts);
    }   
    sqlite3_reset(chapters);
    sqlite3_finalize(chapters);
}

- (NSInteger) obtainNextChapterFromVerse:(Verse*) verse 
{
    int verseId=0;
    sqlite3_stmt *obtainNextChapter = nil;
    static char *sql = "select num,  (select max(num) from chapters) total from chapters where book_id = ? and chapter_no = ?";    
    if (sqlite3_prepare_v2(connection, sql, -1, &obtainNextChapter, NULL) != SQLITE_OK) {
        [self setUpChaptersTable];
        if (sqlite3_prepare_v2(connection, sql, -1, &obtainNextChapter, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(connection));
        }
    }

    
    Book* book ;
	if (verse.testament == 0 )
		book = (Book*) [self.booksFromOld 
						objectAtIndex: verse.bookNumber];
	else
		book = (Book*) [self.booksFromNew 
						objectAtIndex: verse.bookNumber];
	
	sqlite3_bind_text(obtainNextChapter, 1, [book.pk UTF8String], -1 , SQLITE_TRANSIENT);
    sqlite3_bind_int(obtainNextChapter, 2, verse.chapterNumber);
	
	int success = sqlite3_step(obtainNextChapter);
	int chapter_id = 0;
	int total = 0;
	if (success == SQLITE_ROW) 
	{
        chapter_id = sqlite3_column_int(obtainNextChapter, 0);
        total = sqlite3_column_int(obtainNextChapter, 1);
        if (chapter_id == total){
            chapter_id = 1;
        }else{
            chapter_id += 1;
        }
        
        sqlite3_stmt *obtainNextVerse = nil;
        static char *sqlVerse = "select id from verses v, chapters c where c.chapter_no = v.chapter_no and c.book_id = v.book_id and c.num = ? LIMIT 1";    
        if (sqlite3_prepare_v2(connection, sqlVerse, -1, &obtainNextVerse, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(connection));
        }
        
        sqlite3_bind_int(obtainNextVerse, 1, chapter_id);
        
        int success1 = sqlite3_step(obtainNextVerse);
        if (success1 == SQLITE_ROW)
        {
            verseId = sqlite3_column_int(obtainNextVerse, 0);
        }
        sqlite3_reset(obtainNextVerse);
        sqlite3_finalize(obtainNextVerse);
	}
	sqlite3_reset(obtainNextChapter);
    sqlite3_finalize(obtainNextChapter);
    
    return verseId ;
}

- (NSInteger) obtainPreviousChapterFromVerse:(Verse*) verse 
{
    int verseId=0;
    sqlite3_stmt *obtainPreviousChapter = nil;
    static char *sql = "select num,  (select max(num) from chapters) total from chapters where book_id = ? and chapter_no = ?";    
    if (sqlite3_prepare_v2(connection, sql, -1, &obtainPreviousChapter, NULL) != SQLITE_OK) {
        [self setUpChaptersTable];
        if (sqlite3_prepare_v2(connection, sql, -1, &obtainPreviousChapter, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(connection));
        }
    }    
    
    Book* book ;
	if (verse.testament == 0 )
		book = (Book*) [self.booksFromOld 
						objectAtIndex: verse.bookNumber];
	else
		book = (Book*) [self.booksFromNew 
						objectAtIndex: verse.bookNumber];
	
	sqlite3_bind_text(obtainPreviousChapter, 1, [book.pk UTF8String], -1 , SQLITE_TRANSIENT);
    sqlite3_bind_int(obtainPreviousChapter, 2, verse.chapterNumber);
	
	int success = sqlite3_step(obtainPreviousChapter);
	int chapter_id = 0;
	int total = 0;
	if (success == SQLITE_ROW) 
	{
        chapter_id = sqlite3_column_int(obtainPreviousChapter, 0);
        total = sqlite3_column_int(obtainPreviousChapter, 1);
        if (chapter_id == 1){
            chapter_id = total;
        }else{
            chapter_id -= 1;
        }
        
        sqlite3_stmt *obtainNextVerse = nil;
        static char *sqlVerse = "select id from verses v, chapters c where c.chapter_no = v.chapter_no and c.book_id = v.book_id and c.num = ? LIMIT 1";    
        if (sqlite3_prepare_v2(connection, sqlVerse, -1, &obtainNextVerse, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(connection));
        }
        
        sqlite3_bind_int(obtainNextVerse, 1, chapter_id);
        
        int success1 = sqlite3_step(obtainNextVerse);
        if (success1 == SQLITE_ROW)
        {
            verseId = sqlite3_column_int(obtainNextVerse, 0);
        }
        sqlite3_reset(obtainNextVerse);
        sqlite3_finalize(obtainNextVerse);
	}
	sqlite3_reset(obtainPreviousChapter);
    sqlite3_finalize(obtainPreviousChapter);
    
    return verseId ;
}


- (void) deleteDevotional:(Devotional *)devotional{
	[devotional deleteWithDatabase:connection];
}

- (void)dealloc {
    [booksFromOld release];
	[booksFromNew release];
	[bookmarkFolders release];
	[devotionals release];
    [versesFound release];
    [bibleName release];
    
	[super dealloc];
}


@end
