//
//  YTKWebViewLifecycle.h
//  YTKWebView
//
//  Created by lihaichun on 2018/12/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

/** 生命周期变化通知 */
FOUNDATION_EXPORT NSString * const YTKWebViewLifecycleStateDidChangeNotification;
FOUNDATION_EXPORT NSString * const YTKWebViewLifecycleStateKey;
FOUNDATION_EXPORT NSString * const YTKWebViewKey;

typedef NS_ENUM(NSInteger, YTKWebViewLifecycleState) {
    YTKWebViewLifecycleStateInit = 0,     /** 初始化 */
    YTKWebViewLifecycleStateLoading = 1,  /** 加载中 */
    YTKWebViewLifecycleStateSucceed = 2,  /** 加载完毕 */
    YTKWebViewLifecycleStateFailed = 3,   /** 加载失败 */
    YTKWebViewLifecycleStateClose = 4,    /** 关闭 */
};

@class YTKWebViewLifecycle;

@protocol YTKWebViewLifecycleDelegate <NSObject>

/** 生命周期发生变化回调方法 */
- (void)webViewLifecycle:(YTKWebViewLifecycle *)lifecycle webView:(UIWebView *)webView lifecycleStateDidChange:(YTKWebViewLifecycleState)state;

@end

@interface YTKWebViewLifecycle : NSObject

/** 当前webView的生命周期 */
@property (nonatomic) YTKWebViewLifecycleState state;

/** default NO */
@property (nonatomic) BOOL manualControlLifecycle;

@property (nonatomic, weak, nullable) id<YTKWebViewLifecycleDelegate> delegate;

/** 需要在webview开始loadURL之前的设置 */
- (instancetype)initWithWebView:(UIWebView *)webView;

@end

NS_ASSUME_NONNULL_END
