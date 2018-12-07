//
//  WDActDetailView.m
//  5dou
//
//  Created by ChunXin Zhou on 16/8/30.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDActDetailView.h"
#import "ToolClass.h"
#import "WDSCWebViewController.h"

@interface WDActDetailView()<UIWebViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *readNumLabel;
@property (weak, nonatomic) IBOutlet UIWebView *actWebView;

/**占位文字*/
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
/**评论的按钮*/
@property (weak, nonatomic) IBOutlet UIButton *commentButton;



@end
@implementation WDActDetailView
+ (WDActDetailView *)view{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"WDActDetailView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _actWebView.scrollView.showsVerticalScrollIndicator = NO;
    _actWebView.scrollView.showsHorizontalScrollIndicator = NO;
    _actWebView.scrollView.scrollEnabled = NO;
    _actWebView.delegate = self;
    
    _commentTextView.delegate = self;
    _commentTextView.layer.cornerRadius = 5.0f;
    _commentTextView.layer.borderColor = kThirdLevelBlack.CGColor;
    _commentTextView.layer.borderWidth = 1.0f;
    _commentTextView.clipsToBounds = YES;
    [ToolClass setLayerAndBezierPathCutCircularWithView:self.commentButton];
//    [ToolClass setLayerAndBezierPathCutCircularWithView:self.commentTextView];
}

- (void)setActDetailDict:(NSDictionary *)actDetailDict{
    _actDetailDict = actDetailDict;
    _titleLabel.text = actDetailDict[@"title"];
    _timeLabel.text = actDetailDict[@"createTime"];
    _readNumLabel.text = [NSString stringWithFormat:@"%@",actDetailDict[@"pageView"]];
    _commetNumberLabel.text = [NSString stringWithFormat:@"评论(%@)",actDetailDict[@"commentCount"]];
    NSString *titleStr = actDetailDict[@"title"];
    _titleLabelHeight.constant = ceil([ToolClass getStrHeightWithStr:titleStr andWidth:ScreenWidth - 16 andWithFont:[UIFont systemFontOfSize:18]]);
    [self layoutIfNeeded];
    if (actDetailDict[@"content"]) {
        //进行图片的缩放
        NSMutableString *htmlStr=[[NSMutableString alloc] initWithString:actDetailDict[@"content"]];
        [htmlStr appendString:@"<style type='text/css'>img{max-width: 100%;}</style>"];
        //滑动距离
        NSString *html = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>",htmlStr];
        [_actWebView loadHTMLString:html baseURL:nil];
    }else{
        if (_actUpdateFrameBlock) {
            _actUpdateFrameBlock(0);
        }
    }
}





////////////////////////////////delegate的方法重载////////////////////////////////////////////
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    //设置到WebView上
    webView.frame = CGRectMake(0, 0, ScreenWidth, clientheight);
    //获取WebView最佳尺寸（点）
    CGSize frame = [webView sizeThatFits:webView.frame.size];
    //获取内容实际高度（像素）
    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
    float height = [height_str floatValue];
    //内容实际高度（像素）* 点和像素的比
    height = height * frame.height / clientheight;
    //再次设置WebView高度（点）
    if (_actUpdateFrameBlock) {
        _actUpdateFrameBlock(height);
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
        NSString *urlStr = [request.URL absoluteString];
    if([urlStr isEqualToString:@"about:blank"]){
        return YES;
    }
    if (_openWebViewBlock) {
        _openWebViewBlock(urlStr);
    }
        return NO;
    };


#pragma mark UITextViewDelegate
#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        if (textView.text.length > 200) {
            textView.text = [textView.text substringToIndex:200];
            return;
        }
        _placeHolderLabel.hidden = YES;
    }else{
        _placeHolderLabel.hidden = NO;
    }
//    _wordNumber.text = [NSString stringWithFormat:@"%ld/200",(unsigned long)textView.text.length];
}


- (IBAction)commentBtnClick:(id)sender {
    NSString *tureText = [_commentTextView.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (tureText.length == 0) {
        [ToolClass showAlertWithMessage:@"评论内容不能为空!"];
        return ;
    }else{
        self.commentBlock(tureText);
    }
    
}

-(void)viewWillLayoutSubviews{
    self.commentTextView.width = ScreenWidth - 20;
}


@end
