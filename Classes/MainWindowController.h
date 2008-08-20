//
//  MainWindowController.h
//  GodWord
//
//  Created by Marcelo Andrade on 7/20/08.
//  Copyright 2008 Casa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainWindowController : UIViewController <UITabBarDelegate>{

}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item;

@end
