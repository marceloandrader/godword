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
    NSString *langSelected = [[NSUserDefaults standardUserDefaults] stringForKey:@"app_language"];
    if (langSelected == nil){
        NSString *localization = NSLocalizedString(@"bible.db",@"bible_en.db");
        langSelected = [localization substringWithRange:NSMakeRange (6,2)];
    }
	NSString *name = [[NSString alloc] initWithFormat:@"bible_%@.db", langSelected];
    
	BibleDatabase *db = [[BibleDatabase alloc] init];
	self.bible = db;
    self.bible.bibleName = name;
	[db release];
    
    
    double initTime, endTime;
    initTime = [[[NSDate alloc] init] timeIntervalSince1970] ;
	[bible createEditableCopyOfDatabaseIfNeeded];
    endTime = [[[NSDate alloc] init] timeIntervalSince1970] ;
    NSLog(@"createEditableCopyOfDatabaseIfNeeded time %f ", (endTime-initTime));

    initTime = [[[NSDate alloc] init] timeIntervalSince1970] ;
	[bible initializeDatabase];
    endTime = [[[NSDate alloc] init] timeIntervalSince1970] ;
    NSLog(@"initializeDatabase time %f ", (endTime-initTime));
    
    initTime = [[[NSDate alloc] init] timeIntervalSince1970] ;
	[bible initializeBookmarkFolders];
    endTime = [[[NSDate alloc] init] timeIntervalSince1970] ;
    NSLog(@"initializeBookmarkFolders time %f ", (endTime-initTime));

    initTime = [[[NSDate alloc] init] timeIntervalSince1970] ;
	[bible initializeDevotionals];
    endTime = [[[NSDate alloc] init] timeIntervalSince1970] ;
    NSLog(@"initializeDevotionals time %f ", (endTime-initTime));

    
    NSInteger verseId  = [[NSUserDefaults standardUserDefaults] integerForKey:@"verseId"];
	NSInteger tabSelected  = [[NSUserDefaults standardUserDefaults] integerForKey:@"tabSelected"];
    
	Verse *verse = [[[Verse alloc] init] retain];
	
	if (verseId==0) {
		if ([self.bible.bibleName isEqual:@"bible_fr.db"])
			verseId = 262070;
		else
			verseId = 261370;
	}
	[bible refreshVerseFromVerseId:verseId verse:verse];
	tabBarController.selectedIndex = tabSelected;
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
