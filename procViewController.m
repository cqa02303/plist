#import "procViewController.h"
#import "plistAppDelegate.h"
#import <sys/sysctl.h>
#import <UIKit/UIDevice.h>
#import <pwd.h>
#include <mach/mach.h>
#include <mach/task_info.h>

@interface procViewController()
@property (nonatomic, retain) UITableView *tableView;
-(void)segAdjust;
@end;

@implementation procViewController
@synthesize tableView;
@synthesize selectedIndexPath;
@synthesize proc;
@synthesize segment;

#define localizedString(key, str) [[NSBundle mainBundle] localizedStringForKey: (key) value: (str) table: @"InfoPlist"]


// 画面配置初期化
-(id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
	if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//		self.title = @"proc";
		NSArray *segmentTextContent = [NSArray arrayWithObjects: localizedString(@"prev", @"prev"), localizedString(@"next", @"next"), nil];
		UISegmentedControl *seg = [[[UISegmentedControl alloc] initWithItems: segmentTextContent] autorelease];
		seg.frame = CGRectMake(0, 0, 86, 34);
		seg.segmentedControlStyle = UISegmentedControlStyleBar;
		[seg addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
		self.segment = seg;
		UIBarButtonItem *button = [[[UIBarButtonItem alloc] initWithCustomView: seg] autorelease];
		self.navigationItem.rightBarButtonItem = button;
	}
	return self;
}

-(void)segAdjust {
	//NSLog(@"index:%d", selectedIndexPath.row);
	plistAppDelegate *appDelegate = (plistAppDelegate*)[[UIApplication sharedApplication] delegate];
	if(selectedIndexPath.row == 0){
		[segment setEnabled: NO forSegmentAtIndex: 0];
	}else	{
		[segment setEnabled: YES forSegmentAtIndex: 0];
	}
	if((selectedIndexPath.row + 1) == appDelegate.procs.count){
		[segment setEnabled: NO forSegmentAtIndex: 1];
	}else	{
		[segment setEnabled: YES forSegmentAtIndex: 1];
	}
}

-(void)dealloc {
	[selectedIndexPath release];
	[tableView release];
	[proc release];
	[segment release];
	[super dealloc];
}

// 表示されるときに呼ばれる
-(void)viewWillAppear:(BOOL)animated{
	// self.title = proc.name;
	plistAppDelegate *appDelegate = (plistAppDelegate*)[[UIApplication sharedApplication] delegate];
	self.title = [NSString stringWithFormat: @"%d/%d", (self.selectedIndexPath.row + 1), appDelegate.procs.count];
	[self segAdjust];
	[tableView reloadData];
	// テストコード
	struct extern_proc *kp_proc;
	task_t task;
	struct task_basic_info tinf;
	unsigned int count;
	kp_proc = proc.kp_proc;
	task_for_pid(mach_task_self(), kp_proc->p_pid, &task);
	count = TASK_BASIC_INFO_COUNT; task_info(task, TASK_BASIC_INFO, (task_info_t) &tinf, &count);
	NSLog(@"u=%d %d\n", tinf.user_time.seconds, tinf.user_time.microseconds);
	NSLog(@"s=%d %d\n", tinf.system_time.seconds, tinf.system_time.microseconds);
	NSLog(@"sz=%d %d\n", tinf.virtual_size, tinf.resident_size);

	{ // proc構造体の中身を確認する為のコード
		struct eproc *kp_eproc = proc.kp_eproc;
		struct extern_proc *kp_proc = proc.kp_proc;
		NSLog(@"kp_eproc.e_flag :%d", kp_eproc->e_flag );
		NSLog(@"kp_eproc.e_jobc :%d", kp_eproc->e_jobc );
		NSLog(@"kp_eproc.e_login :%s", kp_eproc->e_login );
		NSLog(@"kp_eproc.e_pgid :%d", kp_eproc->e_pgid );
		NSLog(@"kp_eproc.e_ppid :%d", kp_eproc->e_ppid );
		NSLog(@"kp_eproc.e_tdev :%d", kp_eproc->e_tdev );
		NSLog(@"kp_eproc.e_tpgid :%d", kp_eproc->e_tpgid );
		NSLog(@"kp_eproc.e_wmesg :%s", kp_eproc->e_wmesg );
		NSLog(@"kp_eproc.e_xccount :%d", kp_eproc->e_xccount );
		NSLog(@"kp_eproc.e_xrssize :%d", kp_eproc->e_xrssize );
		NSLog(@"kp_eproc.e_xsize :%d", kp_eproc->e_xsize );
		NSLog(@"kp_eproc.e_xswrss :%d", kp_eproc->e_xswrss );
		NSLog(@"kp_proc.p_rtime :%d, %d", kp_proc->p_rtime.tv_sec, kp_proc->p_rtime.tv_usec );
		NSLog(@"kp_proc.p_acflag :%d", kp_proc->p_acflag );
		NSLog(@"kp_proc.p_comm :%s", kp_proc->p_comm );
		NSLog(@"kp_proc.p_cpticks :%d", kp_proc->p_cpticks );
		NSLog(@"kp_proc.p_debugger :%d", kp_proc->p_debugger );
		NSLog(@"kp_proc.p_dupfd :%d", kp_proc->p_dupfd );
		NSLog(@"kp_proc.p_estcpu :%d", kp_proc->p_estcpu );
		NSLog(@"kp_proc.p_flag :%d", kp_proc->p_flag );
		NSLog(@"kp_proc.p_holdcnt :%d", kp_proc->p_holdcnt );
		NSLog(@"kp_proc.p_iticks :%d", kp_proc->p_iticks );
		NSLog(@"kp_proc.p_nice :%d", kp_proc->p_nice );
		NSLog(@"kp_proc.p_oppid :%d", kp_proc->p_oppid );
		NSLog(@"kp_proc.p_pctcpu :%d", kp_proc->p_pctcpu );
		NSLog(@"kp_proc.p_pid :%d", kp_proc->p_pid );
		NSLog(@"kp_proc.p_priority :%d", kp_proc->p_priority );
		NSLog(@"kp_proc.p_sigcatch :%d", kp_proc->p_sigcatch );
		NSLog(@"kp_proc.p_slptime :%d", kp_proc->p_slptime );
		NSLog(@"kp_proc.p_stat :%d", kp_proc->p_stat );
		NSLog(@"kp_proc.p_sticks :%d", kp_proc->p_sticks );
		NSLog(@"kp_proc.p_swtime :%d", kp_proc->p_swtime );
		NSLog(@"kp_proc.p_traceflag :%d", kp_proc->p_traceflag );
		NSLog(@"kp_proc.p_un :%d", kp_proc->p_un );					// time_tらしい
		NSLog(@"kp_proc.p_usrpri :%d", kp_proc->p_usrpri );
		NSLog(@"kp_proc.p_uticks :%d", kp_proc->p_uticks );
		NSLog(@"kp_proc.p_wchan :%d", kp_proc->p_wchan );
		NSLog(@"kp_proc.p_wmesg :%s", kp_proc->p_wmesg );
		NSLog(@"kp_proc.p_xstat :%d", kp_proc->p_xstat );
		NSLog(@"kp_proc.sigwait :%d", kp_proc->sigwait );
		NSLog(@"kp_proc.user_stack :%d", kp_proc->user_stack );
	}

/*
	{
		struct extern_proc *kp_proc = proc.kp_proc;
		struct passwd *pwd;
		pwd = getpwuid(kp_proc->p_pid);
		NSLog(@"ret = %d", pwd);
		NSLog(@"gid:%d", pwd->pw_gid);
		NSLog(@"uname:%s", pwd->pw_name);
	}
 */
}

#pragma mark -
#pragma mark <UITableViewDelegate, UITableViewDataSource> Methods

// TableViewでいくつの表を表示するか
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tv {
	return 5;
}

// 各表でいくつの項目を出すかという指示
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	// セクションの表示項目を設定する
    switch (section) {
        case 0:	// １つ目の項目の表示
			break;
        case 1:	// ２つ目の項目の表示
			break;
		case 2:	// ３つ目の項目の表示
			break;
        case 3:	// ４つ目の項目の表示
			return 3;
			break;
        case 4:	// ５つ目の項目の表示
			return 3;
			break;
    }
    return 1;
}

// 各表の中のセクションの各要素(cell)を設定する
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	struct extern_proc *kp_proc;
	struct eproc *kp_eproc;
	static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	// cell生成
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
    }
	// proc情報取得
	kp_proc = proc.kp_proc;
	kp_eproc = proc.kp_eproc;
	// セクションの表示項目を設定する
    switch (indexPath.section) {
        case 0:	// １つ目の項目の表示
			cell.text = [proc name];
			break;
        case 1:	 // ２つ目の項目の表示
			switch(kp_proc->p_stat){
				case SIDL : cell.text = localizedString(@"SIDL", @"IDLE"); break;
				case SRUN : cell.text = localizedString(@"SRUN", @"RUN"); break;
				case SSLEEP : cell.text = localizedString(@"SSLEEP", @"SLEEP"); break;
				case SSTOP : cell.text = localizedString(@"SSTOP", @"STOP"); break;
				case SZOMB : cell.text = localizedString(@"SZOMB", @"ZOMBIE"); break;
				default : cell.text = localizedString(@"nullstring", @"-");
			}
			break;
		case 2: {	// ３つ目の項目の表示
			// 日時文字列フォーマッターを作成
			NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
			[dateFormatter setDateStyle: NSDateFormatterNoStyle];
			[dateFormatter setTimeStyle: NSDateFormatterLongStyle];
			// プロセス起動時刻を取得する(time_tからNSDateを作成)
			NSDate *date = [NSDate dateWithTimeIntervalSince1970: kp_proc->p_starttime.tv_sec];
			cell.text = [dateFormatter stringFromDate: date];
		} break;
        case 3:	// ４つ目の項目の表示
			switch(indexPath.row){
				case 0 : cell.text = [NSString stringWithFormat: @"PID : %d", kp_proc->p_pid]; break;
				case 1 : cell.text = [NSString stringWithFormat: @"PPID : %d", kp_proc->p_oppid ]; break;
				case 2 : cell.text = [NSString stringWithFormat: @"PGID : %d", kp_eproc->e_pgid ]; break;
			}
			break;
        case 4:	// ５つ目の項目の表示
			switch(indexPath.row){
				case 0 : cell.text = [NSString stringWithFormat: @"RUID : %d", kp_eproc->e_pcred.p_ruid]; break;
				case 1 : cell.text = [NSString stringWithFormat: @"RGID : %d", kp_eproc->e_pcred.p_rgid]; break;
				case 2 : cell.text = [NSString stringWithFormat: @"EUID : %d", kp_eproc->e_ucred.cr_uid]; break;
			}
			break;
    }
    return cell;
}

// セクションの表示名を返す(セクションタイトル)
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    switch (section) {
			// 各文字列の国際化文字列を取得する[NSBundle localizedStringForKey: (文字列名ラベル) value: (デフォルト文字列) table: (定義ファイル名)];
        case 0: return localizedString(@"prctag0", @"name");
        case 1: return localizedString(@"prctag1", @"running status");
        case 2: return localizedString(@"prctag2", @"start time");
        case 3: return localizedString(@"prctag3", @"process id");
        case 4: return localizedString(@"prctag4", @"user id");
    }
    return nil;
}

// 項目の右側の矢印を出すか出さないか。
- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 2:	// ２つ目の項目の表示
			return UITableViewCellAccessoryDetailDisclosureButton;
	}
    return UITableViewCellAccessoryNone;
}

// 選択された時の動き
// nilを返すと青く反転しないっぽい
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 2:	{// ２つ目の項目の表示
			// 日時文字列フォーマッターを作成する
			NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
			[dateFormatter setDateStyle: NSDateFormatterFullStyle];
			[dateFormatter setTimeStyle: NSDateFormatterFullStyle];
			// プロセス起動時間を取る(time_tからNSDateを作成)
			NSDate *date = [NSDate dateWithTimeIntervalSince1970: proc.kp_proc->p_starttime.tv_sec];
			// アラートダイアログで表示する
			UIAlertView *openURLAlert = [[UIAlertView alloc] initWithTitle:localizedString(@"prctag2", @"start time") message: [dateFormatter stringFromDate:date] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[openURLAlert show];
			[openURLAlert release];
		}break;
	}
	return nil;
}

#pragma mark UISegmentedControl
- (void)segmentAction:(id)sender
{
	float	delay = 0.6;
	if([sender selectedSegmentIndex] == UISegmentedControlNoSegment){ return; }
	int	num = [self.selectedIndexPath row];
	UISegmentedControl *seg = self.segment;
	UIViewAnimationTransition transition;
	plistAppDelegate *appDelegate = (plistAppDelegate*)[[UIApplication sharedApplication] delegate];
	switch([sender selectedSegmentIndex]){
		case 0: // up
			num--;
			if(num < 0){
				seg.selectedSegmentIndex = UISegmentedControlNoSegment;
				return;
			}
			delay = 0.8;
			transition = UIViewAnimationTransitionCurlDown;
			break;
		case 1: // down
			num++;
			if(num >= appDelegate.procs.count){
				seg.selectedSegmentIndex = UISegmentedControlNoSegment;
				return;
			}
			transition = UIViewAnimationTransitionCurlUp;
			break;
	}
	// データの差し替え
	self.selectedIndexPath = [NSIndexPath indexPathForRow: num inSection: self.selectedIndexPath.section];
	self.proc = [appDelegate.procs objectAtIndex: num];
	[self segAdjust];
	// アニメーションを指示
	UIView *view = self.view;
	UIView *superView = self.view.superview;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration: delay];
	[UIView setAnimationTransition: transition forView:superView cache:YES];
	[self.view removeFromSuperview];
	[superView addSubview: view];
	[UIView commitAnimations];
	// アニメーションは非同期なので、データを書き換えておく
	seg.selectedSegmentIndex = UISegmentedControlNoSegment;
	self.title = [NSString stringWithFormat: @"%d/%d", (self.selectedIndexPath.row + 1), appDelegate.procs.count];
	[tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

@end
