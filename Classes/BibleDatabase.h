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

@interface BibleDatabase : NSObject {
	sqlite3 *connection;
	NSMutableArray *booksFromOld;
	NSMutableArray *booksFromNew;
}

@property (nonatomic, retain) NSMutableArray *booksFromOld;
@property (nonatomic, retain) NSMutableArray *booksFromNew;

- (void) createEditableCopyOfDatabaseIfNeeded ;

- (void) initializeDatabase;

- (int) obtainNumVersesInBook:(Book *) book 
					inChapter:(int) chapter;

- (NSString*) obtainTextVerseInBook:(Book *) book 
					inChapter:(int) chapter 
					  inVerse:(int) verse;

@end