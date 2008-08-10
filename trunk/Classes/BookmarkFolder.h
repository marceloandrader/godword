//
//  BookmarkFolder.h
//  GodWord
//
//  Created by Marcelo Andrade on 8/9/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BookmarkFolder : NSObject {
	NSInteger pk;
	NSString *title;
}

@property(assign, nonatomic) NSInteger pk;
@property(copy, nonatomic) NSString *title;

- (id) initWithPrimaryKey: (NSInteger)  primaryKey 
					title: (NSString *) folderTitle ;
+ (void) finalizeStatements;

@end
