//
//  RootViewController.h
//  plist
//
//  Created by 藤川 宏之 on 08/08/17.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "procViewController.h"
#import "systemViewController.h"
#import "AboutViewController.h"

@interface RootViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tableView;
	procViewController *procView;
	systemViewController *systemView;
	AboutViewController *aboutView;
}

-(void)info: (id)sender;

@end
