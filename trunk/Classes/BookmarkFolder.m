//
//  BookmarkFolder.m
//  GodWord
//
//  Created by Marcelo Andrade on 8/9/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "BookmarkFolder.h"
#import "Bookmark.h"
#import "GodWordAppDelegate.h"
#import "BibleDatabase.h"
#import <sqlite3.h>

static sqlite3_stmt *obtainBookmarks = nil;
static sqlite3_stmt *insertFolder = nil;
static sqlite3_stmt *updateFolder = nil;
static sqlite3_stmt *deleteFolder = nil;

@implementation BookmarkFolder

@synthesize pk, title, bookmarks;

- (id) initWithPrimaryKey: (NSInteger)  primaryKey 
					title: (NSString *) folderTitle 
{
	if ( self = [super init] ) {		
		self.pk = primaryKey;
		self.title = folderTitle;
		NSMutableArray *bookmarkArray = [[NSMutableArray alloc] init];
		self.bookmarks = bookmarkArray;
		[bookmarkArray release];
	}
	return self;
}

- (void) refreshBookmarksWithDatabase:(sqlite3 *) connection{
	NSMutableArray *bookmarkArray = [[NSMutableArray alloc] init];
    self.bookmarks = bookmarkArray;
    [bookmarkArray release];
    
    GodWordAppDelegate *appDelegate = (GodWordAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:appDelegate.bible.bibleName];
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

- (void) insertWithDatabase: (sqlite3 *) database {
	if (insertFolder == nil) {
		static char *sql = "INSERT INTO folders (title) VALUES(?) ";
		if (sqlite3_prepare_v2(database, sql, -1, &insertFolder, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_text(insertFolder, 1, [self.title UTF8String], -1, SQLITE_TRANSIENT);
	
	int success = sqlite3_step(insertFolder);
	sqlite3_reset(insertFolder);
	if (success != SQLITE_ERROR) {
		self.pk = sqlite3_last_insert_rowid(database);
	}
	else
	{
		NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
		self.pk = -1;
	}
}

- (void) deleteWithDatabase: (sqlite3 *) database {
	if (deleteFolder == nil) {
		static char *sql = "DELETE FROM folders WHERE folder_id = ? ";
		if (sqlite3_prepare_v2(database, sql, -1, &deleteFolder, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_int(deleteFolder, 1, self.pk);
	
	int success = sqlite3_step(deleteFolder);
	sqlite3_reset(deleteFolder);
	if (success != SQLITE_ERROR) {
		self.pk = 0;
	}
	else
	{
		NSAssert1(0, @"Error: failed to delete into the database with message '%s'.", sqlite3_errmsg(database));
		self.pk = -1;
	}
}

- (void) updateWithDatabase: (sqlite3 *) database {
	if (updateFolder == nil) {
		static char *sql = "UPDATE folders set title = ? where folder_id = ? ";
		if (sqlite3_prepare_v2(database, sql, -1, &updateFolder, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_text(updateFolder, 1, [self.title UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(updateFolder, 2, self.pk);
	
	int success = sqlite3_step(updateFolder);
	sqlite3_reset(updateFolder);
	if (success == SQLITE_ERROR) {
		NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
		self.pk = -1;
	}
}

+ (void) finalizeStatements {
	if (updateFolder) sqlite3_finalize(updateFolder);
	if (deleteFolder) sqlite3_finalize(deleteFolder);
	if (insertFolder) sqlite3_finalize(insertFolder);
    if (obtainBookmarks) sqlite3_finalize(obtainBookmarks);
}

@end
