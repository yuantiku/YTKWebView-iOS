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

- (void)addSyncJsCommandName:(NSString *)commandName impBlock:(YTKSyncCallback)impBlock {
    [self.bridge addSyncJsCommandName:commandName impBlock:impBlock];
}

- (void)addSyncJsCommandName:(NSString *)commandName namespace:(nullable NSString *)namespace impBlock:(YTKSyncCallback)impBlock {
    [self.bridge addSyncJsCommandName:commandName namespace:namespace impBlock:impBlock];
}

- (void)addVoidSyncJsCommandName:(NSString *)commandName impBlock:(YTKVoidSyncCallback)impBlock {
    [self.bridge addVoidSyncJsCommandName:commandName impBlock:impBlock];
}

- (void)addVoidSyncJsCommandName:(NSString *)commandName namespace:(nullable NSString *)namespace impBlock:(YTKVoidSyncCallback)impBlock {
    [self.bridge addVoidSyncJsCommandName:commandName namespace:namespace impBlock:impBlock];
}

- (void)addAsyncJsCommandName:(NSString *)commandName impBlock:(YTKAsyncCallback)impBlock {
    [self.bridge addAsyncJsCommandName:commandName impBlock:impBlock];
}

- (void)addAsyncJsCommandName:(NSString *)commandName namespace:(nullable NSString *)namespace impBlock:(YTKAsyncCallback)impBlock {
    [self.bridge addAsyncJsCommandName:commandName namespace:namespace impBlock:impBlock];
}

/** 移除命名空间namespace下的注入的js commandName方法 */
- (void)removeJsCommandName:(NSString *)commandName namespace:(nullable NSString *)namespace {
    [self.bridge removeJsCommandName:commandName namespace:namespace];
}

/** 注册js事件监听处理block */
- (void)listenEvent:(NSString *)event callback:(YTKEventCallback)callback {
    [self.bridge listenEvent:event callback:callback];
}

/** 移除事件监听 */
- (void)unlistenEvent:(NSString *)event {
    [self.bridge unlistenEvent:event];
}

- (void)addListener:(id<YTKJsEventListener>)listener forEvent:(NSString *)event {
    [self.bridge addListener:listener forEvent:event];
}

- (void)removeListener:(id<YTKJsEventListener>)listener forEvent:(NSString *)event {
    [self.bridge removeListener:listener forEvent:event];
}

/** native发起事件通知给JS */
- (void)emit:(NSString *)event argument:(nullable NSArray *)argument {
    [self.bridge emit:event argument:argument];
}

- (void)setDebugMode:(BOOL)debug {
    [self.bridge setDebugMode:debug];
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
