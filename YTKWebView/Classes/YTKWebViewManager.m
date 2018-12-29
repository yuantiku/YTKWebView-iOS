//
//  YTKWebViewManager.m
//  YTKWebView
//
//  Created by lihaichun on 2018/12/29.
//

#import "YTKWebViewManager.h"
#import "YTKWebViewURLProtocol.h"
#import "YTKWebRequestAgent.h"
#import "NSObject+YTKObject.h"
#import "UIWebView+YTKSwizzling.h"

NSString * const YTKWebViewLifecycleDidChangeNotification = @"YTKWebViewLifecycleDidChangeNotification";
NSString * const YTKWebViewLifecycleKey = @"YTKWebViewLifecycleKey";
NSString * const YTKWebViewKey = @"YTKWebViewKey";

@interface YTKWebViewManager () <UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, readwrite) YTKWebViewLifecycle lifecycle;

@property (nonatomic, weak) id<UIWebViewDelegate> webViewDelegate;

@end

@implementation YTKWebViewManager

+ (void)initialize {
    [NSURLProtocol registerClass:[YTKWebViewURLProtocol class]];
    [YTKWebRequestAgent sharedAgent];
}

- (instancetype)initWithWebView:(UIWebView *)webView {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callSetDelegateSelector:) name:YTKDidCallWebViewSetDelegateNotification object:nil];
        _webView = webView;
        if (webView.delegate) {
            self.webViewDelegate = webView.delegate;
        }
        _webView.delegate = self;
        _lifecycle = YTKWebViewLifecycleInit;
        _webView.ytk_retainObject = self;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"YTKWebViewManager dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clean {
    _webView.delegate = nil;
    _webView.ytk_retainObject = nil;
}

- (void)callSetDelegateSelector:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    UIWebView *webView = notification.object;
    YTKWebViewManager *manager = [userInfo objectForKey:YTKDidCallSetDelegateManagerKey];
    if (webView == self.webView && manager == self) {
        id<UIWebViewDelegate> delegate = [userInfo objectForKey:YTKDidCallSetDelegateDelegateKey];
        if (delegate) {
            self.webViewDelegate = delegate;
        }
    }
}

#pragma mark - Utils

- (void)notifyLifecycleChange:(YTKWebViewLifecycle)lifecycle {
    if ([self.delegate respondsToSelector:@selector(webViewManager:webView:lifecycleDidChange:)]) {
        [self.delegate webViewManager:self webView:self.webView lifecycleDidChange:lifecycle];
    }

    NSDictionary *userInfo = @{YTKWebViewLifecycleKey : @(lifecycle), YTKWebViewKey : self.webView};
    [[NSNotificationCenter defaultCenter] postNotificationName:YTKWebViewLifecycleDidChangeNotification object:nil userInfo:userInfo];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (self.manualControlLifecycle) {
        return;
    }
    self.lifecycle = YTKWebViewLifecycleLoading;

    /** 传递 */
    if ([self.webViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.webViewDelegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.manualControlLifecycle) {
        return;
    }
    self.lifecycle = YTKWebViewLifecycleSucceed;

    if ([self.webViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.webViewDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (self.manualControlLifecycle) {
        return;
    }
    self.lifecycle = YTKWebViewLifecycleFailed;

    if ([self.webViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.webViewDelegate webView:webView didFailLoadWithError:error];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([self.webViewDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.webViewDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}

#pragma mark - Setter

- (void)setLifecycle:(YTKWebViewLifecycle)lifecycle {
    if (lifecycle == YTKWebViewLifecycleClose) {
        [self clean];
    }
    _lifecycle = lifecycle;
    if ([[NSThread currentThread] isMainThread]) {
        [self notifyLifecycleChange:lifecycle];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self notifyLifecycleChange:lifecycle];
        });
    }
}

@end
