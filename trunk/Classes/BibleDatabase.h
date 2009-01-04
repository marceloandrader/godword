//
//  BibleDatabase.h
//  GodWord
//
//  Created by Marcelo Andrade on 7/20/08.
//  Copyright 2008 Casa. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class Book;
@class Bookmark;
@class Verse;
@class BookmarkFolder;
@class Devotional;

@interface BibleDatabase : NSObject {
	sqlite3 *connection;
	NSMutableArray *booksFromOld;
	NSMutableArray *booksFromNew;
	NSMutableArray *bookmarkFolders;
	NSMutableArray *devotionals;
    NSString *bibleName;
}

@property (nonatomic, retain) NSMutableArray *booksFromOld;
@property (nonatomic, retain) NSMutableArray *booksFromNew;
@property (nonatomic, retain) NSMutableArray *bookmarkFolders;
@property (nonatomic, retain) NSMutableArray *devotionals;
@property (nonatomic, retain) NSString *bibleName;

- (void) createEditableCopyOfDatabaseIfNeeded ;

- (void) initializeDatabase;

- (void) initializeBookmarkFolders;

- (int) obtainNumVersesInBook:(Book *) book 
					inChapter:(int) chapter;

- (NSString*) obtainTextVerseInBook:(Book *) book 
					inChapter:(int) chapter 
					  inVerse:(int) verse;

- (void) saveBookmark:(Bookmark *) bookmark; 

- (void) refreshVerseId:(Verse*) verse;

- (void) refreshVerseFromVerseId:(NSInteger) verseId verse:(Verse *) verse;

- (void) deleteBookmark:(Bookmark*) bookmark;

- (void) insertFolder:(BookmarkFolder *)folder;

- (void) deleteFolder:(BookmarkFolder *)folder;

- (void) updateFolder:(BookmarkFolder *)folder;

- (void) initializeDevotionals;

- (void) saveDevotional:(Devotional *) devotional; 

- (NSString*) obtainVerseNumber:(Verse*) verseSelected;

- (NSString*) obtainVerseText:(Verse *) verseSelected;

- (void) deleteDevotional:(Devotional *)devotional;
@end
