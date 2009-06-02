//
//  process.m
//  plist
//
//  Created by 藤川 宏之 on 08/08/18.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "process.h"

@implementation process

-(id)initWithKInfo:(struct kinfo_proc*)proc {
	memcpy(&data, proc, sizeof(struct kinfo_proc));
	return self;
}

-(NSString*)name{
	return [NSString stringWithCString: data.kp_proc.p_comm];
}

-(struct extern_proc*)kp_proc{
	return &(data.kp_proc);
}

-(struct eproc*)kp_eproc{
	return &(data.kp_eproc);
}

-(NSString*)cellName{
	char *pstat;
	switch(data.kp_proc.p_stat){
		case SIDL : pstat = "[idle]"; break;
		case SRUN : pstat = ""; break;
		case SSLEEP : pstat = "[sleep]"; break;
		case SSTOP : pstat = "[stop]"; break;
		case SZOMB : pstat = "[zombie]"; break;
		default : pstat = "";
	}
	return [NSString stringWithFormat: @"%s%s", pstat, data.kp_proc.p_comm];
}

@end
