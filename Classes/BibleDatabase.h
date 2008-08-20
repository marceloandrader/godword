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

@interface BibleDatabase : NSObject {
	sqlite3 *connection;
	NSMutableArray *booksFromOld;
	NSMutableArray *booksFromNew;
	NSMutableArray *bookmarkFolders;
}

@property (nonatomic, retain) NSMutableArray *booksFromOld;
@property (nonatomic, retain) NSMutableArray *booksFromNew;
@property (nonatomic, retain) NSMutableArray *bookmarkFolders;

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

@end
