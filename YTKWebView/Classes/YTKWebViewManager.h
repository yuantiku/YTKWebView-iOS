//
//  YTKWebViewManager.h
//  YTKWebView
//
//  Created by lihaichun on 2018/12/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

/** 生命周期变化通知 */
FOUNDATION_EXPORT NSString * const YTKWebViewLifecycleDidChangeNotification;
FOUNDATION_EXPORT NSString * const YTKWebViewLifecycleKey;
FOUNDATION_EXPORT NSString * const YTKWebViewKey;

typedef NS_ENUM(NSInteger, YTKWebViewLifecycle) {
    YTKWebViewLifecycleInit = 0,     /** 初始化 */
    YTKWebViewLifecycleLoading = 1,  /** 加载中 */
    YTKWebViewLifecycleSucceed = 2,  /** 加载完毕 */
    YTKWebViewLifecycleFailed = 3,   /** 加载失败 */
    YTKWebViewLifecycleClose = 4,    /** 关闭 */
};

@class YTKWebViewManager;

@protocol YTKWebViewManagerDelegate <NSObject>

/** 生命周期发生变化回调方法 */
- (void)webViewManager:(YTKWebViewManager *)manager webView:(UIWebView *)webView lifecycleDidChange:(YTKWebViewLifecycle)lifecycle;

@end

@interface YTKWebViewManager : NSObject

/** 当前webView的生命周期 */
@property (nonatomic, readonly) YTKWebViewLifecycle lifecycle;

/** default NO */
@property (nonatomic) BOOL manualControlLifecycle;

@property (nonatomic, weak, nullable) id<YTKWebViewManagerDelegate> delegate;

/** 需要在webview开始loadURL之前的设置 */
- (instancetype)initWithWebView:(UIWebView *)webView;

@end

NS_ASSUME_NONNULL_END
