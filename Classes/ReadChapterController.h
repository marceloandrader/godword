//
//  ReadChapterController.h
//  GodWord
//
//  Created by Marcelo Andrade on 7/20/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEIGHT_ONE_ROW 21
#define NUM_CHARACTERS_BY_LINE 44

@interface ReadChapterController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
	IBOutlet UITableView *table;
	NSInteger rowTapped;
    bool toolBarVisible;
}

@property (nonatomic, retain) UITableView *table;
@property (nonatomic, assign) NSInteger rowTapped;
@property (nonatomic, assign) bool toolBarVisible;

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
- (float) heightForLength:(int) length ;
- (void) dismiss;
- (IBAction) previousChapter: (id) sender;
- (IBAction) nextChapter: (id) sender;
- (IBAction) changeDarkView: (id) sender;
@end
