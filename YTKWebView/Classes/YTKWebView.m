//
//  YTKWebView.m
//  YTKWebView
//
//  Created by lihaichun on 2018/12/27.
//

#import "YTKWebView.h"
#import "YTKJsBridge.h"

@interface YTKWebView ()

@property (nonatomic, strong) YTKWebViewLifecycle *lifecycle;

@property (nonatomic, strong) YTKJsBridge *bridge;

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YTKWebView

- (instancetype)initWithWebView:(UIWebView *)webView {
    self = [super init];
    if (self) {
        _webView = webView;
        _lifecycle = [[YTKWebViewLifecycle alloc] initWithWebView:webView];
        _bridge = [[YTKJsBridge alloc] initWithWebView:webView];
    }
    return self;
}

#pragma mark - Public Methods

- (NSString *)callJsCommandName:(NSString *)commandName
                       argument:(nullable NSArray *)argument {
    NSString *result = [self.bridge callJsCommandName:commandName argument:argument];
    return result;
}

- (void)addJsCommandHandlers:(NSArray *)handlers namespace:(NSString *)namespace {
    [self.bridge addJsCommandHandlers:handlers namespace:namespace];
}

- (void)removeJsCommandHandlerForNamespace:(NSString *)namespace {
    [self.bridge removeJsCommandHandlerForNamespace:namespace];
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
