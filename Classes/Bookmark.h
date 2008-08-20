//
//  Bookmark.h
//  GodWord
//
//  Created by Marcelo Andrade on 8/11/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface Bookmark : NSObject {
	NSString *description;
	NSInteger pk;
	NSInteger folder;
	NSInteger verse;
	NSString *verseNo;
}

@property(assign, nonatomic) NSInteger pk;
@property(copy, nonatomic) NSString *description;
@property(assign, nonatomic) NSInteger folder;
@property(assign, nonatomic) NSInteger verse;
@property(nonatomic,copy) NSString * verseNo;

- (id) initWithPrimaryKey: (NSInteger)  primaryKey 
			  description: (NSString *) bookmarkDescription 
					verse: (NSInteger) verseId
				   folder: (NSInteger) bookmarkFolder
				  verseNo: (NSString*) verseNo;

- (void) saveWithDatabase: (sqlite3 *) database ;

+ (void) finalizeStatements;

@end
