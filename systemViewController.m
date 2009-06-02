//
//  systemViewController.m
//  plist
//
//  Created by 藤川 宏之 on 08/08/17.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "plistAppDelegate.h"
#import "systemViewController.h"

@interface systemViewController()
@property (nonatomic, retain) UITableView *tableView;
@end;

#define localizedString(key, str) [[NSBundle mainBundle] localizedStringForKey: (key) value: (str) table: @"InfoPlist"]

@implementation systemViewController
@synthesize tableView;
@synthesize sys;

// 画面配置初期化
-(id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
	if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.title = localizedString(@"systitle", @"System Report");
	}
	return self;
}

-(void)dealloc {
	[System release];
	[tableView release];
	[super dealloc];
}

// 表示されるときに呼ばれる
-(void)viewWillAppear:(BOOL)animated{
	//NSLog(@"[systemViewController viewWillAppear]");
	plistAppDelegate *appDelegate = (plistAppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate setBSDMemoryResource:sys];
	[appDelegate getNetworkInterfaceResource];
	[tableView reloadData];
}

#pragma mark -
#pragma mark <UITableViewDelegate, UITableViewDataSource> Methods

// TableViewでいくつの表を表示するか
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tv {
	return 31;
}

// 各表でいくつの項目を出すかという指示
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	// セクションの表示項目を設定する
/*
    switch (section) {
        case 0:	// １つ目の項目の表示
			break;
    }
 */
    return 1;
}

// 各表の中のセクションの各要素(cell)を設定する
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	int kb;
	int mb;
	static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	// cell生成
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
    }
	switch(indexPath.section){
		case 0: cell.text = sys.machine; break;
		case 1: cell.text = sys.model; break;
		case 2: cell.text = [NSString stringWithFormat: @"%d", sys.ncpu]; break;
		case 3:
			kb = sys.physmem / 1024;
			mb = kb / 1024;
			cell.text = [NSString stringWithFormat: @"%d MB [ %u Bytes ]", mb, sys.physmem];
			break;
		case 4:
			kb = sys.usermem / 1024;
			mb = kb / 1024;
			cell.text = [NSString stringWithFormat: @"%d MB [ %d Bytes ]", mb, sys.usermem];
			break;
		case 5:
			kb = sys.pagesize / 1024;
			cell.text = [NSString stringWithFormat: @"%d KB", kb];
			break;
		case 6:
			if(sys.floatingpt == 0){
				cell.text = localizedString(@"sysnonfp", @"not support");
			}else{
				cell.text = localizedString(@"sysfp", @"supported");
			}
			break;
		case 7: cell.text = [NSString stringWithFormat:@"%@ / %@", sys.osrel, sys.osrev]; break;
		case 8: cell.text = sys.ostype; break;
		case 9: cell.text = sys.kernelver; break;
			
		case 10:
			if(sys.vectorunit == 0){
				cell.text = localizedString(@"sysnonfp", @"not support");
			}else{
				cell.text = localizedString(@"sysfp", @"supported");
			}
			break;
		case 11: {
			float clock = sys.cpu_freq / 1000.0 / 1000.0;
			if(clock >= 1000){
				clock = clock / 1000.0;
				cell.text = [NSString stringWithFormat: @"%0.1f GHz", clock];
			}else	{
				cell.text = [NSString stringWithFormat: @"%0.0f MHz", clock];
			}
		} break;
		case 12: cell.text = [NSString stringWithFormat: @"%d bit", sys.cacheline]; break;
		case 13: {
			int kb = sys.l1icachesize / 1024;
			cell.text = [NSString stringWithFormat: @"%d KB", kb];
		}break;
		case 14: {
			int kb = sys.l1dcachesize / 1024;
			cell.text = [NSString stringWithFormat: @"%d KB", kb];
		}break;
		case 15:
			if(sys.l2settings == 1){
				int mb = sys.l2cachesize / 1024 / 1024;
				cell.text = [NSString stringWithFormat: @"%d MB", mb];
			}else	{
				cell.text = localizedString(@"sysnonfp", @"not support");
			}
			break;
		case 16:
			if(sys.l3settings == 1){
				int mb = sys.l3cachesize / 1024 / 1024;
				cell.text = [NSString stringWithFormat: @"%d MB", mb];
			}else	{
				cell.text = localizedString(@"sysnonfp", @"not support");
			}
			break;
		case 17: {
			float clock = sys.bus_freq / 1000.0 / 1000.0;
			if(clock >= 1000){
				cell.text = [NSString stringWithFormat: @"%0.2f GHz", clock / 1000.0];
			}else	{
				cell.text = [NSString stringWithFormat: @"%0.0f MHz", clock];
			}
		}break;
		case 18: {
			float clock = sys.tb_freq / 1000.0 / 1000.0;
			if(clock >= 1000){
				cell.text = [NSString stringWithFormat: @"%0.2f GHz", clock / 1000.0];
			}else	{
				cell.text = [NSString stringWithFormat: @"%0.0f MHz", clock];
			}
		}break;
		case 19: {
			int mb = sys.memsize / 1024 / 1024;
			if(mb >= 1024){
				cell.text = [NSString stringWithFormat: @"%d GB", mb / 1024];
			}else	{
				cell.text = [NSString stringWithFormat: @"%d MB", mb];
			}
		}break;
			
		case 20: cell.text = sys.hostname; break;
		case 21: cell.text = sys.uniqueIdentifier; break;
        case 22: cell.text = sys.localizedName; break;
        case 23: cell.text = sys.uimodel; break;
        case 24: cell.text = sys.systemName; break;
        case 25: cell.text = sys.systemVersion; break;
			// __APPLE_API_PRIVATE
		case 26: cell.text = sys.ldavg; break;
			//
		case 27:
			kb = sys.free_count / 1024;
			mb = kb / 1024;
			cell.text = [NSString stringWithFormat: @"%d MB [ %u Bytes ]", mb, sys.free_count];
			break;
		case 28:
			kb = sys.active_count / 1024;
			mb = kb / 1024;
			cell.text = [NSString stringWithFormat: @"%d MB [ %u Bytes ]", mb, sys.active_count];
			break;
		case 29:
			kb = sys.inactive_count / 1024;
			mb = kb / 1024;
			cell.text = [NSString stringWithFormat: @"%d MB [ %u Bytes ]", mb, sys.inactive_count];
			break;
		case 30:
			kb = sys.wire_count / 1024;
			mb = kb / 1024;
			cell.text = [NSString stringWithFormat: @"%d MB [ %u Bytes ]", mb, sys.wire_count];
			break;
	}
    return cell;
}

// セクションの表示名を返す(セクションタイトル)
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    switch (section) {
			// 各文字列の国際化文字列を取得する[NSBundle localizedStringForKey: (文字列名ラベル) value: (デフォルト文字列) table: (定義ファイル名)];
        case 0: return localizedString(@"systag0", @"machine");
        case 1: return localizedString(@"systag1", @"model");
        case 2: return localizedString(@"systag2", @"number of cpu");
        case 3: return localizedString(@"systag3", @"physical memory");
        case 4: return localizedString(@"systag4", @"user memory");
        case 5: return localizedString(@"systag5", @"pagesize");
        case 6: return localizedString(@"systag6", @"floating point processor");
        case 7: return localizedString(@"systag7", @"kernel release / revision");
        case 8: return localizedString(@"systag8", @"kernel type");
        case 9: return localizedString(@"systag9", @"kernel version");

		case 10: return localizedString(@"systag10", @"vectorunit");
        case 11: return localizedString(@"systag11", @"cpu freq");
        case 12: return localizedString(@"systag12", @"cacheline");
        case 13: return localizedString(@"systag13", @"L1 I cachesize");
        case 14: return localizedString(@"systag14", @"L1 Data cachesize");
        case 15: return localizedString(@"systag15", @"L2 cachesize");
        case 16: return localizedString(@"systag16", @"L3 cachesize");
        case 17: return localizedString(@"systag17", @"bus freq");
        case 18: return localizedString(@"systag18", @"tb freq");
        case 19: return localizedString(@"systag19", @"memory size");
			
        case 20: return localizedString(@"systag20", @"hostname");
        case 21: return localizedString(@"systag21", @"unique identifier");
        case 22: return localizedString(@"systag22", @"localized name");
        case 23: return localizedString(@"systag23", @"model");
        case 24: return localizedString(@"systag24", @"os name");
        case 25: return localizedString(@"systag25", @"os version");
			// __APPLE_API_PRIVATE
		case 26: return localizedString(@"pritag0", @"load averages");
			// 
		case 27: return localizedString(@"systag27", @"free memory");
		case 28: return localizedString(@"systag28", @"active memory");
		case 29: return localizedString(@"systag29", @"inactive memory");
		case 30: return localizedString(@"systag30", @"wired memory");
    }
    return nil;
}

// 項目の右側の矢印を出すか出さないか。
- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	switch(indexPath.section){
		case 9: // カーネルverをダイアログ表示
		case 21: // UniqueIdentifierをダイアログ表示
			return UITableViewCellAccessoryDetailDisclosureButton;
	}
    return UITableViewCellAccessoryNone;
}

// 選択された時の動き
// nilを返すと青く反転しないっぽい
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch(indexPath.section){
		case 9 : {// カーネルverをダイアログ表示
			UIAlertView *openURLAlert = [[UIAlertView alloc] initWithTitle:localizedString(@"systag9", @"Kernel version") message:sys.kernelver delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[openURLAlert show];
			[openURLAlert release];
		}break;
		case 21: {// UniqueIdentifierをダイアログ表示
			UIAlertView *openURLAlert = [[UIAlertView alloc] initWithTitle:localizedString(@"systag21", @"Unique Identifier") message:sys.uniqueIdentifier delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[openURLAlert show];
			[openURLAlert release];
		}break;
	}
	return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

@end
