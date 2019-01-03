//
//  YTKWebView.m
//  YTKWebView
//
//  Created by lihaichun on 2018/12/27.
//

#import "YTKWebView.h"

@interface YTKWebView ()

@property (nonatomic, strong) YTKWebViewLifecycle *lifecycle;

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YTKWebView

- (instancetype)initWithWebView:(UIWebView *)webView {
    self = [super init];
    if (self) {
        _webView = webView;
        _lifecycle = [[YTKWebViewLifecycle alloc] initWithWebView:webView];
    }
    return self;
}

#pragma mark - Properties

- (YTKWebViewLifecycleState)state {
    return self.lifecycle.state;
}

- (BOOL)manualControlLifecycle {
    return self.lifecycle.manualControlLifecycle;
}

- (void)setManualControlLifecycle:(BOOL)manualControlLifecycle {
    self.lifecycle.manualControlLifecycle = manualControlLifecycle;
}

- (id<YTKWebViewLifecycleDelegate>)lifecycleDelegate {
    return self.lifecycle.delegate;
}

- (void)setLifecycleDelegate:(id<YTKWebViewLifecycleDelegate>)lifecycleDelegate {
    self.lifecycle.delegate = lifecycleDelegate;
}

@end
