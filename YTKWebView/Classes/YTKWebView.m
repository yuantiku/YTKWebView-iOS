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
                       argument:(nullable NSArray *)argument
                   errorMessage:(nullable NSString *)errorMessage {
    NSString *result = [YTKJsBridge callJsCommandName:commandName argument:argument errorMessage:errorMessage inWebView:self.webView];
    return result;
}

- (void)addJsCommandHandler:(id<YTKJsCommandHandler>)handler forCommandName:(NSString *)commandName {
    [self.bridge addJsCommandHandler:handler forCommandName:commandName];
}

- (void)removeJsCommandHandlerForCommandName:(NSString *)commandName {
    [self.bridge removeJsCommandHandlerForCommandName:commandName];
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
