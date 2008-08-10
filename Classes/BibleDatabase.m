//
//  BibleDatabase.m
//  GodWord
//
//  Created by Marcelo Andrade on 7/20/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "BibleDatabase.h"
#import "Book.h"



@implementation BibleDatabase

@synthesize booksFromOld, booksFromNew;

- (void)createEditableCopyOfDatabaseIfNeeded {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"bible.db"];
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
							   stringByAppendingPathComponent:@"bible.db"];
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
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"bible.db"];
    if (sqlite3_open([path UTF8String], &connection) == SQLITE_OK) {
//        const char *sql = "SELECT id, name, testament FROM books";
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


- (int) obtainNumVersesInBook:(Book *) book inChapter:(int) chapter
{
	return [book obtainNumVersesInChapter:chapter connection:connection];
}

- (NSString*) obtainTextVerseInBook:(Book *) book inChapter:(int) chapter inVerse:(int) verse
{
	return [book obtainVerseTextWithChapter:chapter verseNumber:verse connection:connection];
}


@end
