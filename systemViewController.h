#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "system.h"

@interface systemViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	System *sys;
    IBOutlet UITableView *tableView;
}

@property (nonatomic, retain) System *sys;
@end
