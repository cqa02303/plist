//
//  plistAppDelegate.h
//  plist
//
//  Created by 藤川 宏之 on 08/08/17.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "System.h"

@interface plistAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet UINavigationController *navigationController;
	NSMutableArray *procs;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) NSMutableArray *procs;

-(void)getBSDProcessList;
-(System*)getBSDSystemResource;
-(void)setBSDMemoryResource: (System*)systemResource;
- (void)getNetworkInterfaceResource;

@end

