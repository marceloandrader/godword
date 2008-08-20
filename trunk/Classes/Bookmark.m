//
//  Bookmark.m
//  GodWord
//
//  Created by Marcelo Andrade on 8/11/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "Bookmark.h"
#import <sqlite3.h>

static sqlite3_stmt *insertBookmark = nil;


@implementation Bookmark

@synthesize pk, description, verse, folder,verseNo;

- (id) initWithPrimaryKey: (NSInteger)  primaryKey 
			  description: (NSString *) bookmarkDescription 
					verse: (NSInteger) verseId
				   folder: (NSInteger) bookmarkFolder
				  verseNo: (NSString*) verseName
{
	if ( self = [super init] ) {		
		self.pk = primaryKey;
		self.description = bookmarkDescription;
		self.verse = verseId;
		self.folder = bookmarkFolder;
		self.verseNo = verseName;
	}
	return self;
}


- (void) saveWithDatabase: (sqlite3 *) database {
	if (insertBookmark == nil) {
		static char *sql = "INSERT INTO bookmarks (description, verse_id, folder_id) VALUES(?, ?, ?) ";
		if (sqlite3_prepare_v2(database, sql, -1, &insertBookmark, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_text(insertBookmark, 1, [self.description UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(insertBookmark, 2, self.verse);
	sqlite3_bind_int(insertBookmark, 3, self.folder);
	
	int success = sqlite3_step(insertBookmark);
	sqlite3_reset(insertBookmark);
	if (success != SQLITE_ERROR) {
		self.pk = sqlite3_last_insert_rowid(database);
	}
	else
	{
		NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
		self.pk = -1;
	}
}

+ (void) finalizeStatements {
    if (insertBookmark) sqlite3_finalize(insertBookmark);
}


@end
