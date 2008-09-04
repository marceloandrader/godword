//
//  GodWordAppDelegate.m
//  GodWord
//
//  Created by Marcelo Andrade on 7/20/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import "GodWordAppDelegate.h"
#import "BibleDatabase.h"
#import "Book.h"
#import "Verse.h"
#import "FindVerseController.h"
#import "ReadChapterController.h"
#import "BookmarkListController.h"
#import "BookmarkFolder.h"
#import "Devotional.h"
#import "Bookmark.h"


@implementation GodWordAppDelegate

@synthesize window, tabBarController, bible, verseSelected;

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	BibleDatabase *db = [[BibleDatabase alloc] init];
	self.bible = db;
	[db release];
	[bible createEditableCopyOfDatabaseIfNeeded];
	[bible initializeDatabase];
	[bible initializeBookmarkFolders];
	[bible initializeDevotionals];
	Verse *verse = [[[Verse alloc] init] retain];
	//cambiar cuando se guarde donde se quedo

	NSInteger verseId  = [[NSUserDefaults standardUserDefaults] integerForKey:@"verseId"];
	NSInteger tabSelected  = [[NSUserDefaults standardUserDefaults] integerForKey:@"tabSelected"];
	[bible refreshVerseFromVerseId:verseId verse:verse];
	self.tabBarController.selectedIndex = tabSelected;
	verseSelected = verse;
	[verse release];
	
	[window addSubview: tabBarController.view];
	[window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	
	// save the drill-down hierarchy of selections to preferences
	[self.bible refreshVerseId:self.verseSelected];
	[[NSUserDefaults standardUserDefaults] setInteger:self.verseSelected.verseId forKey:@"verseId"];
	[[NSUserDefaults standardUserDefaults] setInteger:self.tabBarController.selectedIndex  forKey:@"tabSelected"];

    [Book finalizeStatements];
	[Verse finalizeStatements];
	[BookmarkFolder finalizeStatements];
	[Bookmark finalizeStatements];
	[Devotional finalizeStatements];
}	

- (void)dealloc {
	[bible release];
	[tabBarController release];
	[window release];
	[super dealloc];
}


@end
