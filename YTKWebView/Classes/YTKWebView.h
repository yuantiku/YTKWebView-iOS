//
//  YTKWebView.h
//  YTKWebView
//
//  Created by lihaichun on 2018/12/27.
//

#import <UIKit/UIKit.h>
#import "YTKWebViewLifecycle.h"

NS_ASSUME_NONNULL_BEGIN

@interface YTKWebView : UIView

@property (nonatomic, readonly) YTKWebViewLifecycleState state;

/** 是否手动控制webView的生命周期，默认NO */
@property (nonatomic) BOOL manualControlLifecycle;

@property (nonatomic, weak, nullable) id<YTKWebViewLifecycleDelegate> lifecycleDelegate;

@end

NS_ASSUME_NONNULL_END
