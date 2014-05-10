//
//  MainTableViewController.h
//  FontsToPlist
//
//  Created by Ibrahim Qraiqe on 10/05/14.
//  Copyright (c) 2014 Ibrahim Qraiqe. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface MainTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@end
