//
//  System.h
//  plist
//
//  Created by 藤川 宏之 on 08/08/19.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/sysctl.h>

@interface System : NSObject {
	NSString	*hostname;
	NSString	*machine;
	NSString	*model;
	int			 ncpu;
	unsigned int physmem;
	int			 usermem;
	int			 pagesize;
	int			 floatingpt;
	NSString	*arch;
	NSString	*osrel;
	NSString	*osrev;
	NSString	*ostype;
	NSString	*kernelver;
	NSString	*uniqueIdentifier;
	NSString	*localizedName;
	NSString	*uimodel;
	NSString	*systemName;
	NSString	*systemVersion;
	NSString	*ldavg;
	int			 vectorunit;
	int			 cpu_freq;
	int			 cacheline;
	int			 l1icachesize;
	int			 l1dcachesize;
	int			 l2settings;
	int			 l2cachesize;
	int			 l3settings;
	int			 l3cachesize;
	int			 bus_freq;
	int			 tb_freq;
	int64_t		 memsize;
	int			 free_count;
	int			 active_count;
	int			 inactive_count;
	int			 wire_count;
}

@property (nonatomic, retain) NSString *hostname;
@property (nonatomic, retain) NSString *machine;
@property (nonatomic, retain) NSString *model;
@property (nonatomic) int ncpu;
@property (nonatomic) unsigned int physmem;
@property (nonatomic) int usermem;
@property (nonatomic) int pagesize;
@property (nonatomic) int floatingpt;
@property (nonatomic, retain) NSString *arch;
@property (nonatomic, retain) NSString *osrel;
@property (nonatomic, retain) NSString *osrev;
@property (nonatomic, retain) NSString *ostype;
@property (nonatomic, retain) NSString *kernelver;
@property (nonatomic, retain) NSString *uniqueIdentifier;
@property (nonatomic, retain) NSString	*localizedName;
@property (nonatomic, retain) NSString	*uimodel;
@property (nonatomic, retain) NSString	*systemName;
@property (nonatomic, retain) NSString	*systemVersion;
@property (nonatomic, retain) NSString	*ldavg;
@property (nonatomic) int vectorunit;
@property (nonatomic) int cpu_freq;
@property (nonatomic) int cacheline;
@property (nonatomic) int l1icachesize;
@property (nonatomic) int l1dcachesize;
@property (nonatomic) int l2settings;
@property (nonatomic) int l2cachesize;
@property (nonatomic) int l3settings;
@property (nonatomic) int l3cachesize;
@property (nonatomic) int bus_freq;
@property (nonatomic) int tb_freq;
@property (nonatomic) int64_t memsize;
@property (nonatomic) int free_count;
@property (nonatomic) int active_count;
@property (nonatomic) int inactive_count;
@property (nonatomic) int wire_count;

@end
