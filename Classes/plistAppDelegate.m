//
//  plistAppDelegate.m
//  plist
//
//  Created by 藤川 宏之 on 08/08/17.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "plistAppDelegate.h"
#import "RootViewController.h"
#import "process.h"
#import <assert.h>
#import <errno.h>
#import <stdbool.h>
#import <stdlib.h>
#import <stdio.h>
#import <sys/sysctl.h>
#import <sys/time.h>
#import <mach/host_info.h>
#import <mach/mach_init.h>
#import <mach/mach_host.h>
#import <SystemConfiguration/SystemConfiguration.h>


// Privateな関数の定義
@interface plistAppDelegate (Private)
@end

// 実装
@implementation plistAppDelegate

@synthesize procs;
@synthesize window;
@synthesize navigationController;


- (id)init {
	if (self = [super init]) {
		// 
	}
	return self;
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// データの取得
	[self getBSDProcessList];
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[procs release];
	[navigationController release];
	[window release];
	[super dealloc];
}

// システム上のすべての BSD プロセスのリストを返す
// NSMutableArray *procArrayにprocessクラスのリストとして構築します
-(void)getBSDProcessList {
    int                 err;
	// sysctlでプロセスの情報リストを要求する
    static const int    name[] = { CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0 };
    // name を const として宣言するので、sysctl に渡すときにキャストする必要がある
    // プロトタイプに const が含まれていないからだ
    size_t              length;
	int					count;
	NSMutableArray		*procArray = [[NSMutableArray alloc] init];
	
	self.procs = procArray;
	[procArray release];
	
	// sysctlでバッファのサイズを確認する
	length = 0;
	err = sysctl( (int *) name, (sizeof(name) / sizeof(*name)) - 1, NULL, &length, NULL, 0);
	if (err == -1) {
		err = errno;
	}
	
	// 上記の呼び出しの結果に基づき適切なサイズの
	// バッファを割り当てる
	//NSLog(@"sysctl length = %d", length);
	//NSLog(@"struct size = %d", sizeof(struct kinfo_proc));
	if (err == 0) {
		struct kinfo_proc	*procBuffer;
		procBuffer = malloc(length);
		if(procBuffer == NULL){
			return;
		}
		// この新しいバッファを使って sysctl を再び呼び出す
		// ENOMEM エラーを受け取った場合は、バッファを破棄しもう一度やり直す
		
		err = sysctl( (int *) name, (sizeof(name) / sizeof(*name)) - 1, procBuffer, &length, NULL, 0);
		if (err == -1) {
			//NSLog(@"error: %d", errno);
			err = errno;
		}
		if (err == 0) {
		} else if (err == ENOMEM) {
			//NSLog(@"error: ENOMEM");
			// result
			err = 0;
		}
		// 構造体を解析してプロセスリストを作る
		count = length / sizeof(struct kinfo_proc);
		for(int i = 0; i < count; i++){
			[procArray addObject:[[process alloc] initWithKInfo:&(procBuffer[i])]];
		}
		free(procBuffer);
	}
}

// システム上の情報を取得する
-(System*)getBSDSystemResource {
	// sysctl();を使い、カーネルの情報を取得する
    int			err;
	int			ret;
    int			name[3];
    size_t		length;
	System		*sys = [[System init] alloc];
	char		buff[1024];
	// sysctlでバッファのサイズを確認する
	length = 0;
	name[0] = CTL_HW;
	name[2] = 0;
	// MACHINE TYPE
	length = 1023;
	name[1] = HW_MACHINE;
	err = sysctl( (int *) name, 2, buff, &length, NULL, 0);
	if (err == 0) {
		sys.machine = [NSString stringWithCString:buff length:length];
		//NSLog(@" HW_MACHINE = %@", sys.machine);
	}
	// MODEL NAME
	length = 1023;
	name[1] = HW_MODEL;
	err = sysctl( (int *) name, 2, buff, &length, NULL, 0);
	if (err == 0) {
		sys.model = [NSString stringWithCString:buff length:length];
		//NSLog(@" HW_MODEL = %@", sys.model);
	}
	// NUMBER of CPU
	length = 4;
	name[1] = HW_NCPU;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		sys.ncpu = ret;
		//NSLog(@" HW_NCPU = %d", sys.ncpu);
	}
/*
	// Physical Memory size
	length = 4;
	name[1] = HW_PHYSMEM;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		sys.physmem = ret;
		//NSLog(@" HW_PHYSMEM = %d", sys.physmem);
	}else{
		//NSLog(@" err = %d / errno = %d", err, errno);
	}
	// User Memory size
	length = 4;
	name[1] = HW_USERMEM;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		sys.usermem = ret;
		//NSLog(@" HW_USERSMEM = %d", sys.usermem);
	}else{
		//NSLog(@" err = %d / errno = %d", err, errno);
	}
 */
	// Page size
	length = 4;
	name[1] = HW_PAGESIZE;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		sys.pagesize = ret;
		//NSLog(@" HW_PAGESIZE = %d", sys.pagesize);
	}
	// Floatingpoint
	length = 4;
	name[1] = HW_FLOATINGPT;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		sys.floatingpt = ret;
		//NSLog(@" HW_FLOATINGPT = %d", sys.floatingpt);
	}
	// Machine Architecture
	length = 1023;
	name[1] = HW_MACHINE_ARCH;
	err = sysctl( (int *) name, 2, buff, &length, NULL, 0);
	if (err == 0) {
		sys.arch = [NSString stringWithCString:buff length:length];
		//NSLog(@" HW_MACHINE_ARCH = %@", sys.arch);
	}
	// HW_VECTORUNIT
	length = 4;
	name[1] = HW_VECTORUNIT;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		sys.vectorunit = ret;
		//NSLog(@" HW_VECTORUNIT = %d", ret);
	}
	// HW_CPU_FREQ
	length = 4;
	name[1] = HW_CPU_FREQ;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		sys.cpu_freq = ret;
		//NSLog(@" HW_CPU_FREQ = %d", ret);
	}
	// HW_CACHELINE
	length = 4;
	name[1] = HW_CACHELINE;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		sys.cacheline = ret;
		//NSLog(@" HW_CACHELINE = %d", ret);
	}
	// HW_L1ICACHESIZE
	length = 4;
	name[1] = HW_L1ICACHESIZE;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		sys.l1icachesize = ret;
		//NSLog(@" HW_L1ICACHESIZE = %d", ret);
	}
	// HW_L1DCACHESIZE
	length = 4;
	name[1] = HW_L1DCACHESIZE;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		sys.l1dcachesize = ret;
		//NSLog(@" HW_L1DCACHESIZE = %d", ret);
	}
	// HW_L2SETTINGS
	length = 4;
	name[1] = HW_L2SETTINGS;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		sys.l2settings = ret;
		//NSLog(@" HW_L2SETTINGS = %d", ret);
	}
	// HW_L2CACHESIZE
	length = 4;
	name[1] = HW_L2CACHESIZE;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		sys.l2cachesize = ret;
		//NSLog(@" HW_L2CACHESIZE = %d", ret);
	}
	// HW_L3SETTINGS
	length = 4;
	name[1] = HW_L3SETTINGS;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		sys.l3settings = ret;
		//NSLog(@" HW_L3SETTINGS = %d", ret);
	}
	// HW_L3CACHESIZE
	length = 4;
	name[1] = HW_L3CACHESIZE;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		sys.l3cachesize = ret;
		//NSLog(@" HW_L3CACHESIZE = %d", ret);
	}
	// HW_BUS_FREQ
	length = 4;
	name[1] = HW_BUS_FREQ;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		sys.bus_freq = ret;
		//NSLog(@" HW_BUS_FREQ = %d", ret);
	}
	// HW_TB_FREQ
	length = 4;
	name[1] = HW_TB_FREQ;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		sys.tb_freq = ret;
		//NSLog(@" HW_TB_FREQ = %d", ret);
	}
	// HW_MEMSIZE uint_64t
	{
		uint64_t memsize;
		length = 8;
		name[1] = HW_MEMSIZE;
		err = sysctl( (int *) name, 2, &memsize, &length, NULL, 0);
		if (err == 0) {
			sys.memsize = memsize;
			//NSLog(@" HW_MEMSIZE = %d", memsize);
		}
	}
	
	
	// CTL_KERN Kernel info
	name[0] = CTL_KERN;
	// HOSTID
/*
	length = 4;
	name[1] = KERN_HOSTID;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		NSLog(@"KERN_HOSTID: %d", ret);
	}
 */
/*
 // HOSTNAME
	length = 1023;
	name[1] = KERN_HOSTNAME;
	memset(buff, 0, length);
	err = sysctl( (int *) name, 2, buff, &length, NULL, 0);
	if (err == 0) {
		sys.hostname = [NSString stringWithCString:buff length:length];
		//NSLog(@"KERN_HOSTNAME: %s(%d)", sys.hostname, length);
	}
 */
	// Kernel OS Release
	length = 1023;
	name[1] = KERN_OSRELEASE;
	err = sysctl( (int *) name, 2, buff, &length, NULL, 0);
	if (err == 0) {
		sys.osrel = [NSString stringWithCString:buff length:length];
		//NSLog(@"KERN_OSRELEASE: %s", sys.osrel);
	}
	// Kernel OS Revision
	length = 1023;
	name[1] = KERN_OSREV;
	err = sysctl( (int *) name, 2, buff, &length, NULL, 0);
	if (err == 0) {
		sys.osrev = [NSString stringWithCString:buff length:length];
		//NSLog(@"KERN_OSREV: %s", sys.osrev);
	}
	// Kernel OS Revision
	length = 1023;
	name[1] = KERN_OSTYPE;
	err = sysctl( (int *) name, 2, buff, &length, NULL, 0);
	if (err == 0) {
		sys.ostype = [NSString stringWithCString:buff length:length];
		//NSLog(@"KERN_OSTYPE: %s", sys.ostype);
	}
	// Kernel Version
	length = 1023;
	name[1] = KERN_VERSION;
	err = sysctl( (int *) name, 2, buff, &length, NULL, 0);
	if (err == 0) {
		sys.kernelver = [NSString stringWithCString:buff length:length];
		//NSLog(@"KERN_VERSION: %s", sys.kernelver);
	}
	// clockinfo
/*
	{
		struct clockinfo clk;
		length = sizeof(struct clockinfo);
		name[1] = KERN_CLOCKRATE;
		err = sysctl( (int *) name, 2, &clk, &length, NULL, 0);
		if (err == 0) {
			NSLog(@"KERN_CLOCKRATE: %d hz %d tick %d tickadj %d stathz %d profhz", clk.hz, clk.tick, clk.tickadj, clk.stathz, clk.profhz);
		}
	}
 */
	// loadavg
	{
		struct loadavg avg;
		length = sizeof(struct loadavg);
		name[0] = CTL_VM;
		name[1] = VM_LOADAVG;
		err = sysctl( (int *) name, 2, &avg, &length, NULL, 0);
		if (err == 0) {
			sys.ldavg = [NSString stringWithFormat: @"%0.2f   %0.2f   %0.2f", (float)avg.ldavg[0] / (float)avg.fscale, (float)avg.ldavg[1] / (float)avg.fscale, (float)avg.ldavg[2] / (float)avg.fscale];
			//NSLog(@"VM_LOADAVG: %0.2f %0.2f %0.2f", (float)avg.ldavg[0] / (float)avg.fscale, (float)avg.ldavg[1] / (float)avg.fscale, (float)avg.ldavg[2] / (float)avg.fscale);
		}
	}
	// UIDevice class から情報を拾う
	// sysctlと違い、OSパッケージの視点での情報となる
	UIDevice *dev = [UIDevice currentDevice];
	sys.hostname = [dev name];
	sys.uniqueIdentifier = [dev uniqueIdentifier];
	sys.localizedName = [dev localizedModel];
	sys.uimodel = [dev model];
	sys.systemName = [dev systemName];
	sys.systemVersion = [dev systemVersion];
	//
	NSLog(@"batt:%d", [dev batteryState]);
	// MACHカーネルから情報を拾う
	struct vm_statistics vm_info;
	mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
	host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vm_info, &count);
	sys.free_count = vm_info.free_count * vm_page_size;
	sys.active_count = vm_info.active_count * vm_page_size;
	sys.inactive_count = vm_info.inactive_count * vm_page_size;
	sys.wire_count = vm_info.wire_count * vm_page_size;
	// NSLog(@"%d", vm_info.free_count * vm_page_size);
	// NSLog(@"%d", vm_info.active_count * vm_page_size);
	// NSlog(@"%d", vm_info.inactive_count * vm_page_size);
	// NSLog(@"%d", vm_info.wire_count * vm_page_size);
	
	
	return sys;
}

-(void)setBSDMemoryResource: (System*)systemResource{
    int			err;
	int			ret;
	// sysctlでプロセスの情報リストを要求する
    int			name[3];
    size_t		length;
	// sysctlでバッファのサイズを確認する
	length = 0;
	name[0] = CTL_HW;
	name[2] = 0;
	// Physical Memory size
	length = 4;
	name[1] = HW_PHYSMEM;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		systemResource.physmem = ret;
	}
	// User Memory size
	length = 4;
	name[1] = HW_USERMEM;
	err = sysctl( (int *) name, 2, &ret, &length, NULL, 0);
	if (err == 0) {
		systemResource.usermem = ret;
	}	
}

// ネットワークの情報を得る
- (void)getNetworkInterfaceResource {
	// IFリストを取得
	CFArrayRef interfaces = SCNetworkInterfaceCopyAll();
	NSLog(@"nics:%d", CFArrayGetCount(interfaces));
	for(int i = 0; i < CFArrayGetCount(interfaces); i++){
		SCNetworkInterfaceRef interface = CFArrayGetValueAtIndex(interfaces, i);
		while(interface != NULL){
			CFArrayRef *ifarray = SCNetworkInterfaceGetSupportedInterfaceTypes(interface);
			for(int j = 0; j < CFArrayGetCount(ifarray); j++){
				NSLog(@"iftype[%d]=%@", j, CFArrayGetValueAtIndex(ifarray, j));
			}
			// "en0"
			NSString *name = (NSString*)SCNetworkInterfaceGetBSDName(interface);
			// "IEEE80211"
			NSString *ifType = (NSString*)SCNetworkInterfaceGetInterfaceType(interface);
			// "AirMac"
			NSString *locName = (NSString*)SCNetworkInterfaceGetLocalizedDisplayName(interface);
			// MAC Addr
			NSString *hwAddr = (NSString*)SCNetworkInterfaceGetHardwareAddressString(interface);
			NSLog(@"NIC[%d] = %@ / %@ / %@ / %@", i, name, ifType, locName, hwAddr);
			int cur, min, max;
			if(SCNetworkInterfaceCopyMTU(interface, &cur, &min, &max)){
				NSLog(@" -> MTU cur/min/max = %d/%d/%d", cur, min, max);
			}
			interface = SCNetworkInterfaceGetInterface(interface);
		}
	}
	CFRelease(interfaces);
}

@end
