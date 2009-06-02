#import "AboutViewController.h"


@implementation AboutViewController
/*
@synthesize label;
@synthesize textView;
@synthesize button;
*/

#define localizedString(key, str) [[NSBundle mainBundle] localizedStringForKey: (key) value: (str) table: @"InfoPlist"]

// 画面配置初期化
-(id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
	if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// NSLog(@"About initWithNibName");
	}
	return self;
}

- (void)dealloc {
	[label release];
	[webView release];
	[button release];
	[super dealloc];
}

#pragma mark UIViewController

// 表示されるときに呼ばれる、戻ってくる時も呼ばれる
-(void)viewWillAppear:(BOOL)animated {
	// データ初期化
	//NSLog(localizedString(@"aboutlabel", @"about plist"));
	label.text = localizedString(@"aboutlabel", @"About plist");
	// リソースファイルのPATHを求める
	NSString *AboutFilePath = [[NSBundle mainBundle] pathForResource:@"README" ofType:@"html"];
	// UIWebViewにfileを表示させる
	[webView loadRequest:[NSURLRequest requestWithURL: [NSURL fileURLWithPath:AboutFilePath]]];
}

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
	// くるくるアニメを開始
	[activity startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	// くるくるアニメを止める
	[activity stopAnimating];
}

#pragma mark actionForUIButton
// OKボタンを押された時のアクション
- (IBAction)okAction:(id)sender {
	// 自分自身（コントローラ）を画面から外す
	[self dismissModalViewControllerAnimated:YES];
}



@end
