//
//  UIWebView+YTKSwizzling.h
//  YTKWebView
//
//  Created by lihaichun on 2018/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const YTKDidCallWebViewSetDelegateNotification;
FOUNDATION_EXPORT NSString * const YTKDidCallSetDelegateManagerKey;
FOUNDATION_EXPORT NSString * const YTKDidCallSetDelegateDelegateKey;

@interface UIWebView (YTKSwizzling)

@end

NS_ASSUME_NONNULL_END
