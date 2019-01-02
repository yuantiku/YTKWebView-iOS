//
//  YTKWebViewLifecycle.m
//  YTKWebView
//
//  Created by lihaichun on 2018/12/29.
//

#import "YTKWebViewLifecycle.h"
#import "YTKWebViewURLProtocol.h"
#import "YTKWebRequestAgent.h"
#import "NSObject+YTKObject.h"
#import "UIWebView+YTKSwizzling.h"

NSString * const YTKWebViewLifecycleStateDidChangeNotification = @"YTKWebViewLifecycleStateDidChangeNotification";
NSString * const YTKWebViewLifecycleStateKey = @"YTKWebViewLifecycleStateKey";
NSString * const YTKWebViewKey = @"YTKWebViewKey";

@interface YTKWebViewLifecycle () <UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, weak) id<UIWebViewDelegate> webViewDelegate;

@end

@implementation YTKWebViewLifecycle

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
        _state = YTKWebViewLifecycleStateInit;
        _webView.ytk_retainObject = self;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"YTKWebViewLifecycle dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clean {
    _webView.delegate = nil;
    _webView.ytk_retainObject = nil;
}

- (void)callSetDelegateSelector:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    UIWebView *webView = notification.object;
    YTKWebViewLifecycle *manager = [userInfo objectForKey:YTKDidCallSetDelegateLifecycleKey];
    if (webView == self.webView && manager == self) {
        id<UIWebViewDelegate> delegate = [userInfo objectForKey:YTKDidCallSetDelegateDelegateKey];
        if (delegate) {
            self.webViewDelegate = delegate;
        }
    }
}

#pragma mark - Utils

- (void)notifyLifecycleStateChange:(YTKWebViewLifecycleState)state {
    if ([self.delegate respondsToSelector:@selector(webViewLifecycle:webView:lifecycleStateDidChange:)]) {
        [self.delegate webViewLifecycle:self webView:self.webView lifecycleStateDidChange:state];
    }

    NSDictionary *userInfo = @{YTKWebViewLifecycleStateKey : @(state), YTKWebViewKey : self.webView};
    [[NSNotificationCenter defaultCenter] postNotificationName:YTKWebViewLifecycleStateDidChangeNotification object:nil userInfo:userInfo];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (self.manualControlLifecycle) {
        return;
    }
    self.state = YTKWebViewLifecycleStateLoading;

    /** 传递 */
    if ([self.webViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.webViewDelegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.manualControlLifecycle) {
        return;
    }
    self.state = YTKWebViewLifecycleStateSucceed;

    if ([self.webViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.webViewDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (self.manualControlLifecycle) {
        return;
    }
    self.state = YTKWebViewLifecycleStateFailed;

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

- (void)setState:(YTKWebViewLifecycleState)state {
    if (state == YTKWebViewLifecycleStateClose) {
        [self clean];
    }
    _state = state;
    if ([[NSThread currentThread] isMainThread]) {
        [self notifyLifecycleStateChange:state];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self notifyLifecycleStateChange:state];
        });
    }
}

@end
