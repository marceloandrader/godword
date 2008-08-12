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
}

@property(assign, nonatomic) NSInteger pk;
@property(copy, nonatomic) NSString *description;
@property(assign, nonatomic) NSInteger folder;
@property(assign, nonatomic) NSInteger verse;

- (id) initWithPrimaryKey: (NSInteger)  primaryKey 
			  description: (NSString *) bookmarkDescription 
					verse: (NSInteger) verseId
				   folder: (NSInteger) bookmarkFolder;

- (void) saveWithDatabase: (sqlite3 *) database ;

+ (void) finalizeStatements;

@end
