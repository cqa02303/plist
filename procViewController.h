#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "process.h"

@interface procViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	process *proc;
	IBOutlet UITableView *tableView;
	NSIndexPath *selectedIndexPath;
	UISegmentedControl *segment;
}

@property (nonatomic, retain) process *proc;
@property (nonatomic, retain) UISegmentedControl *segment;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;

@end
