//
//  YTKWebViewJSManager.h
//  YTKWebView
//
//  Created by lihaichun on 2018/12/21.
//  Copyright © 2018年 fenbi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YTKJSCommandHandler;

@interface YTKWebViewJSManager : NSObject

/** 调用js commandName方法 */
+ (NSString *)callJSCommandName:(NSString *)commandName
                       argument:(NSArray *)argument
                   errorMessage:(NSString *)errorMessage
                      inWebView:(UIWebView *)webView;

- (instancetype)initWithWebView:(UIWebView *)webView;

/** 注入js方法commandName, 方法实现类handler */
- (void)addJSCommandHandler:(id<YTKJSCommandHandler>)handler forCommandName:(NSString *)commandName;

@end

NS_ASSUME_NONNULL_END
