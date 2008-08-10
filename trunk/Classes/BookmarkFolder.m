//
//  BookmarkFolder.m
//  GodWord
//
//  Created by Marcelo Andrade on 8/9/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "BookmarkFolder.h"
#import <sqlite3.h>

static sqlite3_stmt *obtainBookmarks = nil;

@implementation BookmarkFolder

@synthesize pk, title;

- (id) initWithPrimaryKey: (NSInteger)  primaryKey 
					title: (NSString *) folderTitle 
{
	if ( self = [super init] ) {		
		self.pk = primaryKey;
		self.title = folderTitle;
	}
	return self;
}



+ (void) finalizeStatements {
    if (obtainBookmarks) sqlite3_finalize(obtainBookmarks);
}

@end
