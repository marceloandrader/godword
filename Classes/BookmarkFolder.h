//
//  BookmarkFolder.h
//  GodWord
//
//  Created by Marcelo Andrade on 8/9/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface BookmarkFolder : NSObject {
	NSInteger pk;
	NSString *title;
	NSMutableArray *bookmarks;
}

@property(assign, nonatomic) NSInteger pk;
@property(copy, nonatomic) NSString *title;
@property(nonatomic,retain) NSMutableArray *bookmarks;

- (id) initWithPrimaryKey: (NSInteger)  primaryKey 
					title: (NSString *) folderTitle ;

- (void) refreshBookmarksWithDatabase:(sqlite3 *) connection;

+ (void) finalizeStatements;


@end
