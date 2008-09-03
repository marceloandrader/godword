//
//  Devotional.m
//  GodWord
//
//  Created by Marcelo Andrade on 8/26/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "Devotional.h"
#import <sqlite3.h>

static sqlite3_stmt *insertDevotional = nil;
static sqlite3_stmt *updateDevotional = nil;
static sqlite3_stmt *deleteDevotional = nil;

@implementation Devotional

@synthesize pk, title, questionOne, questionTwo, verse, verseNo, date;

- (void) addWithDatabase: (sqlite3 *) database {
	if (insertDevotional == nil) {
		static char *sql = "INSERT INTO devotionals (title, questionOne, questionTwo, verse_id, devotional_date) VALUES(?, ?, ?, ?, ?) ";
		if (sqlite3_prepare_v2(database, sql, -1, &insertDevotional, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_text(insertDevotional, 1, [self.title UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(insertDevotional, 2, [self.questionOne UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(insertDevotional, 3, [self.questionTwo UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(insertDevotional, 4, self.verse);
	sqlite3_bind_double(insertDevotional, 5, [self.date timeIntervalSince1970]);
	
	int success = sqlite3_step(insertDevotional);
	sqlite3_reset(insertDevotional);
	if (success != SQLITE_ERROR) {
		self.pk = sqlite3_last_insert_rowid(database);
	}
	else
	{
		NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
		self.pk = -1;
	}
}

- (void) saveWithDatabase: (sqlite3 *) database {
	if (updateDevotional == nil) {
		static char *sql = "UPDATE devotionals SET title = ?, questionOne = ?, questionTwo = ?, verse_id = ?, devotional_date = ? WHERE devotional_id  = ?";
		if (sqlite3_prepare_v2(database, sql, -1, &updateDevotional, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_text(updateDevotional, 1, [self.title UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(updateDevotional, 2, [self.questionOne UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(updateDevotional, 3, [self.questionTwo UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(updateDevotional, 4, self.verse);
	sqlite3_bind_double(updateDevotional, 5, [self.date timeIntervalSince1970]);
	sqlite3_bind_int(updateDevotional, 6, self.pk);
	
	int success = sqlite3_step(updateDevotional);
	sqlite3_reset(updateDevotional);
	if (success != SQLITE_ERROR) {
		self.pk = 0;
	}
	else
	{
		NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
		self.pk = -1;
	}
}

- (void) deleteWithDatabase: (sqlite3 *) database {
	if (deleteDevotional == nil) {
		static char *sql = "DELETE FROM devotionals WHERE devotional_id = ? ";
		if (sqlite3_prepare_v2(database, sql, -1, &deleteDevotional, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_int(deleteDevotional, 1, self.pk);
	
	int success = sqlite3_step(deleteDevotional);
	sqlite3_reset(deleteDevotional);
	if (success == SQLITE_ERROR) {
		NSAssert1(0, @"Error: failed to delete into the database with message '%s'.", sqlite3_errmsg(database));
		self.pk = -1;
	}
}



+ (void) finalizeStatements {
    if (insertDevotional) sqlite3_finalize(insertDevotional);
	if (updateDevotional) sqlite3_finalize(updateDevotional);
	if (deleteDevotional) sqlite3_finalize(deleteDevotional);
}

@end
