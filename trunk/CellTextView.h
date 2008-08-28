//
//  CellTextView.h
//  GodWord
//
//  Created by Marcelo Andrade on 8/5/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>

// cell identifier for this custom cell
extern NSString *kCellTextView_ID;

@interface CellTextView : UITableViewCell
{
    UITextView *view;
}

@property (nonatomic, retain) UITextView *view;

@end
