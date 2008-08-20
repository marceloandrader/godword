//
//  BookmarkFolder.m
//  GodWord
//
//  Created by Marcelo Andrade on 8/9/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "BookmarkFolder.h"
#import "Bookmark.h"
#import <sqlite3.h>

static sqlite3_stmt *obtainBookmarks = nil;

@implementation BookmarkFolder

@synthesize pk, title, bookmarks;

- (id) initWithPrimaryKey: (NSInteger)  primaryKey 
					title: (NSString *) folderTitle 
{
	if ( self = [super init] ) {		
		self.pk = primaryKey;
		self.title = folderTitle;
	}
	return self;
}

- (void) refreshBookmarksWithDatabase:(sqlite3 *) connection{
	NSMutableArray *bookmarkArray = [[NSMutableArray alloc] init];
    self.bookmarks = bookmarkArray;
    [bookmarkArray release];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"bible.db"];
    if (sqlite3_open([path UTF8String], &connection) == SQLITE_OK) {
		const char *sql = "select b.id, b.description, b.verse_id, v.chapter_no, v.verse_no, bo.name from bookmarks b, verses v, books bo where b.verse_id = v.id and bo.id = v.book_id and folder_id = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(connection, sql, -1, &statement, NULL) == SQLITE_OK) {
			sqlite3_bind_int(statement, 1, self.pk);
            while (sqlite3_step(statement) == SQLITE_ROW) {
				NSInteger idBookmark = sqlite3_column_int(statement, 0);
				NSString *description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				NSInteger verseId = sqlite3_column_int(statement, 2);
				NSInteger chapter = sqlite3_column_int(statement, 3);
				NSInteger verse = sqlite3_column_int(statement, 4);
				NSString *bookName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
				
				NSString * verseNo = [[NSString alloc] initWithFormat:@"%@ %d:%d", bookName, chapter, verse];
				
				Bookmark *bookmark = [[Bookmark alloc] initWithPrimaryKey:idBookmark description:description verse:verseId folder:self.pk verseNo:verseNo];
				[bookmarks addObject:bookmark];
                [bookmark release];
            }
        }
        sqlite3_finalize(statement);
    } else {
        sqlite3_close(connection);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(connection));
    }
	
}


+ (void) finalizeStatements {
    if (obtainBookmarks) sqlite3_finalize(obtainBookmarks);
}

@end
