//
//  YTKWebViewManager.m
//  Pods-YTKWebView_Example
//
//  Created by lihaichun on 2018/12/29.
//

#import "YTKWebViewManager.h"
#import "YTKWebViewURLProtocol.h"
#import "YTKWebRequestAgent.h"

@implementation YTKWebViewManager

+ (void)initialize {
    [NSURLProtocol registerClass:[YTKWebViewURLProtocol class]];
    [YTKWebRequestAgent sharedAgent];
}

@end
