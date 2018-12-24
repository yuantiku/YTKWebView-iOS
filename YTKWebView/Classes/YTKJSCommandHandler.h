//
//  YTKJSCommandHandler.h
//  YTKWebView
//
//  Created by lihaichun on 2018/12/21.
//  Copyright © 2018年 fenbi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YTKJSCommand;
@class UIWebView;

@protocol YTKJSCommandHandler <NSObject>

@property (nonatomic, weak, nullable) UIWebView *webView;

- (void)handleJSCommand:(YTKJSCommand *)command inWebView:(UIWebView *)webView;

@end

NS_ASSUME_NONNULL_END
