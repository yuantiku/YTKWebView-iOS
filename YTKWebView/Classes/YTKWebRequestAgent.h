//
//  YTKWebRequestAgent.h
//  YTKWebView
//
//  Created by lihaichun on 2018/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YTKWebViewCacheFileLoader <NSObject>

/** 判断是否需要拦截当前request */
- (BOOL)loadFileByNativeWithRequest:(NSURLRequest *)request;

/** 加载request */
- (void)loadFileWithRequest:(NSURLRequest *)request completion:(void (^)(NSData *data, NSError *error))completion;

@optional

/** 取消加载 */
- (void)stopLoadingWithRequest:(NSURLRequest *)request;

/** 如果调用者单独设置过UIWebView的UserAgent，将其返回，如果设置了UserAgent但是没有返回，将会导致UIWebView发送的请求无法被拦截 */
- (NSString *)webViewUserAgent;

@end

@interface YTKWebRequestAgent : NSObject

+ (instancetype)sharedAgent;

@property (nonatomic, weak, nullable) id<YTKWebViewCacheFileLoader> cacheLoader;

@end

NS_ASSUME_NONNULL_END
