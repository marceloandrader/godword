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

@implementation GodWordAppDelegate

@synthesize window, tabBarController, bible, verseSelected;

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	BibleDatabase *db = [[BibleDatabase alloc] init];
	self.bible = db;
	[db release];
	[bible createEditableCopyOfDatabaseIfNeeded];
	[bible initializeDatabase];
	Verse *verse = [[[Verse alloc] init] retain];
	verseSelected = verse;
	[verse release];
	[window addSubview: [tabBarController view]];
	[window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [Book finalizeStatements];
}	

- (void)dealloc {
	[bible release];
	[tabBarController release];
	[window release];
	[super dealloc];
}


@end
