//
//  process.h
//  plist
//
//  Created by 藤川 宏之 on 08/08/18.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/sysctl.h>


@interface process : NSObject {
	struct kinfo_proc data;
}

-(id)initWithKInfo:(struct kinfo_proc*)proc;
-(NSString*)name;
-(NSString*)cellName;
-(struct extern_proc*)kp_proc;
-(struct eproc*)kp_eproc;

@end
