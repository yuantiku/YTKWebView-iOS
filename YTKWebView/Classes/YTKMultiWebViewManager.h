//
//  YTKMultiWebViewManager.h
//  YTKWebView
//
//  Created by lihaichun on 2019/1/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIWebView.h>
#import "YTKWebViewManager.h"

NS_ASSUME_NONNULL_BEGIN

@class YTKMultiWebViewManager;

@protocol YTKMultiWebViewManagerDelegate <NSObject>

- (void)manager:(YTKMultiWebViewManager *)manager webView:(UIWebView *)webView lifecycleDidChange:(YTKWebViewLifecycle)lifecycle;

@end

@interface YTKMultiWebViewManager : NSObject

@property (nonatomic, weak, nullable) id<YTKMultiWebViewManagerDelegate> delegate;

/** default NO */
@property (nonatomic) BOOL manualControlLifecycle;

- (instancetype)initWithWebViews:(NSArray<UIWebView *> *)webViews;

- (void)addWebView:(UIWebView *)webView;

- (YTKWebViewLifecycle)lifecycleWithWebView:(UIWebView *)webView;

@end

NS_ASSUME_NONNULL_END
