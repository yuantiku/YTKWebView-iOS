//
//  YTKViewController.m
//  YTKWebView
//
//  Created by lihc on 12/24/2018.
//  Copyright (c) 2018 lihc. All rights reserved.
//

#import "YTKViewController.h"
#import "YTKWebViewManager.h"
#import "YTKWebRequestAgent.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YTKViewController () <YTKWebViewCacheFileLoader>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YTKViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [YTKWebViewManager new];
    [YTKWebRequestAgent sharedAgent].cacheLoader = self;

    [self.view addSubview:self.webView];
    [self.view addSubview:self.webView];
    self.webView.frame = self.view.frame;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    NSURL *URL = [NSURL URLWithString:@"https://www.quanjing.com/imgbuy/QJ6919057308.html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
}

#pragma mark - YTKWebViewCacheFileLoader

- (BOOL)loadFileByNativeWithRequest:(NSURLRequest *)request {
    if ([request.URL.pathExtension isEqualToString:@"png"] || [request.URL.pathExtension isEqualToString:@"jpg"]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)loadFileWithRequest:(NSURLRequest *)request completion:(void (^)(NSData *data, NSError *error))completion {
    [[SDWebImageManager sharedManager] loadImageWithURL:request.URL options:SDWebImageHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        completion(data, error);
    }];
}

- (void)stopLoadingWithReqest:(NSURLRequest *)request {
    /** 取消当前request的loading */
}

- (NSString *)webViewUserAgent {
    return nil;
}

#pragma mark - Getter

- (UIWebView *)webView {
    if (nil == _webView) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}

@end
