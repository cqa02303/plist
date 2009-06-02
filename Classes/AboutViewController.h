#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AboutViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UILabel *label;
    IBOutlet UIWebView *webView;
	IBOutlet UIButton *button;
	IBOutlet UIActivityIndicatorView *activity;
}

/*
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIButton *button;
*/
- (IBAction)okAction:(id)sender;

@end
