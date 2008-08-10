//
//  GodWordAppDelegate.h
//  GodWord
//
//  Created by Marcelo Andrade on 7/20/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BibleDatabase;
@class Verse;

@interface GodWordAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet UITabBarController *tabBarController;
	BibleDatabase *bible;
	Verse *verseSelected;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) BibleDatabase *bible;
@property (nonatomic, retain) Verse * verseSelected;

@end
