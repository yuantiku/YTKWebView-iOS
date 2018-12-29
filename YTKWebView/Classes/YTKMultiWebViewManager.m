//
//  YTKMultiWebViewManager.m
//  YTKWebView
//
//  Created by lihaichun on 2019/1/2.
//

#import "YTKMultiWebViewManager.h"

@interface YTKMultiWebViewManager () <YTKWebViewManagerDelegate>

@property (nonatomic, strong) NSMapTable<UIWebView *, YTKWebViewManager *> *managers;

@end

@implementation YTKMultiWebViewManager

- (instancetype)initWithWebViews:(NSArray<UIWebView *> *)webViews {
    self = [super init];
    if (self) {
        _managers = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsStrongMemory];
        [webViews enumerateObjectsUsingBlock:^(UIWebView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (NO == [obj isKindOfClass:[UIWebView class]]) {
                return;
            }
            YTKWebViewManager *manager = [[YTKWebViewManager alloc] initWithWebView:obj];
            manager.delegate = self;
            [self.managers setObject:manager forKey:obj];
        }];
    }
    return self;
}

- (void)addWebView:(UIWebView *)webView {
    if (NO == [webView isKindOfClass:[UIWebView class]]) {
        return;
    }
    YTKWebViewManager *manager = [[YTKWebViewManager alloc] initWithWebView:webView];
    manager.delegate = self;
    [self.managers setObject:manager forKey:webView];
}

- (YTKWebViewLifecycle)lifecycleWithWebView:(UIWebView *)webView {
    if (nil == webView || nil == [self.managers objectForKey:webView]) {
        return YTKWebViewLifecycleInit;
    }
    YTKWebViewManager *manager = [self.managers objectForKey:webView];
    return manager.lifecycle;
}

#pragma mark - YTKWebViewManagerDelegate

- (void)webViewManager:(YTKWebViewManager *)manager webView:(UIWebView *)webView lifecycleDidChange:(YTKWebViewLifecycle)lifecycle {
    if ([self.delegate respondsToSelector:@selector(manager:webView:lifecycleDidChange:)]) {
        [self.delegate manager:self webView:webView lifecycleDidChange:lifecycle];
    }
}

#pragma mark - Setter

- (void)setManualControlLifecycle:(BOOL)manualControlLifecycle {
    _manualControlLifecycle = manualControlLifecycle;
    [[self.managers objectEnumerator].allObjects enumerateObjectsUsingBlock:^(YTKWebViewManager * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.manualControlLifecycle = manualControlLifecycle;
    }];
}


@end
