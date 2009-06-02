//
//  RootViewController.m
//  plist
//
//  Created by 藤川 宏之 on 08/08/17.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "RootViewController.h"
#import "plistAppDelegate.h"
#import "process.h"

@interface RootViewController()
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) procViewController *procView;
@property (nonatomic, retain) systemViewController *systemView;
@property (nonatomic, retain) AboutViewController *aboutView;
@end

@implementation RootViewController

@synthesize tableView;
@synthesize procView;
@synthesize systemView;
@synthesize aboutView;

#define localizedString(key, str) [[NSBundle mainBundle] localizedStringForKey: (key) value: (str) table: @"InfoPlist"]

- (void)viewDidLoad {
	// Add the following line if you want the list to be editable
	// self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
	NSLog(@"didReceiveMemoryWarning");
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[systemView release];
	[procView release];
	[tableView release];
	[super dealloc];
}

#pragma mark UIViewController


// 表示されるときに呼ばれる、戻ってくる時も呼ばれる
-(void)viewWillAppear:(BOOL)animated {
	//NSLog(@"[RootViewController viewWillAppear]");
	plistAppDelegate *appDelegate = (plistAppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate getBSDProcessList];
	UIButton *rawButton = [UIButton  buttonWithType: UIButtonTypeInfoLight];
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView: rawButton];
	[rawButton addTarget:self action:@selector(info:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = button;
	[self.tableView reloadData];
}

// info ボタンのアクション
-(void)info: (id)sender{
	AboutViewController *about = self.aboutView;
/*

	UIView *view = about.view;
	UIView *superView = self.view.superview.superview.superview;
	[about setEditing:NO animated:NO];
	// 戻る位置を保存
	about.oldView = self.view.superview.superview;
	// アニメーションを指示
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration: 0.5];
	[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:superView cache:YES];
	//これやったらへんなことになった
//	[self.view removeFromSuperview];
	[superView addSubview: view];
	[UIView commitAnimations];
*/
	[self presentModalViewController:about animated:YES];
}

// プロセス情報画面を生成
-(procViewController*)procView{
	if(procView == nil){
		procView = [[procViewController alloc] initWithNibName: @"procView" bundle: nil];
	}
	return procView;
}

// システム情報画面を生成
-(systemViewController*)systemView{
	if(systemView == nil){
		systemView = [[systemViewController alloc] initWithNibName: @"systemView" bundle: nil];
	}
	return systemView;
}

// プログラム情報画面を生成
-(AboutViewController*)aboutView{
	if(aboutView == nil){
		aboutView = [[AboutViewController alloc] initWithNibName: @"About" bundle: nil];
	}
	return aboutView;
}

#pragma mark UITableViewDelegate and dataSource

// セクションの数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

// レコード数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	plistAppDelegate *appDelegate = (plistAppDelegate*)[[UIApplication sharedApplication] delegate];
	switch(section){
		case 0: return 1;
		case 1: return appDelegate.procs.count;
	}
	return 0;
}

// セクションのタイトルを設定する
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
	switch(section){
		case 0: return localizedString(@"rtag0", @"system");
		case 1: return localizedString(@"rtag1", @"running process list");
	}
	return @"";
}

// 項目の右側の矢印を出すか出さないか
- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDisclosureIndicator; // 「＞」
}

// cellの表示内容を返す
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	// Set up the cell
	plistAppDelegate *appDelegate = (plistAppDelegate*)[[UIApplication sharedApplication] delegate];
	if(indexPath.section == 0){
		cell.text = [NSString stringWithFormat:@"%@: %d", localizedString(@"procscell", @"procs"), appDelegate.procs.count];
	}else{
		process *procp = [appDelegate.procs objectAtIndex:indexPath.row];
		cell.text = [procp cellName];
	}
	return cell;
}

// 選択されたときの動き？
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Inspect the book (method defined above).
	plistAppDelegate *appDelegate = (plistAppDelegate*)[[UIApplication sharedApplication] delegate];
	if(indexPath.section == 0){
		// UINavigationControllerのスタックに次のページのコントローラを積み上げ、表示を切り替える
		systemViewController *controller = self.systemView;
		controller.sys = [appDelegate getBSDSystemResource];
		// 戻る時はUINavigationControllerのbackBarButtonにお任せっぽい
		[self.navigationController pushViewController:controller animated:YES];
		[controller setEditing:NO animated:NO];
		return nil;
	}
	process *proc = [appDelegate.procs objectAtIndex:indexPath.row];
	// self.procView で、 -(procViewController*)procView が呼ばれる
	procViewController *controller = self.procView;
	// 詳細表示にカードを渡す
    controller.proc = proc;
	controller.selectedIndexPath = indexPath;
//	controller.title = [proc name];
	// "controller"への表示切り替えをnavigationControllerに依頼する animated: 画面切替でアニメーションをするか
    [self.navigationController pushViewController:controller animated:YES];
    [controller setEditing:NO animated:NO];
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	 // Navigation logic
	//NSLog(@"didSelectRowAtIndexPath");
}


/*
 Override if you support editing the list
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
		
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}	
	if (editingStyle == UITableViewCellEditingStyleInsert) {
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	}	
}
*/


/*
 Override if you support conditional editing of the list
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}
*/


/*
 Override if you support rearranging the list
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
 Override if you support conditional rearranging of the list
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the item to be re-orderable.
	return YES;
}
 */ 


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


@end

